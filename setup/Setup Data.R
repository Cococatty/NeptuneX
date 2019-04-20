# https://www.r-bloggers.com/r-and-sqlite-part-1/
  
# install.packages("sqldf")
# install.packages("XLConnect")


library(sqldf)

dbMain <- dbConnect(SQLite(), dbname="dbMain.sqlite")
sqldf("attach 'dbMain.sqlite' as new")


dbSendQuery(conn = dbMain,
            "CREATE TABLE AccountsLog (
              AcctType TEXT,
              MinDate TEXT,
              MaxDate TEXT)") # DATE


# dbWriteTable(conn = dbMain, name = "StructureData", value = dtColStructure, row.names = FALSE, header = TRUE)


# dbWriteTable(conn = dbMain, name = "AccountsLog", value = dtAcctDates,
#              row.names = FALSE, header = TRUE, append = TRUE)
# 
# dbWriteTable(dbMain, "dtAcctDates", dtAcctDates[0, ])
# dbWriteTable(dbMain, "AccountsLog", dtAcctDates)
# dbWriteTable(dbMain, "dtAcctDates", dtAcctDates, field.types = c(character(), ymd(), ymd()) )
# 
# 
# dbSendQuery(conn = dbMain,
#             "INSERT INTO AccountsLog
#             VALUES ('CC', '2018-11-05', '2019-01-03')")
# 
# sqlData(dbMain, head(iris))
# 
# ?dbWriteTable
#######     BASIC OPS
# dbListTables(dbMain)              # The tables in the database
# dbListFields(dbMain, "dtAcctDates")    # The columns in a table
# dbRemoveTable(dbMain, "StructureData")     # Remove the School table.
# 
# 
# #######     READ
# dbReadTable(dbMain, "StructureData")     # The data in a table
# dbReadTable(dbMain, "AccountsLog")     # The data in a table


