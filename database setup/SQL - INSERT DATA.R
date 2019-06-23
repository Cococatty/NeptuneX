
# dtAccountCategoiries <- data.table(ID = seq(1:14), CategoryName = c(
#   "Household", "MonthlyExp", "CCRepayment"
#   , "OccasionalExp", "Grocery", "Shopping", "OnlineShop", "Coffee"
#   , "Event", "Eatout", "Income", "Donation", "Special", "NY2019"
# ))

dbExecute(
  connection,
  "INSERT INTO GLAccounts VALUES (?, ?, ?)",
  param = list(c(seq(1:14))
               , c("Household", "MonthlyExp", "CCRepayment", "OccasionalExp", "Grocery"
                   , "Shopping", "OnlineShop", "Coffee", "Event", "Eatout"
                   , "Income", "Donation", "Special", "NY2019")
               , c(rep(NA_character_, 14)))
)



nLen <- 2
dtRandomLog <- data.table(read.csv(file = "inputs/randomizedLog.csv")) 

dbExecute(
  connection,
  "INSERT INTO RecurringTransactionItems VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
  param = list(
    c(seq(1:nLen))
    , dtRandomLog$GLID # c(rep(as.integer(dbGetQuery(connection, 'SELECT ID FROM GLAccounts WHERE "Code" = "Income" ')), nLen))
    , dtRandomLog$Name # c("Salary", "Rental")
    , c(round(3000*dtRandomLog[Name == "Salary", RanPercent])
        , round(120*dtRandomLog[Name == "Rental", RanPercent]))
    , c("Fortnightly", "Weekly")
    , c(2, 4)
    , c(ymd("2019-06-11"), ymd("2019-06-11"))
    , c(rep(NA_real_, nLen))
    , c(rep("Credit", nLen))
  )
)



nLen <- 6
dbExecute(
  connection,
  "INSERT INTO RecurringTransactionKeywords VALUES (?, ?, ?)",
  param = list(
    c(seq(1:nLen))
    , c(rep(as.integer(dbGetQuery(connection, 'SELECT ID FROM RecurringTransactionItems WHERE "Name" = "Salary" ')), 3)
        , rep(as.integer(dbGetQuery(connection, 'SELECT ID FROM RecurringTransactionItems WHERE "Name" = "Rental" ')), 3)
        )
    , c("Salary", "Statistics", "Wage", "Rent", "McCulloch", "Josh")
  )
)


dbExecute(
  connection,
  "INSERT INTO QuestionTypes VALUES (?, ?, ?)",
  param = list(c(1, 2), c("Income", "Budget"), c("Income", "Budget"))
)


dbExecute(
  connection,
  "INSERT INTO Questions VALUES (?, ?, ?, ?)",
  param = list(c(1, 2), c(1, 1), c("receivedAll", "missPayments")
               , c("Have I received all expected money?", "What payments are missing?"))
)


dbExecute(
  connection,
  "INSERT INTO AccountsStructures VALUES (?, ?, ?, ?, ?, ?, ?)",
  param = list(
    c(seq(1:5))
    , c("6144", "000", "017","025", "091")
    , c("CreditPlanName", "AnalysisCode", "Particulars", "Particulars-AnalysisCode", "Particulars-AnalysisCode")
    , c("OtherParty", "OtherParty-Particulars", "OtherParty-Description", "OtherParty", "OtherParty")
    , c("Amount", "Amount", "Amount", "Amount", "Amount")
    , c("ForeignDetails", "Description", "AnalysisCode-Reference", "Description", "Description")
    , c("TransactionDate", "Date", "Date", "Date", "Date"))
    )


dbExecute(
  connection,
  "INSERT INTO DevTasks VALUES (?, ?, ?, ?, ?, ?)",
  param = list(
    c(1, 2)
    , c("Documentation by Shiny", "Time Series")
    , c("Create a task calendar", "Create a time series model")
    , c("20190620", "20190624")
    , c(NA_real_, NA_real_)
    , c("CONFIRMED", "CONFIRMED")
  )
)


dbExecute(connection,
          "INSERT INTO ApplicationText VALUES (?, ?, ?, ?, ?)",
          param = list(
            c(seq(1:3))
            , c(rep(NA_integer_, 3))
            , c(rep(0, 3))
            , c(rep(NA_character_, 3))
            , c("Monthly Spending", "Annual Spending", "Debit & Credit Table")
          ))

nLen <- 6
dbExecute(connection,
          "INSERT INTO TablesMappings VALUES (?, ?, ?, ?, ?)",
          param = list(
            c(seq(1:nLen))
            , c("dtAcctDates", "dtColStructure"
                , "dtDevTasks", "dtExpectedIncome", "dtFormattedRawData", "dtReportData"         
                )
            , c("AccountsDates", "AccountsStructures"
                , "DevTasks", "ExpectedIncome", "SourceData", "ReportData"
                )
            # Either NULL, SQL: "AccountsKeywords", "ApplicationText", "QuestionTypes", "Questions"
            # Either NULL, R: "dtRandomizationSource"
            , c(rep(NA_character_, nLen))
            , c(rep(1, nLen))
          ))

# source("")
# dbReadTable(connection, "AccountCategoiries")
# AllDTs <- data.table(objName = ls())
# dtQueries <- AllDTs[ , grep("dt", objName, value = TRUE) ] 

