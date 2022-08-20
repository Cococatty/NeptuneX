source("setup.R")
source("key_functions.R")



shinyUI(fluidPage(
  navbarPage(
    "Neptune X Data Planet", # HEADER
    theme = shinythemes::shinytheme("superhero"),
  
  ######## SPENDING TAB
  tabPanel( "Spending Info", "Spending", # "Plot tab contents..."
          
  ########        SIDE BAR, SPENDING          ########
  sidebarPanel(
    fileInput("csv_input", "Choose CSV File",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")
    ),
    tags$hr(),
  ))
          
  ########        MAIN PANEL, SPENDING          ########
  , mainPanel(
    tabsetPanel(
      id = "tab_spend"
      , tabPanel("Input File", mainPanel(tableOutput("loaded_csv")))
      , tabPanel("Monthly Spending", mainPanel(uiOutput("plot_monthly_debit")))
      , tabPanel("Annual Spending", mainPanel(uiOutput("plot_yearly_debit")))
      
      #, width = 12
    ))
  
  )))
