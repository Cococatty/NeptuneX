source("Main Setup.R")
# source("Main Functions.R")


shinyServer(function(input, output, session) {
  
  # updateTS
  nPlots <<- 1
  observe({
    nPlots <<- input$inTSNumGrp
    if (nPlots == 0) nPlots <<- 1
    print(paste0("changing ", nPlots))
  })
  
   
  output$tblDC <- renderDataTable(
       calcDebVSCred()
   )

  output$plotsTSSpending <- renderUI({
    plotsListTSSimple <- lapply(1:nPlots
                                , function(i) {
      plotName <- paste0("plotTS", i, collapse = "")
      print(plotName)
      # plotName <- paste0("plotTS", i, collapse = "")
      
      output[[plotName]] <- renderPlot({
        # plotTSSimple(selectedAcct = input$inTSGroups[i], selectDateRange = input$inTSDates)
        selectedAcct <- "CC"
        selectDateRange <- c("2018-12-01", "2018-12-31")
        
        dtTargetData <-
          dtReportData[BankAcct == selectedAcct &
                         TransDate %between% selectDateRange,]
        dtSumByDate <-
          aggregate(Debit ~ TransDate, data = dtTargetData, FUN = sum)
        
        plotTitle <- sprintf(
          "Spending total by Date in %s from %s"
          ,
          selectedAcct,
          paste0(selectDateRange, collapse = " to ")
        )
        plot(
          x = dtSumByDate$TransDate,
          y = dtSumByDate$Debit,
          main = plotTitle,
          type = "b"
          ,
          xlab = "Transaction Date",
          ylab = "Amount ($)"
        )
        plotOutput(plotName)
      })
    }) ## END OF lapply
    do.call(tagList, plotsListTSSimple)
  })
  
})