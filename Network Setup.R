.libPaths()

myPaths <- .libPaths()
myPaths[1] <- "C:/Dev Tools/RStudio/library"
myPaths[2] <- "C:/Program Files/Microsoft SQL Server/130/R_SERVER/library"

# myPaths <- c(myPaths)

.libPaths(myPaths)
(defaultLibraryLoc <- .libPaths()[1])



options(repos = c(CRAN = "http://cran.rstudio.com"))

getOption("repos")


install.packages(c("assertr", "data.table", "lubridate", "sqldf", "XLConnect"))



install.packages("C:/Projects/Neptune/R pkg/openxlsx_4.1.0.zip", repos = NULL, type = "win.binary", lib=defaultLibraryLoc)
install.packages("C:/Projects/Neptune/R pkg/pbkrtest_0.4-7.zip", repos = NULL, type = "win.binary", lib=defaultLibraryLoc)


############        PACKRAT
install.packages("packrat")
install.packages("devtools")
devtools::install_github("rstudio/packrat")

packrat::init("C:/Projects/Neptune")
# packrat::init()




# install.packages(pkgs = "pbkrtest", lib = defaultLibraryLoc, repos = getOption("repos")
#                  , contriburl = "https://cran.r-project.org/src/contrib/pbkrtest_0.4-7.tar.gz"
#                  , dependencies = TRUE
#                  , verbose = TRUE)