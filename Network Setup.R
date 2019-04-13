.libPaths()

myPaths <- .libPaths()
myPaths[1] <- "C:/Dev Tools/RStudio/library"
myPaths[2] <- "C:/Program Files/Microsoft SQL Server/130/R_SERVER/library"

# myPaths <- c(myPaths)

.libPaths(myPaths)
(defaultLibraryLoc <- .libPaths()[1])



options(repos = c(CRAN = "http://cran.rstudio.com"))

getOption("repos")


install.packages(c("assertr", "data.table", "lubridate", "sqldf", "XLConnect"
                   , "googleVis"))

install.packages("shinythemes")

install.packages()

# remove.packages("data.table", lib="")



############        PACKRAT
install.packages("packrat")
install.packages("devtools")
devtools::install_github("rstudio/packrat")


packrat::init("C:/Projects/Neptune")


