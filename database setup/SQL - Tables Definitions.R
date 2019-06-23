library(RSQLite)
library(DBI)
# Create a local RSQLite database
# connection <- dbConnect(RSQLite::SQLite(), "NeptuneX")

# dbListTables(connection)


#######################             TESTFIELD             #######################
testField <- function() {
  dbReadTable(connection, "DevTasks")
  dbReadTable(connection, "QuestionTypes")
  dbExistsTable(connection, "QuestionTypes")
  
  dbDataType(connection, "Fortnightly")
  dbDataType(connection, Sys.Date())
  dbDataType(connection, Sys.time())
}



##############        DROP ALL TABLES EXCEPT FOR sqlite_sequence        ##############
dropAll <- function() {
  for (i in dbListTables(connection)) {
    if (dbExistsTable(connection, i) & i != "sqlite_sequence") dbRemoveTable(connection, i)
  }
  print("Table removal action finished. Following tables exist")
  dbListTables(connection)
}

##############        CREATE ALL TABLES IF NOT EXIST        ##############
createAllTables <- function() {
  dropAll()
  
    ####################                        START OF TABLE DEFINITION                        ####################
    CREATE_GLAccounts <- 
      "CREATE TABLE GLAccounts (
    ID INTEGER PRIMARY KEY AUTOINCREMENT
    , Code TEXT NOT NULL
    , Description TEXT NULL
  )"
    
    
    
    #####################         GLAccountKeywords         #####################
    CREATE_GLAccountKeywords <- 
      "CREATE TABLE GLAccountKeywords (
    ID INTEGER PRIMARY KEY AUTOINCREMENT
    , GLID INTEGER NOT NULL
    , Keyword TEXT NOT NULL
  )"
    
    
    #####################         AccountsKeywords         #####################
    CREATE_RecurringTransactionItems <- 
      "CREATE TABLE RecurringTransactionItems (
    ID INTEGER PRIMARY KEY AUTOINCREMENT
    , GLID INTEGER NULL
    , Name  TEXT NOT NULL
    , Amount REAL NOT NULL
    , Frequency TEXT NOT NULL
    , FreqInt INTEGER NOT NULL
    , StartDate REAL NOT NULL
    , EndDate REAL
    , BalType TEXT NOT NULL
  )"
    
    
    
    #####################         AccountsKeywords         #####################
    CREATE_RecurringTransactionKeywords <- 
      "CREATE TABLE RecurringTransactionKeywords (
    ID INTEGER PRIMARY KEY AUTOINCREMENT
    , ItemID INTEGER NULL
    , Keyword  TEXT NOT NULL
  )"
    
    
    #####################         SourceData         #####################
    CREATE_SourceData <- "
  CREATE TABLE SourceData (
      ID INTEGER PRIMARY KEY AUTOINCREMENT
      , Reference  TEXT NOT NULL
      , OtherParty TEXT NOT NULL
      , Amount REAL NOT NULL
      , BankAcct TEXT NOT NULL
      , Note TEXT NOT NULL
      , TransDate REAL NOT NULL
      , TransWDay TEXT NOT NULL
      , TransDay  TEXT NOT NULL
      , TransMonth  TEXT NOT NULL
      , TransYear  TEXT NOT NULL
  )
  "
  
  #####################         ReportData         #####################
  CREATE_ReportData <- "
  CREATE TABLE ReportData (
      ID INTEGER PRIMARY KEY AUTOINCREMENT
      , Reference  TEXT NOT NULL
      , OtherParty TEXT NOT NULL
      , Amount REAL NOT NULL
      , BankAcct TEXT NOT NULL
      , Note TEXT NOT NULL
      , TransDate REAL NOT NULL
      , TransWDay TEXT NOT NULL
      , TransDay  TEXT NOT NULL
      , TransMonth  TEXT NOT NULL
      , TransYear  TEXT NOT NULL
  )
  "
  
  
  #####################         AccountsDates         #####################
  CREATE_AccountsDates <- "
  CREATE TABLE AccountsDates (
      BankAcct TEXT PRIMARY KEY
      , MinDate REAL NOT NULL
      , MaxDate REAL NOT NULL
  )
  "
  
  #####################         Questions         #####################
  CREATE_QuestionTypes <- "
  CREATE TABLE QuestionTypes (
      ID INTEGER  PRIMARY KEY
      , Code TEXT NOT NULL
      , Name TEXT NOT NULL
  )"
  
  CREATE_Questions <- "
  CREATE TABLE Questions (
      ID INTEGER  PRIMARY KEY
      , TypeID INTEGER NULL
      , Code TEXT NULL
      , QuestionText TEXT NOT NULL
  )"
  
  
  
  ##################                  AccountsStructures                  ##################
  CREATE_AccountsStructures <- "
  CREATE TABLE AccountsStructures (
      ID INTEGER  PRIMARY KEY
      , AcctNum TEXT NOT NULL
      , Reference TEXT NULL
      , OtherParty TEXT NULL
      , Amount TEXT NOT NULL
      , Note TEXT NULL
      , TransDate REAL NOT NULL
  )
  "
  
  
  
  ##################                  DevTasks                  ##################
  CREATE_DevTasks <- "
  CREATE TABLE DevTasks (
      ID INTEGER  PRIMARY KEY
      , EPIC TEXT NOT NULL
      , Task TEXT NOT NULL
      , StartDate REAL NULL
      , EndDate REAL NULL
      , Status TEXT NOT NULL
  )"
  
  
  ##################                  ApplicationMenus                  ##################
  CREATE_ApplicationText <- "
  CREATE TABLE ApplicationText (
      ID INTEGER  PRIMARY KEY
      , ParentID INTEGER NULL
      , IsMenu INTEGER NOT NULL
      , Code TEXT NULL
      , Title TEXT NOT NULL
  )"
  
  ##################                  TablesMappings                  ##################
  CREATE_TablesMappings <- "
  CREATE TABLE TablesMappings (
      ID INTEGER  PRIMARY KEY
      , RTable TEXT NOT NULL
      , SQLTable TEXT NOT NULL
      , Note TEXT NULL
      , IsActive INTEGER NOT NULL
  )"
  
  ####################                        END OF TABLE DEFINITION                        ####################


  AllObjects <- data.table(objName = ls())
  CreateQueries <- AllObjects[ , grep("CREATE_", objName, value = TRUE) ] 
  # print(CreateQueries)
  for (i in CreateQueries) {
    tableName <- substr(i, 8, nchar(i))
    if (!dbExistsTable(connection, tableName)) dbExecute(connection, get(i))
  }
  print("New tables creation done. Following tables exist:")
  dbListTables(connection)
}


createAllTables()
# dropAll()
# dbListTables(connection)
# 