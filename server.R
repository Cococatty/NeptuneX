source("mainSetup.R")
source("mainFunctions.R")


shinyServer(function(input, output, session) {
  menuSpending <<- "Spending"
  
  output$testText <- renderText(input$tabSpend)
  # input$tabSpend
  
  
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
    input$spendDates
    input$tabSpend
    }
    
    , { if (input$tabSpend == titleSpendMonth) {
    for (i in seq_len(length(input$spendAccts))) {
      local({
        plotName <- paste0("plotSimple", i)
        currentAcct <- input$spendAccts[i]
        plotData <- plotSimple(currentAcct, input$spendDates, input$tabSpend)
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
  }})
  
  ########      TO MERGE WITH MONTHLY ONE
  ########      
  ########      
  #################                      SPENDING, ANNUAL                      #################
  output$spendPlotsAnnual <- renderUI({
    plotsSimpleYrOutputList <- lapply(as.list(seq_len(length(input$spendAccts))), function(i) {
      plotYrID <- paste0("plotSimpleAnnual", i)
      htmlOutput(plotYrID)
    })
    tagList(plotsSimpleYrOutputList)
  })
  
  
  observeEvent(
    {input$spendAccts
      input$spendDates
      input$tabSpend
      }
    
    , { if (input$tabSpend == titleSpendYear) {
      for (i in seq_len(length(input$spendAccts))) {
        local({
          plotName <- paste0("plotSimpleAnnual", i)
          currentAcct <- input$spendAccts[i]
          plotYrData <- plotSimple(currentAcct, input$spendDates, input$tabSpend)
          plotTitle <- paste0("The spending trend of ", currentAcct)

          output[[plotName]] <- renderGvis({
            gvisColumnChart(plotYrData
                          , options = list(
                            title = plotTitle
                            , titleTextStyle="{color:'purple',fontName:'Courier',fontSize:16}"
                            , vAxes = "[{title:'Amount (in $)'}]"
                          ))
          })
        })}
    }})
  
  
  
  #################                      SPENDING, D&C TABLE                      #################
  # output$spendTblDC <- renderDataTable(calcDebCredTotals())
  observeEvent(
    {input$spendAccts
      input$spendDates
      input$tabSpend
    }
    
    , { if (input$tabSpend == titleSpendTable) {
     # output$spendTblDC <- renderGvis( { 
     #          dtResult <- getDebVSCredTbl(input$spendAccts, input$spendDates)
     #          gvisTable(dtResult
     #                     , formats = list(Amount = "$#.##")
     #                     , options = list(page = "enable"# , height = 750, width = 850
     #                     , cssClassNames = "{headerRow: 'myTableHeadrow', tableRow: 'myTablerow'}", alternatingRowStyle = FALSE)
     #          )
     # })
      output$spendTblDC <- renderDataTable( { 
        dtResult <- getDebVSCredTbl(input$spendAccts, input$spendDates)
      })
      }}
    )

  
  reactiveDCTotals <- reactive(calcDebCredTotals(input$spendAccts, input$spendDates))
  output$spendDCTotals <- renderDataTable({reactiveDCTotals()})


  #################                      INCOME, Expect Income TABLE                      #################
  # output$incomeExpectedTable <- renderGvis({
  #   buildExpectedIncome(input$inIncomeDates)
  #   gvisTable(dtExpectedIncomeSeries)
  # })
  
  output$incomeExpectedTable <- renderDataTable({
    dtExpectedIncomeSeries <- buildExpectedIncome(input$inIncomeDates)
  })
  
  
  
  #################                      DEVELOPMENT, TASKS SCHEDULE TABLE                      #################
  output$devSchedule <- renderDataTable(dtDevTasks)
  
######      SIGNATURE END  
})

# print("I'm HERE! ")