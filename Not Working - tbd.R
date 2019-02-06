##        Convert list of columns to date format
dateList <- c("ProecssDate", "TransactionDate") 
ccData[, dateList := as.Date(dateList, "%d/%m/%Y")]