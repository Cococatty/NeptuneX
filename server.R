source("mainSetup.R")
source("mainFunctions.R")


shinyServer(function(input, output, session) {
  menuSpending <<- "Spending"
  # output$textTxt <- renderText(input$inQsIncome)
  
  observe({
    print(paste0("test text ", input$inQsIncome))
  })
  
  
  ## updateTS
  nPlots <<- 1
  # observe({
  #   nPlots <<- input$spend
  #   if (nPlots == 0) nPlots <<- 1
  #   print(paste0("changing ", nPlots))
  # })

  #################                      SPENDING, MNTH                      #################
  output$spendPlotMnth <- renderPlot(plotSimple(input$spendAccts, "2019"))
  
  
  #################                      SPENDING, ANNUAL                      #################
  output$spendPlotAnnual <- renderUI({
    plotsListTSSimple <- lapply(1:nPlots
                                , function(i) {
      plotName <- paste0("plotTS", i, collapse = "")
      print(plotName)
      ### plotName <- paste0("plotTS", i, collapse = "")

      output[[plotName]] <- renderPlot({
        #### plotTSSimple(selectedAcct = input$inTSGroups[i], selectDateRange = input$inTSDates)
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
    }) #### END OF lapply
    do.call(tagList, plotsListTSSimple)
  })

  
  #################                      SPENDING, D&C TABLE                      #################
  output$spendTblDC <- renderDataTable(
    calcDebVSCred()
  )
})