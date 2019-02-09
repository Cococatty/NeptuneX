# install.packages("assertr")
library(assertr)
library(magrittr)

##########            LOAD RAW DATA TO ENVIRONMENT            ##########


## Example fileName is # AXXXX_XXXX_XXXX_6144-07Nov18.csv
loadData <- function(AcctNum, MonthsToProcess) {
  fileToRead <- paste0("Inputs/", AcctNum, "-", MonthsToProcess, ".csv")
  importedData <- data.table(read.csv(fileToRead
                      , colClasses = c("character"))
             , stringsAsFactors = F)
  
  ##  TAKE OUT SPECIAL CHARACTER OF "." IN COLUMN NAMES
  names(importedData) <- gsub(pattern = "[.]", x = names(importedData), "")
  return(importedData)
}


##########            FORMAT RAW DATA BY REQUIREMENTS            ##########
##  PURPOSE:
##  1. Format a date column so that it can be derived into required columns.
##  2. Remove columns that are not required
##

basicConsolidating <- function() {

  ##  i for Accounts
  for (i in 1:nrow(dtColStructure)) {
    acctRow <- dtColStructure[i,]
    
    dtRawTransactions <- loadData(AcctNum = acctRow$AcctNum, MonthsToProcess = MonthsToProcess)
    
    ##  Set up BankAcct value by last 3 digits of accout number
     BankAcct <- switch(str_sub(acctRow$AcctNum, -3, -1) 
                        , "144" = "CC" 
                        , "000"  = "Daily"
                        , "017"  = "Saver"
                        , "025"  = "Home Bills"
                        , "091"  = "Home Loan"
     )
     
    ##  Fixed Columns
    TransDateCol <- dmy(dtRawTransactions[, get(acctRow$TransDate)])
    dtResult <- data.table(TransDate = ymd(TransDateCol)
                     , TransWDay = wday(TransDateCol, label = TRUE)
                     , TransDay = mday(TransDateCol)
                     , TransMonth = month(TransDateCol)
                     , TransYear = year(TransDateCol)
                     , BankAcct = BankAcct
    )
    
    acctRow[, c("AcctNum", "TransDate") := NULL]
    
    ##  Dynamic Columns, retrieve by columns' names
    for (j in names(acctRow)) {
      colComponent <- acctRow[, get(j)]
   
      ##  If Column is a combo of multiple fields
      ##  TO SOLVE: WHY does the IF fails when grepl('[^[:punct:]]', "CC")????
        if (grepl('-', colComponent)) {
          # print(paste0("in the special loop! colComponent is ", colComponent))
          colObjs <- unlist(strsplit(x = colComponent, split = "-"))
          dtObjs <- dtRawTransactions[, mget(colObjs)]
          ##    TO DO:
          ##    Extra "-" when there's only one object #1
          ##    Remove - if length = 1. Tried: ifelse(length(unique(x)) > 1, "-", ""), NOT working
          objsValues <- apply(dtObjs, 1, function(x) paste0(unique(x), collapse = "-"))
          dtResult[, as.character(j) := objsValues ]
          # col_concat(dtObjs, sep = " - ")
      } else  {
        dtResult[, as.character(j) := dtRawTransactions[, get(colComponent)] ]
      }
    }
    
    
    
    ##  Reorder Columns
    setcolorder(dtResult, names(dtConslidated))
    dtResult[, Amount := as.numeric(Amount)]
    
    ##  Merge into Final Result
    dtConslidated <<- rbind(dtConslidated, dtResult)
    
    updateAcctProcessRange(dtConslidated)
    
    # , fill = TRUE
  }
  
  
  # return(dtResult)
}


updateAcctProcessRange <- function(dtData) {
  # dtData <- dtConslidated
  minDates <- aggregate(TransDate ~ BankAcct, data = dtData, min)
  colnames(minDates)[colnames(minDates) == "TransDate"] <- "minDate"
  
  maxDates <- aggregate(TransDate ~ BankAcct, data = dtData, max)
  colnames(maxDates)[colnames(maxDates) == "TransDate"] <- "maxDate"
  
  dtAcctDates <<- merge(minDates, maxDates, by = "BankAcct")
  
  # if (nrow(dtAcctProcessedRange) == 0 )  dtAcctProcessedRange <<- rbind(dtAcctProcessedRange, dtAcctDates)
  # else dtAcctProcessedRange[ BankAcct == dtAcctProcessedRange$BankAcct]
}

##########            PREPARE DATA FOR REPORT            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##

