shinyUI(fluidPage(
  # Application title
  titlePanel("Data on Neptune")
  # , headerPanel("Simple Data")

    # Sidebar with a slider and selection inputs
  , navlistPanel(
    tabPanel("Debit VS Credit"
             , mainPanel(dataTableOutput("tblDC")) )
    # , tabPanel("Monthly Spending"
    #            , mainPanel(plotOutput("plotMnthly")) )
    # , tabPanel("tab 2", "content")
  )
))