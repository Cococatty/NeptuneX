#################            TEST DATA SETUP START              #################
# plotSimple <- function(plotAcct, plotYear) {
  plotAcct <- c("Credit Card", "Daily")
  plotYear <- "2019"
  tsGroup <- "BankAcct"
  plotDateRange <- testVar
  
  selectedDateRange <- c(as.Date("2018-09-01"), as.Date("2019-04-01"))
  currentAcct <- "Daily"  
  
  plotDateRange <- c(as.Date("2018-09-01"), as.Date("2019-04-01") )
  plotAcct <- "Credit Card"  
  plotData <- dtSums
  
  StartDate <- ymd(plotDateRange[1])
  EndDate <- ymd(plotDateRange[2])
#################            TEST DATA SETUP END              #################
    
  print(paste0(StartDate, " - ",  EndDate, collapse = "    "))
  
  ##  1. Subset data
  dtPlotData <- dtFormattedRawData[(BankAcct == plotAcct 
                                    & TransDate >= StartDate & TransDate <=EndDate)
                                   , .(TransYear, TransMonth, Debit, BankAcct)]
  
  
  ##  Calculate the sums
  dtSums <- aggregate(Debit ~ . , data = dtPlotData, FUN = sum)
  
  ##  ascending order
  setorderv(dtSums, cols = c("TransYear", "TransMonth"), order=1L, na.last=FALSE)





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
