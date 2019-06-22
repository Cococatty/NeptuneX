
 

dbListFields(connection, "AccountCategoiries")
dbListFields(connection, "AccountsKeywords")
dbGetQuery(connection, 'SELECT * FROM AccountsKeywords')
dbReadTable(connection, "AccountCategoiries")
dbReadTable(connection, "AccountsKeywords")
# dbRemoveTable(connection, "AccountsKeywords")
dbListTables(connection)


