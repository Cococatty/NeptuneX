rm(list = ls(all = TRUE))

# getwd()

library(data.table)

source("Main Functions.R")

dtConslidated <<- data.table( Reference = character()
                      , OtherParty = character()
                      , Amount = numeric()
                      , AcctType = character()
                      , Note = character()
                      # , ID = integer()
                      , TransactionDate = ymd()
                      , TransWDay = integer()
                      , TransDay = integer()
                      , TransMonth = integer()
                      , TransYear = integer()
)



dtColStructure <<- data.table(
  AcctType = c("CC", "Daily")# , "Loan"
  , Reference = c("CreditPlanName", "AnalysisCode")
  , OtherParty = c("OtherParty", "OtherParty-Particulars")
  , Amount = c("Amount", "Amount")
  , Note = c("ForeignDetails", "Description")
  , TransDate = c("TransactionDate", "Date")
) 

# MonthsToProcess <<- c("2018-4", "2018-5")
MonthsToProcess <<- "2018-4"



processData()



####################          CHOOSING OBJECTS TO BE SAVED AS RDATA - BEGINS           ####################

objToSearchNSave <- c("data", "colsList", "dt")
saveToRData(objToSearchNSave)

####################          CHOOSING OBJECTS TO BE SAVED AS RDATA - ENDS           ####################



loadRData()
