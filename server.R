source("setup.R")
source("key_functions.R")


shinyServer(function(input, output, session) {
  title_yearly_spend <<- "Annual Spending"
  
  output$testText <- renderText(input$tab_spend)
  
 
  #################                      SPENDING, MNTH                      #################
  output$plot_monthly_debit <- renderUI({
    plotsOutputList <- lapply(as.list(seq_len(length(input$spendAccts))), function(i) {
      plotID <- paste0("plot_simple", i)
      htmlOutput(plotID)
    })
    tagList(plotsOutputList)
  })
  
  
  output$loaded_csv <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$csv_input
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header = TRUE)
  })
  
  reactiveDCTotals <- reactive(calcDebCredTotals(input$spendAccts, input$spendDates))
  output$tbl_total_debit <- renderDataTable({reactiveDCTotals()})


  #################                      INCOME, Expect Income TABLE                      #################

  plan_income_start <- reactive({plan_income(input$income_start_date)})
  output$incomeExpectedTable <- renderDataTable({ plan_income_start() })
  
  
  #################                      DEVELOPMENT, TASKS SCHEDULE TABLE                      #################
  output$devSchedule <- renderDataTable(dtDevTasks)
  
  
  
######      SIGNATURE END  
})
# print("I'm HERE! ")