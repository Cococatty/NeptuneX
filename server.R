source("Main Process.R")
# source("Main Functions.R")


shinyServer(function(input, output, session) {
   output$tblDC <- renderDataTable(
       calcDebVSCred()
       # data.table(tapply(abs(as.numeric(dtReportData$Amount)), dtReportData$Category, FUN=sum))
       # data.table(x = 1, y = 2)
   )
     # 

   # output$plotMnthly <- renderPlot()
})