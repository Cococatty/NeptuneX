
dtAcctKeywords <- data.table(Category = character(), Keyword = character())

for (i in names(acctKeywordsList)) {
  # print(i)
  # i <- "Household"
  dtTemp <- data.table(Category = i, Keyword = unlist(acctKeywordsList[i]) )
  dtAcctKeywords <<- rbind(dtAcctKeywords, dtTemp)
}

dbWriteTable(dbMain, "AcctKeywords", dtAcctKeywords)
dbReadTable(dbMain, "AcctKeywords")  
dbReadTable(dbMain, "MainCategories")  


dbSendQuery(conn = dbMain,
            "CREATE TABLE MainCategories (
            CategoryName TEXT,
            Description TEXT)") # DATE


dbSendQuery(conn = dbMain,
            "INSERT INTO MainCategories
            VALUES ('Household', 'Household items')
            , ('NY2019', 'Items spent during NY break 2019')
            , ('Income', 'Items that earn me money')
            , ('Special', '')
            , ('Donation', '')
            , ('Special', '')
            , ('Eatout', 'Money spent on takeaway, dineout')
            , ('Event', '')
            , ('Coffee', 'Money spent on coffee or relevant')
            , ('OnlineShop', 'Online Shopping')
            , ('OnlineShop', 'Online Shopping')
            , ('Shopping', 'Shopping in physical shops')
            , ('Grocery', '')
            , ('MonthlyExp', 'Monthly Expenses')
            , ('OccasionalExp', 'Occasional Expenses')
            ")

# dbSendQuery(conn = dbMain, "DELETE FROM MainCategories")


dbListTables(dbMain)              # The tables in the database
dbListFields(dbMain, "dtAcctDates")
