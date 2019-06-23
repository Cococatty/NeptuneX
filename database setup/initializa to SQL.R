###   This function document is called when the application is first loaded, to prepare data 
### This file should be run before pushing new code to Shiny IO


library(assertr)
library(magrittr)
library(data.table)
library(lubridate)
library(stringr)
library(car)

connection <- dbConnect(RSQLite::SQLite(), "NeptuneX")

TablesMappings <- dbReadTable(connection, "TablesMappings")
dtTablesMappings <<- data.table(TablesMappings)

for (i in TablesMappings$ID) {
  row <- TablesMappings[i,]
  get(row$RTable) <- dbReadTable(connection, row$SQLTable)
  get(row$RTable)
}


##########            RANDOMIZING VALUES            ##########
##  PURPOSE:
##  1. Format a date column so that it can be derived into required columns.
##  2. Remove columns that are not required
##

dtRecurringRandomized <- data.table(GLID = as.integer(dbGetQuery(connection, 'SELECT ID FROM GLAccounts WHERE "Code" = "Income" '))
                                                 , Name = c("Salary", "Rental")
                                    , RanPercent = c(runif(2, min = 0.7, max = 2)))

write.csv(x = dtRecurringRandomized, file = "inputs/randomizedLog.csv")

randomizeValue <- function(dtSource) {
  dbListTables(connection)
  dfRecurringItems <- dbReadTable(connection, "RecurringTransactionItems")
  
  dfRecurringTrans <- dbReadTable(connection, "RecurringTransactionKeywords")
  dtRecurringTrans <- data.table(dfRecurringTrans,)
  
  if (grepl()
      dtSource$Reference
  dtSource$OtherParty
  dtSource$Note
  )
  * 
          
  dtSource[, ":=" (Amount = round(as.numeric(finalAmount)), 2)
                   # , Amount = 
  )]
  
  # dtRandomization
  # if (dtSource$BalType == "Credit" & dtSource$Note == "Salary")
  dtSource
  dtSource[, ":=" (Amount = as.numeric(Amount) 
                   # , Amount = round(as.numeric(Amount) * runif(1, min = 0.5, max = 2), 2)
  )]
  
}

##########            FORMAT RAW DATA BY REQUIREMENTS            ##########
##  PURPOSE:
##  1. Format a date column so that it can be derived into required columns.
##  2. Remove columns that are not required
##

basicConsolidating <- function() {
  
  rawDataFiles <- list.files(path = "inputs", pattern=NULL, all.files=FALSE, full.names=FALSE)
  
  ##  TO BE UPDATED TO USE TABLESMAPPINGS
  dtColStructure <- dbReadTable(connection, "AccountsStructures")
  
  ##  i for Accounts
  for (i in 1:nrow(dtColStructure)) {
    acctRow <- data.table( dtColStructure[i,])
    
    ##  FIND THE RIGHT FILE TO READ
    fileToRead <- paste0("inputs/", rawDataFiles[ grep(acctRow$AcctNum, rawDataFiles) ])
    dtRawTransactions <- data.table(read.csv(fileToRead
                                             , colClasses = c("character"))
                                    , stringsAsFactors = F)
    
    ##  TAKE OUT SPECIAL CHARACTER OF "." IN COLUMN NAMES
    names(dtRawTransactions) <- gsub(pattern = "[.]", x = names(dtRawTransactions), "")
    
    ##  Fixed Columns
    TransDateCol <- dmy(dtRawTransactions[, get(acctRow$TransDate)])
    dtResult <- data.table(TransDate = ymd(TransDateCol)
                           , TransWDay = wday(TransDateCol, label = TRUE)
                           , TransDay = mday(TransDateCol)
                           , TransMonth = format.Date(TransDateCol, "%m")
                           , TransYear = year(TransDateCol)
                           , BankAcct = unlist(lapply(acctRow$AcctNum, function(x) switch(str_sub(x, -3, -1)
                                                                                          , "144" = "Credit Card"
                                                                                          , "000"  = "Daily"
                                                                                          , "017"  = "Saver"
                                                                                          , "025"  = "Home Bills"
                                                                                          , "091"  = "Home Loan")))
    )
    
    acctRow[, c("ID", "AcctNum", "TransDate") := NULL]
    
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
    
    ## Randomize Amounts as part of the data confidentialization                           
    # dtResult <- randomizeValue(dtResult)
    dtResult[, ":=" (Amount = as.numeric(Amount) 
                     # , Amount = round(as.numeric(Amount) * runif(1, min = 0.5, max = 2), 2)
    )]
    
    
    ##  Randomize values
    ### Check if entry in Income, if so, record the randomized value; if not, go ahead with random percentange
    dtResult <- randomizeValue(dtResult)
    
    ##  Write to DB instead
    ##  Reorder Columns
    setcolorder(dtResult, names(dtFormattedRawData))
    
    ##  Merge into Final Result
    dtFormattedRawData <<- rbind(dtFormattedRawData, dtResult)
    dtFormattedRawData <<- dtFormattedRawData[order(TransDate, BankAcct)]
    # , fill = TRUE
  }
  updateAcctProcessRange(dtFormattedRawData)
  # return(dtResult)
}



