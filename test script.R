drStart <- ymd("20190501")
drEnd <- ymd("20190801")

i <- 1


dtIncome <- dtFormattedRawData[ BalType == "Credit" & Note %in% c("Salary", "McCulloch")]
