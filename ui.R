shinyUI(fluidPage(
  # Application title
  titlePanel("Data on Neptune")
  # , headerPanel("Simple Data")

    # Sidebar with a slider and selection inputs
  , navlistPanel(
    widths = c(2, 8)
    
    # , tabPanel("Monthly Spending"
    #            , mainPanel(plotOutput("plotMnthly")) )
    , tabPanel("TS Spending"
               , mainPanel(
                 sidebarLayout(
                   sidebarPanel(
                     sliderInput("inTSNumGrp", "Number of Categories"
                                 , min = 1, max = 5, value = 3
                                 )
                     , checkboxGroupInput("inTSGroups", "Selected Categories"
                                          , choices = dtAcctProcessedRange$BankAcct
                                          , selected = "CC")
                     , dateRangeInput("inTSDates", "Transaction Date Range"
                                      # , start = (today() %m-% months(1)), end = today() 
                                      , start = "2018-12-01", end = "2018-12-31"
                                      , min ="2018-12-01" # min(dtAcctProcessedRange$MinDate)
                                      , max = "2018-12-31"#max(dtAcctProcessedRange$MaxDate)
                                      # , separator = " to "
                                      )
                   )
                   , mainPanel(
                     # uiOutput("plotsTSSpending")
                     plotOutput("plotsTSSpending", width = "200%", height = "400px")
                     )
                 )
                 # plotOutput("plotMnthly")
                 ) 
               )
    , tabPanel("Debit VS Credit" #, width = 12
               , mainPanel(dataTableOutput("tblDC")) 
               )
    # , tabPanel("tab 2", "content")
  )
))
