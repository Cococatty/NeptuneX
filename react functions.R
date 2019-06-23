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
compareIncomeToActual <- function(selectDateRange) {
  
}


deriveSelectedDateRange <- function(selectedDateRange) {
  drStart <- selectedDateRange[1]
  drEnd <- selectedDateRange[2]
  
  drStartYear <- year(drStart)
  drStartMonth <- format.Date(drStart, "%m")
  drEndYear <- year(drEnd)
  drEndMonth <- format.Date(drEnd, "%m")
  
  drValues <- list(drStartYear = drStartYear, drStartMonth = drStartMonth
                , drEndYear = drEndYear, drEndMonth = drEndMonth)
  return(drValues)
}


####################            SIMPLE PLOTS            ####################
plotSimple <- function(selectedAccts, selectedDateRange, selectedTab) {
  # print(selectedDateRange, str(selectedDateRange))
  # StartDate <- ymd(selectedDateRange[1])
  # EndDate <- ymd(selectedDateRange[2])
 
  ##  1. Subset data
  dtPlotData <- dtFormattedRawData[(BankAcct == selectedAccts 
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




lmMnthlySpending <- function() {
  lmMnthly <- lm(Amount~TransactionDate + BalType + ExpCategory, data = dtReportData)
  names(dtReportData)
}

plotMnthlySpending <- function(){
  dtReportData$Amount~dtReportData$TransactionDate
  
}

applyTimeSeries <- function(){
  
}


#######################                  ARCHIVED                  #######################
##########            SAVE OBJECTS MATCHING KEYWORDS LIST AS RDATA TO DATA FOLDER            ##########
saveToRData <- function(targetObjs) {
  targetObjs <- paste(targetObjs, collapse = "|")
  objToSave <- grep(targetObjs, ls(), value = TRUE)
  
  for(i in objToSave) {
    save(list = (i)
         , file = paste( "data/", i,".RData", sep = ""))
    ##
  }
}

##########            LOAD ALL RDATA IN DATA FOLDER            ##########
loadRData <- function() {
  rDataToLoad <- list.files("./data")
  for (i in rDataToLoad) {
    load(file = paste("data/", i, sep = ""), verbose = TRUE)  
  }
}
  

testComponent <- function() {
  dtTemp <- data.table(j = 1)
  
  names(dtResult)
  names(dtFormattedRawData)
  
  dtResult$Note
  dtFormattedRawData$Note

  
  # for (i in ncol(dtObjs))
  # tt <- paste(dtSource[, mget(colObjs)], collapse = "-") 
  # 
  # t2 <- paste0(mget(t), collapse = "-")
  # dtTemp[, as.character(j) := as.character(get(j))]
  
  
  
  paste0(c("a", "b"), "-")
  paste(c("a", "b"), collapse = "-")
  
  
  ma <- matrix(c(1:4, 1, 6:8), nrow = 2)
  ma
  apply(ma, 1, table)  #--> a list of length 2
  
  
  z <- array(1:24, dim = 2:4)
  zseq <- apply(z, 1:2, function(x) seq_len(max(x)))
  zseq         ## a 2 x 3 matrix
  typeof(zseq) ## list
  dim(zseq) ## 2 3
  zseq[1,]
  apply(z, 3, function(x) seq_len(max(x)))
  # a list without a dim attribute
  
  
  class(t)
  typeof(t)
  str(t)
  ncol(t)
  
# dtResult[, ":=" (Note = dtSource[, get(Note)]
}



# yearMonthValues <- deriveSelectedDateRange(plotDateRange)
# & TransYear >= yearMonthValues$drStartYear & TransYear <= yearMonthValues$drEndYear
# & TransMonth >= yearMonthValues$drStartMonth & TransMonth <= yearMonthValues$drEndMonth


# print("I'm here!")