##########            ACCOUNTS DATES TABLE            ##########
##  PURPOSE:
##  1.  Hold records of date ranges by accounts, so that the relevant info can be used in display and potentially, 
##      further process.
##
updateAcctProcessRange <- function(dtData) {
  # dtData <- dtResult
  MinDates <- aggregate(TransDate~BankAcct, data = dtData, FUN=min)
  colnames(MinDates)[colnames(MinDates) == "TransDate"] <- "MinDate"
  
  MaxDates <- aggregate(TransDate ~ BankAcct, data = dtData, max)
  colnames(MaxDates)[colnames(MaxDates) == "TransDate"] <- "MaxDate"
  
  dtAcctDates <<- merge(MinDates, MaxDates, by = "BankAcct")
}


##########            PREPARE DATA FOR REPORT            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##

categorizeGrouping <- function(){
  dtReportData <<- dtFormattedRawData
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



##########            BUILD EXPECTED SERIES OF INCOME DATA            ##########
##  PURPOSE:
##  1. 
##

buildExpectedIncome <- function(selectedDateRange) {
  
  drStart <- ymd(selectedDateRange[1])
  drEnd <- ymd(selectedDateRange[2])
  
  dtExpectedIncomeSeries <- data.table(SeqID = integer(), AcctName = character()
                                       , Frequency = character(), ExpDate = ymd(), Amount = numeric()
  )
  
  for (i in 1:nrow(dtExpectedIncome)) {
    row <- dtExpectedIncome[i]
    currentDate <- drStart
    setEndDate <- drEnd
    
    if (currentDate < row$StartDate) currentDate <- ymd(row$StartDate)
    if (setEndDate > row$EndDate) setEndDate <- ymd(row$EndDate)
    
    seqID <- 1
    
    while (currentDate <= setEndDate) {
      dtTemp <- data.table(SeqID = seqID, AcctName = row$Name, Frequency = row$Frequency
                           , ExpDate = currentDate, Amount = row$Amount
      )
      
      lisrResult = list(dtExpectedIncomeSeries, dtTemp)
      dtExpectedIncomeSeries <- rbindlist(lisrResult, use.names = TRUE)
      ##  MONTHLY INCOME, OR FORTNIGHTLY + WEEKLY INCOME
      if (row$FreqInt == 1) currentDate <- currentDate + months(1) else currentDate <- currentDate + days(7 * row$FreqInt)
      
      seqID <- seqID + 1 
    }
  }
  # dtExpectedIncomeSeries <<- randomizeValue(dtExpectedIncomeSeries)
  
  return(dtExpectedIncomeSeries)
}

