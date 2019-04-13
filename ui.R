shinyUI(fluidPage(navbarPage("Neptune X Data Planet", # HEADER
             theme = shinythemes::shinytheme("superhero"),
  
  # Spending
  tabPanel( "Spending" # menuSpending, # "Plot tab contents..."
          , sidebarPanel(
              sliderInput("inTSNumGrp", "Number of Categories"
                          , min = 1, max = 5, value = 3
              )
              , checkboxGroupInput("inTSGroups", "Selected Categories"
                                   ##    TO DO:    Change to use dynamic table input, e.g. dtAcctProcessedRange$BankAcct
                                   , choices = c("CC", "Daily", "Saver", "Home Bills", "Home Loan")
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
              tabsetPanel(
                tabPanel("Monthly Spending"
                         , mainPanel(plotOutput("plotMnthly"))
                )
                , tabPanel("TS Spending"
                            , mainPanel(uiOutput("plotsTSSpending")
                                  # plotOutput("plotsTSSpending", width = "200%", height = "400px")
                          )
                              )
                              # plotOutput("plotMnthly")
                , tabPanel("Debit VS Credit" #, width = 12
                            , mainPanel(dataTableOutput("tblDC"))
                            )
              )
            )
          )
  , tabPanel( "Budget & Goal"
              , sidebarPanel(
                radioButtons("inBNGType", label = "The KEY"
                            , choices = c("Budget" = "budget", "Goal" = "goal")
                )
                , checkboxInput("inBNGRobot", label = "Neptune X help me please!", value = FALSE)
                ##  Conditionally display more quetsions base on study
                , conditionalPanel(
                  condition = "input.inBNGRobot == true "
                  , selectInput("inBNGRobKey", "Magic Keywords"
                                , c("cut", "better", "average"), multiple=TRUE, selectize=TRUE)
                  
                )
              )
             # , sidebarPanel(
             #    selectInput(
             #      "plotType", "Plot Type",
             #      c(Scatter = "scatter",
             #        Histogram = "hist")),
             #    
             #    # Only show this panel if the plot type is a histogram
             #    conditionalPanel(
             #      condition = "input.plotType == 'hist'",
             #      selectInput(
             #        "breaks", "Breaks",
             #        c("Sturges",
             #          "Scott",
             #          "Freedman-Diaconis",
             #          "[Custom]" = "custom")),
             #      
             #      # Only show this panel if Custom is selected
             #      conditionalPanel(
             #        condition = "input.breaks == 'custom'",
             #        sliderInput("breakCount", "Break Count", min=1, max=1000, value=10)
             #      )
             #    )
             #  )
              , mainPanel("Budget")
  )
  , tabPanel( "Income"
              , sidebarPanel(
                radioButtons("inQsIncome", label = "Ask a question"
                               , choices = c(
                                 "Have I received all expected money?" = "receivedAll"
                                 , "What are the missing payments?" = "missPayments"
                               )
                             # , choiceNames = qsIncomeNames
                             # , choiceValues = qsIncomeValues
                             )
                , dateRangeInput("inIncomeDates", "Check Date Range"
                                 , start = (today() %m-% months(1)), end = today()
                                 , min ="2018-12-01" # min(dtAcctProcessedRange$MinDate)
                                 , max = "2018-12-31"#max(dtAcctProcessedRange$MaxDate)
                                 # , separator = " to "
                )
              )
              , mainPanel( "Income" )
              # textOutput("testTxt") 
  )
  , navbarMenu("More",
            tabPanel("Summary", "Summary tab contents..."),
            tabPanel("Setup", "e.g Date format")
  )
  )))
                  # theme = "mytheme.css",
  
# shinyUI(fluidPage(
#   # Application title
#   titlePanel("Data on Neptune")
#   # , headerPanel("Simple Data")
# 
#     # Sidebar with a slider and selection inputs
#   , navlistPanel(
#     widths = c(2, 8)
#     
#     # , tabPanel("Monthly Spending"
#     #            , mainPanel(plotOutput("plotMnthly")) )
#     , tabPanel("TS Spending"
#                , mainPanel(
#                  sidebarLayout(
#                    sidebarPanel(
#                      sliderInput("inTSNumGrp", "Number of Categories"
#                                  , min = 1, max = 5, value = 3
#                                  )
#                      , checkboxGroupInput("inTSGroups", "Selected Categories"
#                                           ##    TO DO:    Change to use dynamic table input, e.g. dtAcctProcessedRange$BankAcct
#                                           , choices = c("CC", "Daily", "Saver", "Home Bills", "Home Loan")
#                                           , selected = "CC")
#                      , dateRangeInput("inTSDates", "Transaction Date Range"
#                                       # , start = (today() %m-% months(1)), end = today() 
#                                       , start = "2018-12-01", end = "2018-12-31"
#                                       , min ="2018-12-01" # min(dtAcctProcessedRange$MinDate)
#                                       , max = "2018-12-31"#max(dtAcctProcessedRange$MaxDate)
#                                       # , separator = " to "
#                                       )
#                    )
#                    , mainPanel(
#                      uiOutput("plotsTSSpending")
#                      # plotOutput("plotsTSSpending", width = "200%", height = "400px")
#                      )
#                  )
#                  # plotOutput("plotMnthly")
#                  ) 
#                )
#     , tabPanel("Debit VS Credit" #, width = 12
#                , mainPanel(dataTableOutput("tblDC")) 
#                )
#     # , tabPanel("tab 2", "content")
#   )
# ))
