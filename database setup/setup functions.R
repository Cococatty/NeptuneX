
#################################               AccountKeywords               #################################
parentIDTable <- "AccountCategoiries"
targetTable <- "AccountsKeywords"
parentKeyName <- "CategoryName"
sourceList <- acctKeywordsList

delistForSQL_AccountsKeywords <- function(sourceList, parentIDTable, parentKeyName, targetTable) {
  
  currentID <- 1
  
  for (i in names(sourceList)) {
    IDQuery <- paste('SELECT ID FROM ', parentIDTable , ' WHERE "', parentKeyName,'" = :x', sep = '')
    keywordID <- as.integer( dbGetQuery(connection, IDQuery, params = list(x = i)))
    keywords <- unlist(sapply(sourceList[i], c) )
    keyLen <- length(keywords)
    
    # InsertResultQuery <- paste("INSERT INTO AccountsKeywords (ID, CategoryID, Keyword) VALUES (?, ?, ?)")
    dbExecute(
      connection,
      "INSERT INTO AccountsKeywords VALUES (?, ?, ?)",
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
  dbClearResult(getRS)
}


######################         TESTFIELD         ######################
# dbSendQuery(connection, "DELETE FROM AccountsKeywords")
delistForSQL_AccountsKeywords(sourceList, parentIDTable, parentKeyName, targetTable)




#################################               AccountKeywords               #################################




# keywordID <- as.integer( dbGetQuery(connection, 'SELECT ID FROM AccountCategoiries WHERE "CategoryName" = :x',
#            params = list(x = i)))

# dbClearResult(getRS)