
#################################               GLAccountKeywords               #################################
parentIDTable <- "GLAccounts"
targetTable <- "GLAccountKeywords"
parentKeyName <- "Code"
sourceList <- acctKeywordsList

delistForSQL_GLAccountsKeywords <- function(sourceList, parentIDTable, parentKeyName, targetTable) {
  
  currentID <- 1
  
  for (i in names(sourceList)) {
    IDQuery <- paste('SELECT ID FROM ', parentIDTable , ' WHERE "', parentKeyName,'" = :x', sep = '')
    keywordID <- as.integer( dbGetQuery(connection, IDQuery, params = list(x = i)))
    keywords <- unlist(sapply(sourceList[i], c) )
    keyLen <- length(keywords)
    
    # InsertResultQuery <- paste("INSERT INTO AccountsKeywords (ID, CategoryID, Keyword) VALUES (?, ?, ?)")
    dbExecute(
      connection,
      "INSERT INTO GLAccountKeywords VALUES (?, ?, ?)",
      param = list(
        c(seq(from = currentID, to = currentID + keyLen - 1))
        , c(rep(keywordID, keyLen))
        , keywords
      )
    )
    currentID <- currentID + keyLen
  }
  CheckResultQuery <- paste('SELECT * FROM ', targetTable, sep = '')
  getRS <- dbGetQuery(connection, CheckResultQuery)
  # dbClearResult(getRS)
}


######################         TESTFIELD         ######################
# dbSendQuery(connection, "DELETE FROM AccountsKeywords")
delistForSQL_GLAccountsKeywords(sourceList, parentIDTable, parentKeyName, targetTable)

# dbReadTable(connection, "GLAccounts")
dbReadTable(connection, "GLAccountKeywords")
#################################               AccountKeywords               #################################
