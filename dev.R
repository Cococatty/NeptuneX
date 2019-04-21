
############################################        TS
# plotSimple <- function(plotAcct, tsGroup) {
  BankAcct <- "CC"
  tsGroup <- "BankAcct"
  plotYear <- "2019"
  
  ##  1. Subset data
  dtTS <- subset(dtConslidated, BankAcct == plotAcct, select = c(TransYear, TransMonth, Debit) )
  
  ##  Calculate the sums
  dtSums <- aggregate(Debit ~ . , data = dtTS, FUN = sum)
  
  plotMain <- paste0("The spending trend of ", plotAcct, " in ", plotYear)
  basicPlot <- plot(x = dtSums$TransMonth, y = dtSums$Debit, type = "l"
                    , main = plotMain, xlab = "Transaction Month", ylab = "Amount (in $)")
  
  return(plotMain)
}






tsSum <- ts(dtSums$Debit, start = c(min(dtSums$TransYear), max(dtSums$TransMonth)), frequency = 12)

plot(tsSum)
plot.ts(tsSum$y)
plot.ts(tsSum)
plot(x = dtSums$TransYear, y = dtSums$Debit)

scatterplot(Debit~ TransYear | TransMonth, data= dtSums)

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