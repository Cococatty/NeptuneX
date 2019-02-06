# install.packages("assertr")
library(assertr)


##########            LOAD RAW DATA TO ENVIRONMENT            ##########


## Example fileName is "2018-4/CC.csv"
loadData <- function(AcctType) {
  fileToRead <- paste0("Inputs/", MonthsToProcess, "-", AcctType, ".csv")
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
##

processData <- function() {
  # currentID <<- ifelse(nrow(dtConslidated) == 0, 1, nrow(dtConslidated))
  # currentID <<- ifelse(nrow(dtResult) == 0, 1, nrow(dtResult))
  
  
  ##  i for Accounts
  for (i in 1:nrow(dtColStructure)) {
    acctRow <- dtColStructure[i,]
    
    dtRawTransactions <- loadData(AcctType = acctRow$Acct)
    
    ##  Fixed Columns
    TransDateCol <- dmy(dtRawTransactions[, get(acctRow$TransDate)])
    dtResult <- data.table(TransactionDate = ymd(TransDateCol)
                     , TransWDay = wday(TransDateCol, label = TRUE)
                     , TransDay = mday(TransDateCol)
                     , TransMonth = month(TransDateCol)
                     , TransYear = year(TransDateCol)
                     , AcctType = acctRow$AcctType
    )
    
    acctRow$AcctType <- NULL
    acctRow$TransDate <- NULL
    
    ##  Dynamic Columns, retrieve by columns' names
    for (j in names(acctRow)) {
      colComponent <- acctRow[, get(j)]
   
      ##  If Column is a combo of multiple fields
      ##  TO SOLVE: WHY does the IF fails when grepl('[^[:punct:]]', "CC")????
      if (grepl('-', colComponent)) {
        # print(paste0("in the special loop! colComponent is ", colComponent))
        colObjs <- unlist(strsplit(x = colComponent, split = "-"))
        dtObjs <- dtRawTransactions[, mget(colObjs)]
        dtResult[, as.character(j) := col_concat(dtObjs, sep = " - ") ]
      } else  {
        # if (j != "AcctType")
        # print("not in loop")
        # print(j)
        # print(colComponent)
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


##########            MERGE PROCESSED DATA TO CENTRAL DATASET            ##########
mergeToMainDT <- function(newData) {
  
  newDetails <- newData
  
  ##  DERIVE ASSOCIATING COLUMNS
  newDetails[, ':=' (
    ID = seq(from = lastID, by = 1, to = nrow(newDetails))
    , Day = mday(TransactionDate)
    , Month = month(TransactionDate)
    , Year = year(TransactionDate)
  )]
  
  newDetails[, TransactionDate := NULL]
  names(newDetails) <- names(dtConslidated)
  
  dtConslidated <<- rbind(dtConslidated, newDetails, fill = TRUE)
  lastID <<- (nrow(dtConslidated) + 1)
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

