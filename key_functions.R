library(assertr)
library(magrittr)
library(data.table)
library(lubridate)
library(stringr)
library(car)


##########            BUILD EXPECTED SERIES OF INCOME DATA            ##########
##  PURPOSE:
##  1. 
##

plan_income <- function(selectedDateRange) {
  
  start_date <- ymd(selectedDateRange[1])
  end_date <- ymd(selectedDateRange[2])
  
  dt_planned_incomeSeries <- data.table(SeqID = integer(), AcctName = character()
                                        , Frequency = character(), ExpDate = ymd(), Amount = numeric()
  )
  
  for (i in 1:nrow(dt_planned_income)) {
    row <- dt_planned_income[i]
    currentDate <- start_date
    setEndDate <- end_date
    
    if (currentDate < row$StartDate) currentDate <- ymd(row$StartDate)
    if (setEndDate > row$EndDate) setEndDate <- ymd(row$EndDate)
    
    seqID <- 1
    
    while (currentDate <= setEndDate) {
      print("I'm here!")
      dtTemp <- data.table(SeqID = seqID, AcctName = row$Name, Frequency = row$Frequency
                           , ExpDate = currentDate, Amount = row$Amount)
      lisrResult = list(dt_planned_incomeSeries, dtTemp)
      dt_planned_incomeSeries <- rbindlist(lisrResult, use.names = TRUE)
      ##  MONTHLY INCOME, OR FORTNIGHTLY + WEEKLY INCOME
      if (row$FreqInt == 1) currentDate <- currentDate + months(1) else currentDate <- currentDate + days(7 * row$FreqInt)
      
      seqID <- seqID + 1 
    }
  }
  
  print(dt_planned_incomeSeries)
  return(dt_planned_incomeSeries)
}


##########            PREPARE DATA FOR REPORT            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##

categorizeGrouping <- function(){
  dtReportData <<- dt_formatted_data
  dtReportData[, ":=" (
    Debit = ifelse(Amount < 0, abs(Amount), 0)
    , Credit = ifelse(Amount > 0, abs(Amount), 0)
    , BalType = ifelse(Amount < 0, "Debit", "Credit")
  )]
  
  ##  If Account is of "Home", then count it as "Household"
  dtReportData[grep("Home", BankAcct), ExpCategory := "HouseHold"]
  
  ##  Otherwise, assign Expense Category by setup in acctKeywordsList
  for (i in names(acctKeywordsList)) {
    # print(i)
    lsKeys <- unlist(acctKeywordsList[i])
    strKeys <- grepl(pattern = paste0(lsKeys, collapse = "|"), x = dtReportData$OtherParty, ignore.case = TRUE)
    # print(paste0(lsKeys, collapse = "|"))
    dtReportData[(strKeys == TRUE), ExpCategory := i]
  }
  
  # fwrite(x = dtReportData[is.na(ExpCategory),], file = "Outputs/MI - Groups to Clear.tsv", sep = "\t")
}


deriveSelectedDateRange <- function(selectedDateRange) {
  start_date <- selectedDateRange[1]
  end_date <- selectedDateRange[2]
  
  start_dateYear <- year(start_date)
  start_dateMonth <- format.Date(start_date, "%m")
  end_dateYear <- year(end_date)
  end_dateMonth <- format.Date(end_date, "%m")
  
  drValues <- list(start_dateYear = start_dateYear, start_dateMonth = start_dateMonth
                , end_dateYear = end_dateYear, end_dateMonth = end_dateMonth)
  return(drValues)
}


####################            SIMPLE PLOTS            ####################
plot_simple <- function(selectedAccts, selectedDateRange, selectedTab) {
  # print(selectedDateRange, str(selectedDateRange))
  # StartDate <- ymd(selectedDateRange[1])
  # EndDate <- ymd(selectedDateRange[2])
 
  ##  1. Subset data
  dtPlotData <- dt_formatted_data[(BankAcct == selectedAccts 
                                    & TransDate %between% selectedDateRange)
                                   , .(TransYear, TransMonth, Debit, BankAcct)]
  
  ##  Calculate the sums by selectedTab
  if (grepl("Month", selectedTab)) {
    dtSums <- aggregate(Debit ~ TransYear + TransMonth, data = dtPlotData, FUN = sum)
    
    ##  ascending order
    setorderv(dtSums, cols = c("TransYear", "TransMonth"), order=1L, na.last=FALSE)
    dtSums$TransYearMonth <- paste(dtSums$TransYear, dtSums$TransMonth, sep = "-")
    dtPlot <- data.table(TransYearMonth = dtSums$TransYearMonth, Debit = dtSums$Debit )
  }
  if (grepl("Annual", selectedTab)) {
    # print(paste0("in function selectedTab is ", selectedTab, collapse = "--"))
    
    dtSums <- aggregate(Debit ~ TransYear, data = dtPlotData, FUN = sum)
    ##  ascending order
    setorderv(dtSums, cols = "TransYear", order=1L, na.last=FALSE)
    dtPlot <- data.table(TransYear = dtSums$TransYear, Debit = dtSums$Debit )
  }

  return(dtPlot)
}




