
input paste0(getwd(), "inputs", collapse = "/")
list.files(path = getwd(), pattern=NULL, all.files=FALSE, full.names=FALSE) 


rawDataFiles <- list.files(path = "inputs", pattern=NULL, all.files=FALSE, full.names=FALSE)



# loadData <- function(AcctNum) {
  
  fileToRead <- paste0("inputs/", rawDataFiles[i])
  
  importedData <- data.table(read.csv(fileToRead
                                      , colClasses = c("character"))
                             , stringsAsFactors = F)
  
  ##  TAKE OUT SPECIAL CHARACTER OF "." IN COLUMN NAMES
  names(importedData) <- gsub(pattern = "[.]", x = names(importedData), "")
  return(importedData)
  

############################################        TS
BankAcct <- "CC"
tsGroup <- "BankAcct"

##  1. Subset data
dtTS <- subset(dtReportData, BankAcct == "CC", select = c(TransYear, TransMonth, Debit) )

##  Calculate the sums
dtSums <- aggregate(Debit ~ . , data = dtTS, FUN = sum)

plot(y = dtSums$Debit, x = dtSums$TransMonth, line)


scatterplot(Debit~ TransYear | TransMonth, data= dtSums)

tsSum <- ts(dtSums$Debit, start = c(min(dtSums$TransYear), max(dtSums$TransMonth)), frequency = 12)

tsSumV <- as.vector(tsSum)

plot(tsSum)
plot.ts(tsSum$y)
plot.ts(tsSumV)
plot(x = dtSums$TransYear, y = dtSums$Debit)

z <- ts(matrix(rt(200 * 8, df = 3), 200, 8),
        start = c(1961, 1), frequency = 12)

plot(z, yax.flip = TRUE)

?plot.ts
??scatterplot
names(dtTS)
rowFirst <- dtReportData[1,]
# ts(dtTS, start = c(rowFirst$TransYear, rowFirst$TransMonth), frequency = 12 )
# dtTS[, sum(Debit), by = .(TransYear, TransMonth)]
# aggregate(as.numeric(abs(dtReportData$Amount)), by = list(AcctType = dtReportData$AcctType), FUN = sum)
return(dtResult)