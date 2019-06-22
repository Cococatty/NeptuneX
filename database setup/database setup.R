# install.packages("mongolite")
# library(mongolite)
# 
# RawData <-  mongo(collection = "RawData", db = "NeptuneX", url = "mongodb://localhost")


library(mongolite)

options(mongodb = list(
  "host" = "ds012345.mongolab.com:61631",
  "username" = "super_admin",
  "password" = "^eB6fjVU8PrZ"
))
databaseName <- "myshinydatabase"
collectionName <- "responses"

# mongo "mongodb+srv://neptunex-zxe4k.azure.mongodb.net/test" --username super_admin
saveData <- function(data) {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  # Insert the data into the mongo collection as a data.frame
  data <- as.data.frame(t(data))
  db$insert(data)
}

loadData <- function() {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  # Read all the entries
  data <- db$find()
  data
}