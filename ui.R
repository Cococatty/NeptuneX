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
              , checkboxInput("inExpWantToKnow", "I want to know...", value = FALSE)
              # I want to know
              # The total amount of money spent from StartDate to EndDate
              # By GroupByType (acct or category)
              # Of AcctName or CategoryList
              , conditionalPanel(condition = "input.inExpWantToKnow == true "
                                 , dateRangeInput("inExpWTKDates"
                                                  , paste("I want to know", "The total amount of money spent from StartDate to EndDate", sep="\n") 
                                                    # , start = (today() %m-% months(1)), end = today()
                                                    , start = "2018-12-01", end = "2018-12-31"
                                                    , min ="2018-12-01" # min(dtAcctProcessedRange$MinDate)
                                                    , max = "2018-12-31"#max(dtAcctProcessedRange$MaxDate)
                                                    # , separator = " to "
                                 )
                                 , selectInput("inExpWTKGrpByType", "By ", choices = c("account", "category"))
                                 , selectInput("inExpWTKGrpByValue", "Of ", choices = c("listOfAccts", "category"))
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
                , conditionalPanel(
                  condition = "input.inBNGType == 'budget' "
                    , selectInput("inBNGBQs", "Select a Question"
                                  , choices = c(	"Have I met my targets?" = "metTarget"
                                                  , "Budget VS Actual Expense?" = "budgetExp")
                    )
                  )
                 , conditionalPanel(condition = "input.inBNGType == 'goal' "
                    , selectInput("inBNGBQs", "Select a Question"
                               , choices = c(	"How big is the gap from my goals?" = "goalGap")
                               )
                 )
                
                
                , checkboxInput("inBNGRobot", label = "Neptune X help me please!", value = FALSE)
                ##  Conditionally display more quetsions base on study
                , conditionalPanel(
                  condition = "input.inBNGRobot == true "
                  , selectInput("inBNGRobKey", "Magic Keywords"
                                , c("cut", "better", "average", "reasonable")
                                , multiple=TRUE, selectize=TRUE
                                )
                )
              )
             
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
                                 # , start = (today() %m-% months(1)), end = today()
                                 , start = "2019-02-01", end = "2019-02-20"
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
  
