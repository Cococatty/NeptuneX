
# plotSimple <- function(plotAcct, plotYear) {
  plotAcct <- c("CC", "Daily")
  plotYear <- "2019"
  tsGroup <- "BankAcct"
  plotDateRange <- testVar
  
  selectedDateRange <- c(as.Date("2018-09-01"), as.Date("2019-04-01"))
  plotDateRange <- c(as.Date("2018-09-01"), as.Date("2019-04-01") )
  plotAcct <- "CC"  
  currentAcct <- "Daily"  
  
  yearMonthValues <- deriveSelectedDateRange(c(as.Date("2018-09-01"), as.Date("2019-04-01")))
  
  
  plotData1 <- plotSimple("CC", selectedDateRange)
  plotData <- plotSimple("Daily", selectedDateRange)
  
  plotData <- plotSimple(currentAcct, selectedDateRange)
  
  
  
  dtPlotData <- subset(dtFormattedRawData
                       , BankAcct == "CC" 
                       & TransDate <= ymd(selectedDateRange[2]) & TransDate >= ymd(selectedDateRange[1])
                       # & TransYear >= yearMonthValues$drStartYear & TransYear <= yearMonthValues$drEndYear
                       # & TransMonth >= yearMonthValues$drStartMonth & TransMonth <= yearMonthValues$drEndMonth
                       , select = c(TransYear, TransMonth, Debit, BankAcct) )
  
  
  
  ## 430
  
  # plotStart <- plotDateRange[1]
  # plotEnd <- plotDateRange[2]
  # 
  # plotStartYear <- year(plotStart)
  # plotStartMonth <- month(plotStart)
  # plotEndYear <- year(plotEnd)
  # plotEndMonth <- month(plotEnd)
  selectedDateRange <- plotDateRange
  selectedDateRange <- c(as.Date("2018-01-30"), as.Date("2018-05-20"))
  
  yearMonthValues <- deriveSelectedDateRange(plotDateRange)
  
  ##  1. Subset data
  dtPlotData <- subset(dtFormattedRawData
                       , BankAcct == plotAcct & TransYear >= plotStartYear & TransYear <= plotEndYear
                       & TransMonth >= plotStartMonth & TransMonth <= plotEndMonth
                       , select = c(TransYear, TransMonth, Debit, BankAcct) )
  
  ##  Calculate the sums
  dtSums <- aggregate(Debit ~ . , data = dtPlotData, FUN = sum)
  
  plotMain <- paste0("The spending trend of ", unique(dtSums$BankAcct) )

  
  basicPlot <- plot(x = dtSums$TransMonth, y = dtSums$Debit, type = "l"
                    , main = plotMain, xlab = "Transaction Month", ylab = "Amount (in $)")
  
  
  
  ##  1. Subset data
  dtTS <- subset(dtFormattedRawData, BankAcct == plotAcct, select = c(TransYear, TransMonth, Debit) )
  
  ##  Calculate the sums
  dtSums <- aggregate(Debit ~ . , data = dtTS, FUN = sum)
  
  plotMain <- paste0("The spending trend of ", plotAcct, " in ", plotYear)
  basicPlot <- plot(x = dtSums$TransMonth, y = dtSums$Debit, type = "l"
                    , main = plotMain, xlab = "Transaction Month", ylab = "Amount (in $)")








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
# aggregate(as.numeric(abs(dtReportData$Amount)), by = list(BalType = dtReportData$BalType), FUN = sum)
return(dtResult)






#########################                     DEV DEBUG CODE
testVar <<- plotAcct
testVarType <<- str(plotAcct)

# print(paste0("in plotSimple the dateRange is ", testVar, " type is ", str(testVar), collapse = "------"))