####################            ANALYSIS DATA            ####################
getDebVSCredTbl <- function(selectedAccts, selectedDateRange) {
  # selectedAccts <- c("Credit Card", "Daily")
  # selectedDateRange <- c(as.Date("2018-09-01"), as.Date("2019-04-01"))

  dtResult <- dtReportData[(BankAcct == selectedAccts 
                            & TransDate %between% selectedDateRange)
                           , .(TransDate, BankAcct, BalType, Amount, ExpCategory, Note)]
  
  setorderv(dtResult, cols = "TransDate", order=-1L, na.last=FALSE)

  return(dtResult)
}


calcDebCredTotals <- function(selectedAccts, selectedDateRange) {
  dtReport <- dtReportData[(BankAcct == selectedAccts 
                            & TransDate %between% selectedDateRange)
                           , .(BankAcct, BalType, Amount)]
  
  dtCalc <- tapply(abs(as.numeric(dtReportData$Amount)), dtReportData$BalType, FUN=sum)
  
  dtSums <- aggregate( abs(Amount) ~ BalType + BankAcct, data = dtReport, FUN = sum )
  
  dtResult <- data.table('Bank Account' = dtSums$BankAcct, 'Balance Type' = dtSums$BalType, 'Amount' = dtSums$`abs(Amount)`)

  # dtResult <- data.table(Credit = dtCalc["Credit"]
  #                        , Debit = dtCalc["Debit"])
  
  return(dtResult)
}


########################          TO COMPLETE          ########################
########################          
########################          
########################          
########################          
########################          
########################          
##########            APPLY TIME SERIES TO DATA            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##


plotTSSimple <- function(selectedAcct, selectDateRange) {
  if (length(selectedAcct) == 0) selectedAcct <- "CC"
  if (length(selectDateRange) == 0) selectDateRange <- c("2018-12-01", "2018-12-31")
  
  dtTargetData <- dtReportData[ BankAcct == selectedAcct & TransDate %between%selectDateRange, ]
  dtSumByDate <- aggregate(Debit~ TransDate, data = dtTargetData, FUN = sum)
  
  plotTitle <- sprintf("Spending total by Date in %s from %s"
                      , selectedAcct, paste0(selectDateRange, collapse = " to "))
  plot(x = dtSumByDate$TransDate, y = dtSumByDate$Debit, main = plotTitle, type = "b"
       , xlab = "Transaction Date", ylab = "Amount ($)")
  ##  SECTIONAL ARCHIVED CODE
  # plot.ts(dtSumByDate, start = )
  # # selectedAcct <- "CC"
  # selectDateRange <- c("2018-12-01", "2018-12-30")
  # print(selectDateRange)
  # sprintf("date range is %s", selectDateRange)
  # # (dtSumByDate)
}

##  TO ENHANCE
buildTSData <- function(tsGroup) {
  BankAcct <- "CC"
  tsGroup <- "BankAcct"
  
  ##  1. Subset data
  dtTS <- subset(dtReportData, BankAcct == "CC", select = c(TransYear, TransMonth, Debit) )
  
  ##  Calculate the sums
  dtSums <- aggregate(Debit ~ . , data = dtTS, FUN = sum)
  
  plot(y = dtSums$Debit, x = dtSums$TransMonth, line)
  
  
  scatterplot(Debit~ TransYear | TransMonth, data= dtSums)
  tsSum <- ts(dtSums$Debit, start = c(2018, 11), frequency = 1)
  
  ?ts
  
  plot.ts(tsSum)
  plot(x = dtSums$TransYear, y = dtSums$Debit)
  ??scatterplot
  names(dtTS)
  rowFirst <- dtReportData[1,]
  # ts(dtTS, start = c(rowFirst$TransYear, rowFirst$TransMonth), frequency = 12 )
  # dtTS[, sum(Debit), by = .(TransYear, TransMonth)]
  # aggregate(as.numeric(abs(dtReportData$Amount)), by = list(BalType = dtReportData$BalType), FUN = sum)
  return(dtResult)
}