categorizeGrouping <- function(){
  dtReportData <<- dtConslidated
  dtReportData[, ":=" (
    Debit = ifelse(Amount < 0, abs(Amount), 0)
    , Credit = ifelse(Amount > 0, abs(Amount), 0)
    , AcctType = ifelse(Amount < 0, "Debit", "Credit")
  )]
  
  ##  If Account is of "Home", then count it as "Household"
  dtReportData[grep("Home", BankAcct), Category := "HouseHold"]
  
  ##  Otherwise, assign Category by setup in acctKeywordsList
  for (i in names(acctKeywordsList)) {
    # print(i)
    lsKeys <- unlist(acctKeywordsList[i])
    strKeys <- grepl(pattern = paste0(lsKeys, collapse = "|"), x = dtReportData$OtherParty, ignore.case = TRUE)
    # print(paste0(lsKeys, collapse = "|"))
    dtReportData[(strKeys == TRUE), Category := i]
  }
  
  fwrite(x = dtReportData[is.na(Category),], file = "Outputs/MI - Groups to Clear.tsv", sep = "\t")
}







####################            ANALYSIS DATA            ####################
calcDebVSCred <- function() {
  dtCalc <- tapply(abs(as.numeric(dtReportData$Amount)), dtReportData$AcctType, FUN=sum)
  dtResult <- data.table(Credit = dtCalc["Credit"]
                         , Debit = dtCalc["Debit"])
  
  # get(dtCalc[i])
  # dtCalc[get(as.character(i))]
  # dtResult <- setNames(data.table(
  #   matrix(nrow = 0, ncol = length(dtCalc))), c(names(dtCalc))
  #   )
  # for (i in names(dtCalc)) {
  #   dtResult[, as.character(i) := dtCalc[names(dtCalc)]]
  # }
  
  # dtReportData[, sum(Amount), by = .(AcctType)]
  # aggregate(as.numeric(dtReportData$Amount), by = list(AcctType = dtReportData$AcctType), FUN = sum)
  return(dtResult)
}

##########            APPLY TIME SERIES TO DATA            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##


plotTSSimple <- function(selectedAcct, selectDateRange) {
  # selectedAcct <- "CC"
  # selectDateRange <- c("2018-12-01", "2018-12-30")
  # print(selectDateRange)
  sprintf("date range is %s", selectDateRange)
  dtTargetData <- dtReportData[ BankAcct == selectedAcct & TransDate %between%selectDateRange, ]
  dtSumByDate <- aggregate(Debit~ TransDate, data = dtTargetData, FUN = sum)
  (dtSumByDate)
  
  plotTitle <- sprintf("Spending total by Date in %s from %s"
                      , selectedAcct, paste0(selectDateRange, collapse = " to "))
  plot(x = dtSumByDate$TransDate, y = dtSumByDate$Debit, main = plotTitle, type = "b"
       , xlab = "Transaction Date", ylab = "Amount ($)")
  # plot.ts(dtSumByDate, start = )
}

##  TO ENHANCE
buildTSData <- function(tsGroup) {
  BankAcct <- "CC"
  tsGroup <- "BankAcct"
  
  ##  1. Subset data
  dtTS <- subset(dtReportData, BankAcct == "CC", select = c(TransYear, TransMonth, Debit) )
  
  ##  Calculate the sums
  dtSums <- aggregate(Debit ~ . , data = dtTS, FUN = sum)
  plot(y = dtSums$Debit, x = dtSums$TransMonth)
  install.packages("car")
  library(car)
  scatterplot(Debit~ TransYear | TransMonth, data= dtSums)
  tsSum <- ts(dtSums$Debit, start = c(2018, 11), frequency = 1)
  plot.ts(tsSum)
  plot(x = dtSums$TransYear, y = dtSums$Debit)
  ??scatterplot
  names(dtTS)
  rowFirst <- dtReportData[1,]
  # ts(dtTS, start = c(rowFirst$TransYear, rowFirst$TransMonth), frequency = 12 )
  # dtTS[, sum(Debit), by = .(TransYear, TransMonth)]
  # aggregate(as.numeric(abs(dtReportData$Amount)), by = list(AcctType = dtReportData$AcctType), FUN = sum)
  return(dtResult)
}



########################          TO COMPLETE          ########################
lmMnthlySpending <- function() {
  lmMnthly <- lm(Amount~TransactionDate + AcctType + Category, data = dtReportData)
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
  names(dtConslidated)
  
  dtResult$Note
  dtConslidated$Note

  
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
