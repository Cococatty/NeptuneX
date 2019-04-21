source("mainSetup.R")
source("mainFunctions.R")

shinyUI(fluidPage(navbarPage("Neptune X Data Planet", # HEADER
             theme = shinythemes::shinytheme("superhero"),
  
  # Spending
  tabPanel( "Spending" # menuSpending, # "Plot tab contents..."
          
            ########        SIDE BAR, SPENDING          ########
          , sidebarPanel(
              # sliderInput("spendNumGrp", "Number of Accounts to"
              #             , min = 1, max = 5, value = 3
              # )
              checkboxGroupInput("spendAccts", "Select accounts to analysis"
                                  , choices = c(dtAcctDates$BankAcct)
                                  , selected = "CC")
              , dateRangeInput("spendDates", "Transaction Date Range"
                               , start = ymd("2018-09-01") # dateRangeStart
                               , end = dateRangeEnd
                               , min = dateRangeMin
                               , max = dateRangeMax
              )
              , checkboxInput("spendWTK", "I want to know...", value = FALSE)
              # I want to know
              # The total amount of money spent from StartDate to EndDate
              # By GroupByType (acct or ExpCategory)
              # Of AcctName or CategoryList
              , conditionalPanel(condition = "input.spendWTK == true "
                                 , dateRangeInput("spendWTKDates"
                                                  , paste("I want to know", "The total amount of money spent from StartDate to EndDate", sep="\n") 
                                                  , start = dateRangeStart, end = dateRangeEnd
                                                  , min = dateRangeMin
                                                  , max = dateRangeMax
                                 )
                                 , selectInput("spendWTKGrpByType", "By ", choices = c("account", "ExpCategory"))
                                 , selectInput("spendWTKGrpByValue", "Of ", choices = c("listOfAccts", "ExpCategory"))
              )
            )
          
          ########        MAIN PANEL, SPENDING          ########
          , mainPanel(
              tabsetPanel(
                tabPanel("Monthly Spending"
                         # , mainPanel(plotOutput("spendPlotMnth"))
                         , mainPanel(
                           textOutput("testText"),
                           uiOutput("spendPlotsMnth"))
                )
                , tabPanel("Annual Spending"
                            , mainPanel(uiOutput("spendPlotsAnnual")
                          )
                              )
                , tabPanel("Debit VS Credit" #, width = 12
                            , mainPanel(dataTableOutput("spendTblDC"))
                            )
              )
            )
          )
  , tabPanel( "Budget & Goal"
              , sidebarPanel(
                radioButtons("bngType", label = "The KEY"
                            , choices = c("Budget" = "budget", "Goal" = "goal")
                )
                , conditionalPanel(
                  condition = "input.bngType == 'budget' "
                    , selectInput("bngBQs", "Select a Question"
                                  , choices = c(	"Have I met my targets?" = "metTarget"
                                                  , "Budget VS Actual Expense?" = "budgetExp")
                    )
                  )
                 , conditionalPanel(condition = "input.bngType == 'goal' "
                    , selectInput("bngBQs", "Select a Question"
                               , choices = c(	"How big is the gap from my goals?" = "goalGap")
                               )
                 )
                
                
                , checkboxInput("bngRobot", label = "Neptune X help me please!", value = FALSE)
                ##  Conditionally display more quetsions base on study
                , conditionalPanel(
                  condition = "input.bngRobot == true "
                  , selectInput("bngRobKey", "Magic Keywords"
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
                                 , start = dateRangeStart, end = dateRangeEnd
                                 , min = dateRangeMin
                                 , max = dateRangeMax
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
  
