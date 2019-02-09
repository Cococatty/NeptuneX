source("Main Setup.R")
# source("Main Functions.R")


shinyServer(function(input, output, session) {
   output$tblDC <- renderDataTable(
       calcDebVSCred()
       # data.table(tapply(abs(as.numeric(dtReportData$Amount)), dtReportData$Category, FUN=sum))
       # data.table(x = 1, y = 2)
   )

   # output$plotsTSSpending <- renderUI({plotTSSimple(selectedAcct = input$inTSGroups
   #                                                  , selectDateRange = input$inTSDates)})
   
   # output$plotsTSSpending <- renderUI({
   #   for (i in input$inTSGroups) {
   #     plotTSSimple(selectedAcct = i, selectDateRange = input$inTSDates) 
   #   }
   #   })
   
   output$plotsTSSpending <- renderPlot(plotTSSimple(selectedAcct = input$inTSGroups
                                                    , selectDateRange = input$inTSDates))

   # output$plotMnthly <- renderPlot()
})