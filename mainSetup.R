rm(list = ls(all = TRUE))

# getwd()

library(data.table)
library(lubridate)
library(shinythemes)
library(googleVis)

# source("Setup Data.R")
source("mainFunctions.R")

##################                  STRUCTURAL SETUP                  ##################
dtFormattedRawData <<- data.table(
                      Reference = character()
                      , OtherParty = character()
                      , Amount = numeric()
                      , BankAcct = character()
                      , Note = character()
                      # , ID = integer()
                      , TransDate = ymd()
                      , TransWDay = integer()
                      , TransDay = integer()
                      , TransMonth = integer()
                      , TransYear = integer()
)


dtAcctDates <<- data.table(
  BankAcct = character()
  , MinDate = ymd()
  , MaxDate = ymd()
)

qsIncomeValues <<- list("receivedAll", "missPayments")
qsIncomeNames <<- list("Have I received all expected money?", "What payments are missing?")

##################                  BACKGROUND DATA SETUP                  ##################

dtColStructure <<- data.table(
  # BankAcct = c("CC", "Daily", "Saver", "Home Bills", "Home Loan")
  AcctNum = c("AXXXX_XXXX_XXXX_6144", "A0315920567389000", "A0315920567389017","A0315920567389025", "A0315920567389091")
  , Reference = c("CreditPlanName", "AnalysisCode", "Particulars", "Particulars-AnalysisCode", "Particulars-AnalysisCode")
  , OtherParty = c("OtherParty", "OtherParty-Particulars", "OtherParty-Description", "OtherParty", "OtherParty")
  , Amount = c("Amount", "Amount", "Amount", "Amount", "Amount")
  , Note = c("ForeignDetails", "Description", "AnalysisCode-Reference", "Description", "Description")
  , TransDate = c("TransactionDate", "Date", "Date", "Date", "Date")
) 



acctKeywordsList <<- list(
                              Household = list("Home Loan", "Home Repayment", "Home Bills", "CCC", "Powershop", "Two Degrees"
                                               , "Loan")
                            , MonthlyExp = list("LUMLEY", "2DEGREES")
                            , CCRepayment = list("PAYMENT RECEIVED")
                            , OccasionalExp = list("NPD")
                            , Grocery = list("Pak", "New World", "Countdown", "Seafoods", "Basics", "Freshchoice"
                                             , "HEALTHY HARVEST", "MAD BUTCHER", "Meats", "Central Wholesale")
                            , Shopping = list("Witchery", "Country road", "Trademe", "Trade me", "Farmers", "Life Pharmacy", "Pharmac", "Decjuba", "NYX"
                                           , "Cotton On", "Kmart", "Ballantynes", "SPOTLIGHT")
                            , OnlineShop = list("GrabOne", "TreatMe", "Catchoftheday", "Groupon", "PAYPAL", "AMZN Mktp")
                            , Coffee = list("ROBERT HARRIS", "LITTLE BREWS")
                            , Event = list("Stat NZ Social")
                            , Eatout = list("TJ", "Restaurant", "Dominos", "Riccarton Noodle")
                            , Income = list("Salary", "Investment", "McCulloch", "Saving", "Interest", "Holiday Credit"
                                            , "Saving")
                            , Donation = list("Kiwis for kiwi")
                            , Special = list("Honda", "Kingdom", "Immigration", "Transport", "Dental", "Post Shop")
                            , NY2019 = list("KAIKOURA", "KAIKOURA BAKERY", "ULA KAIKOURA","THE CRAYPOT", "WAIPARA AMBERLEY")
                            )



basicConsolidating()
categorizeGrouping()


##################                  DATA SETUP                  ##################

##########    THE DATE RANGE HAS TO BE SETUP AFTER BASIC OPERATION
dateRangeEnd <<- min(dtAcctDates$MaxDate)
dateRangeStart <<- dateRangeEnd %m-% months(6)

dateRangeMin <<- min(dtAcctDates$MinDate)
dateRangeMax <<- max(dtAcctDates$MaxDate)


# View(dtFormattedRawData)
# View(dtReportData)
# View(dtReportData[is.na(ExpCategory),])



# ####################          CHOOSING OBJECTS TO BE SAVED AS RDATA - BEGINS           ####################
# 
# objToSearchNSave <- c("data", "colsList", "dt")
# saveToRData(objToSearchNSave)
# 
# ####################          CHOOSING OBJECTS TO BE SAVED AS RDATA - ENDS           ####################
# 
# 
# 
# loadRData()
