source("mainSetup.R")
source("mainFunctions.R")


shinyServer(function(input, output, session) {
  menuSpending <<- "Spending"
  
  output$testText <- renderText("testText1")
  
  
  # observe({
  #   print(paste0("test input is ", input$spendDates))
  # })
  
 
  #################                      SPENDING, MNTH                      #################
  
  output$spendPlotsMnth <- renderUI({
    plotsOutputList <- lapply(as.list(seq_len(length(input$spendAccts))), function(i) {
      plotID <- paste0("plotSimple", i)
      htmlOutput(plotID)
    })
    tagList(plotsOutputList)
  })
  
  
  observeEvent(
    {input$spendAccts
    input$spendDates}
    
    , {
    for (i in seq_len(length(input$spendAccts))) {
      local({
        plotName <- paste0("plotSimple", i)
        currentAcct <- input$spendAccts[i]
        plotData <- plotSimple(currentAcct, input$spendDates)
        plotTitle <- paste0("The spending trend of ", currentAcct)
        
        output[[plotName]] <- renderGvis({
          gvisLineChart(plotData
                        , options = list(
                          title = plotTitle
                          , titleTextStyle="{color:'purple',fontName:'Courier',fontSize:16}"
                          , vAxes = "[{title:'Amount (in $)'}]"
                        ))
          
          })
        })}
  })
  
  
  #################                      SPENDING, ANNUAL                      #################
  output$spendPlotsAnnual <- renderUI({
    plotsListTSSimple <- lapply(1:nPlots
                                , function(i) {
                                  plotName <- paste0("plotTS", i, collapse = "")
                                  
                                  output[[plotName]] <- renderPlot({
                                    #### plotTSSimple(selectedAcct = input$inTSGroups[i], selectDateRange = input$inTSDates)
                                    selectedAcct <- "CC"
                                    selectDateRange <- c("2018-12-01", "2018-12-31")
                                    
                                    dtTargetData <-
                                      dtReportData[BankAcct == selectedAcct &
                                                     TransDate %between% selectDateRange, ]
                                    dtSumByDate <-
                                      aggregate(Debit ~ TransDate, data = dtTargetData, FUN = sum)
                                    
                                    plotTitle <- sprintf("Spending total by Date in %s from %s"
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
  output$spendTblDC <- renderDataTable(calcDebVSCred())
})