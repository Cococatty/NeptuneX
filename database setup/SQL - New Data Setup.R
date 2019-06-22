library(RSQLite)
library(DBI)
# Create a local RSQLite database
# connection <- dbConnect(RSQLite::SQLite(), "NeptuneX")

# dbListTables(connection)

CREATE_AccountCategoiries <- 
"CREATE TABLE AccountCategoiries (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CategoryName VARCHAR NOT NULL
)"



#####################         AccountsKeywords         #####################
CREATE_AccountsKeywords <- 
  "CREATE TABLE AccountsKeywords (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CategoryID INTEGER NOT NULL,
  Keyword VARCHAR NOT NULL
)"


#####################         AccountsKeywords         #####################
CREATE_ExpectedIncome <- 
  "CREATE TABLE ExpectedIncome (
  ID INTEGER PRIMARY KEY AUTOINCREMENT
  , Name  VARCHAR NOT NULL
  , Keyword VARCHAR NOT NULL
  , Amount REAL NOT NULL
  , Frequency TEXT NOT NULL
  , FreqInt INTEGER NOT NULL
  , StartDate REAL NOT NULL
  , EndDate REAL
)"



#####################         FormattedSourceData         #####################
CREATE_FormattedSourceData <- "
CREATE TABLE FormattedSourceData (
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
)
"

CREATE_Questions <- "
CREATE TABLE Questions (
    ID INTEGER  PRIMARY KEY
    , TypeID INTEGER NULL
    , Code TEXT NULL
    , QuestionText TEXT NOT NULL
)
"



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
)
"


##################                  ApplicationMenus                  ##################
CREATE_ApplicationText <- "
CREATE TABLE ApplicationText (
    ID INTEGER  PRIMARY KEY
    , ParentID INTEGER NULL
    , IsMenu INTEGER NOT NULL
    , Code TEXT NULL
    , Title TEXT NOT NULL
)
"


#######################             TESTFIELD             #######################

dbReadTable(connection, "DevTasks")
dbReadTable(connection, "QuestionTypes")
dbExistsTable(connection, "QuestionTypes")

dbDataType(connection, "Fortnightly")
dbDataType(connection, Sys.Date())
dbDataType(connection, Sys.time())





##############        CREATE ALL TABLES IF NOT EXIST        ##############
AllObjects <- data.table(objName = ls())
CreateQueries <- AllObjects[ , grep("CREATE", objName, value = TRUE) ] 

for (i in CreateQueries) {
  tableName <- substr(i, 8, nchar(i))
  if (!dbExistsTable(connection, tableName)) dbExecute(connection, get(i))
}



dbListTables(connection)

