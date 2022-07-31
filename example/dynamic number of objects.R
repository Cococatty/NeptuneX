output$spendPlotsMnth <- renderUI({
  lapply(as.list(seq_len(length(
    input$spendAccts
  ))), function(i) {
    plotID <- paste0("plotSimple", i)
    # print( paste0("plotID is: ", plotID, collapse = "----") )
    plotOutput(plotID)
  })
  # tagList(plotsOutputList)
})



################################################################################################


observeEvent(input$spendAccts, {
  
  for (i in seq_len(length(input$spendAccts))) {
    local({
      plotName <- paste0("plotSimple", i)
      currentAcct <- input$spendAccts[i]
      plotData <- plotSimple(currentAcct, input$spendDates)
      plotTitle <- paste0("The spending trend of ", currentAcct)
      
      output[[plotName]] <- renderPlot({
        plot(x = plotData$TransMonth, y = plotData$Debit, type = "l"
             , main = plotTitle, xlab = "Transaction Month", ylab = "Amount (in $)")
      })
      
      
    })}
  
})




################################################################################################

observeEvent(input$spendAccts, {
  for (i in seq_len(length(input$spendAccts))) {
    local({
      j <- i
      plotName <- paste0("plotSimple", j)
      plotData <- plotSimple(input$spendAccts[j], input$spendDates)
      plotTitle <- paste0("The spending trend of ", input$spendAccts[j] )
      
      output[[plotName]] <- renderPlot({
        plot(x = plotData$TransMonth, y = plotData$Debit, type = "l"
             , main = plotTitle, xlab = "Transaction Month", ylab = "Amount (in $)")
        
      })
    })
    
  }})
