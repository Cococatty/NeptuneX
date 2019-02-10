############################                server.R                ############################
# for (i in 1:nPlots) {#input$inTSNumGrp
#   local({
#     plotName <- paste0("plotTS", i, collapse = "")
#     
#     output[[plotName]] <- renderPlot({
#       # plotTSSimple(selectedAcct = input$inTSGroups[i], selectDateRange = input$inTSDates)
#       selectedAcct <- "CC"
#       selectDateRange <- c("2018-12-01", "2018-12-31")
#       
#       dtTargetData <- dtReportData[ BankAcct == selectedAcct & TransDate %between%selectDateRange, ]
#       dtSumByDate <- aggregate(Debit~ TransDate, data = dtTargetData, FUN = sum)
#       
#       plotTitle <- sprintf("Spending total by Date in %s from %s"
#                            , selectedAcct, paste0(selectDateRange, collapse = " to "))
#       plot(x = dtSumByDate$TransDate, y = dtSumByDate$Debit, main = plotTitle, type = "b"
#            , xlab = "Transaction Date", ylab = "Amount ($)")
#     })
#   })
#  }

# output$plotsTSSpending <- renderUI({
#   for (i in input$inTSGroups) {
#     plotTSSimple(selectedAcct = i, selectDateRange = input$inTSDates) 
#   }


# output$plotsTSSpending <- renderPlot(plotTSSimple(selectedAcct = input$inTSGroups
# , selectDateRange = input$inTSDates))

# output$plotMnthly <- renderPlot()

############################                PACKAGES AND LIBRARY                ############################
# install.packages(pkgs = "pbkrtest", lib = defaultLibraryLoc, repos = getOption("repos")
#                  , contriburl = "https://cran.r-project.org/src/contrib/pbkrtest_0.4-7.tar.gz"
#                  , dependencies = TRUE
#                  , verbose = TRUE)
#                  


install.packages("C:/Projects/Neptune/R pkg/openxlsx_4.1.0.zip", repos = NULL, type = "win.binary", lib=defaultLibraryLoc)
install.packages("C:/Projects/Neptune/R pkg/pbkrtest_0.4-7.zip", repos = NULL, type = "win.binary", lib=defaultLibraryLoc)
