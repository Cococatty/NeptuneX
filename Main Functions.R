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
  # currentID <<- ifelse(nrow(dtConslidated) == 0, 1, nrow(dtConslidated))
  # currentID <<- ifelse(nrow(dtResult) == 0, 1, nrow(dtResult))
  
  
  ##  i for Accounts
  for (i in 1:nrow(dtColStructure)) {
    acctRow <- dtColStructure[i,]
    
    dtRawTransactions <- loadData(AcctNum = acctRow$AcctNum, MonthsToProcess = MonthsToProcess)
    
    
    ##  Fixed Columns
    TransDateCol <- dmy(dtRawTransactions[, get(acctRow$TransDate)])
    dtResult <- data.table(TransactionDate = ymd(TransDateCol)
                     , TransWDay = wday(TransDateCol, label = TRUE)
                     , TransDay = mday(TransDateCol)
                     , TransMonth = month(TransDateCol)
                     , TransYear = year(TransDateCol)
                     , AcctType = acctRow$AcctType
    )
    
    acctRow[, c("AcctType", "AcctNum", "TransDate") := NULL]
    
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
    
    ##  Merge into Final Result
    dtConslidated <<- rbind(dtConslidated, dtResult)
    # , fill = TRUE
  }
  
  
  # return(dtResult)
}


##########            PREPARE DATA FOR REPORT            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##

categroizeGrouping <- function(){
  dtReportData <<- dtConslidated
  dtReportData[, ":=" (
    Debit = ifelse(Amount < 0, Amount, NA)
    , Credit = ifelse(Amount > 0, Amount, NA)
    , Category = ifelse(Amount < 0, "Debit", "Credit")
  )]
  
  ##  If Account is of "Home", then count it as "Household"
  dtReportData[grep("Home", AcctType), Group := "HouseHold"]
  
  ##  Otherwise, assign Group by setup in acctKeywordsList
  for (i in names(acctKeywordsList)) {
    print(i)
    lsKeys <- unlist(acctKeywordsList[i])
    strKeys <- grepl(pattern = paste0(lsKeys, collapse = "|"), x = dtReportData$OtherParty, ignore.case = TRUE)
    print(paste0(lsKeys, collapse = "|"))
    dtReportData[(strKeys == TRUE), Group := i]
  }
  
  fwrite(x = dtReportData[is.na(Group),], file = "Outputs/MI - Groups to Clear.tsv", sep = "\t")
}



##########            APPLY TIME SERIES TO DATA            ##########
##  PURPOSE:
##  1. Assign relevant categories
##  2. Grouping data for reporting
##
applyTimeSeries <- function(){
  
}


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
## c99818c3437de6ed81d7201ccf49a812f1847655
#   print(j)
# }
# 
# 
# 
# Archived
# # dtResult[, ID := seq(from = currentID, by = 1, to = currentID + nrow(dtResult) - 1 )]

# print("not in loop")
# print(j)
# print(colComponent)

