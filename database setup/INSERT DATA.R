
# dtAccountCategoiries <- data.table(ID = seq(1:14), CategoryName = c(
#   "Household", "MonthlyExp", "CCRepayment"
#   , "OccasionalExp", "Grocery", "Shopping", "OnlineShop", "Coffee"
#   , "Event", "Eatout", "Income", "Donation", "Special", "NY2019"
# ))

dbExecute(
  connection,
  "INSERT INTO AccountCategoiries (ID, CategoryName) VALUES (?, ?)",
  param = list(c(15, 16), c("2","3"))
)


# InsertResultQuery <- paste("INSERT INTO AccountsKeywords (ID, CategoryID, Keyword) VALUES (?, ?, ?)")
dbExecute(
  connection,
  "INSERT INTO ExpectedIncome VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
  param = list(
    c(1, 2)
    , c("Salary", "Rental")
    , c("Salary", "McCulloch") 
    , c(3000, 120)
    , c("Fortnightly", "Weekly")
    , c(2, 4)
    , c(ymd("2019-06-11"), ymd("2019-06-11"))
    , c("", "")
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
  "INSERT INTO AccountsStructures VALUES (?, ?, ?)",
  param = list(c("AXXXX_XXXX_XXXX_6144", "A0315920567389000", "A0315920567389017","A0315920567389025", "A0315920567389091")
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
            