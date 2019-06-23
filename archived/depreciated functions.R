##########            LOAD RAW DATA TO ENVIRONMENT (DEPRECIATED)            ##########


## Example fileName is # AXXXX_XXXX_XXXX_6144-07Nov18.csv
loadData <- function(AcctNum) {
  fileToRead <- paste0("inputs/", AcctNum, "-", MonthsToProcess, ".csv")
  importedData <- data.table(read.csv(fileToRead
                                      , colClasses = c("character"))
                             , stringsAsFactors = F)
  
  ##  TAKE OUT SPECIAL CHARACTER OF "." IN COLUMN NAMES
  names(importedData) <- gsub(pattern = "[.]", x = names(importedData), "")
  return(importedData)
}
