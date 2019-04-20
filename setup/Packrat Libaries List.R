.libPaths()

myPaths <- .libPaths()
myPaths[1] <- "C:/Dev Tools/RStudio/library"
# myPaths[2] <- "C:/Dev Tools/RStudio/library/All"
myPaths[2] <- "C:/Program Files/Microsoft SQL Server/130/R_SERVER/library"
myPaths <- c(myPaths[2], myPaths[1])

# myPaths <- c(myPaths)

.libPaths(myPaths)
.libPaths("C:/Dev Tools/RStudio/library/3.2")

library()


install.packages("sqldf", defaultLibraryLoc)
install.packages("XLConnect", defaultLibraryLoc)
install.packages("data.table", defaultLibraryLoc)
install.packages("shiny", defaultLibraryLoc)
install.packages("lubridate", defaultLibraryLoc)
install.packages("assertr", defaultLibraryLoc)
install.packages("magrittr", defaultLibraryLoc)
install.packages("sourcetools", defaultLibraryLoc)
install.packages("htmltools", defaultLibraryLoc)

install.packages("later", defaultLibraryLoc)
install.packages("promises", defaultLibraryLoc)
install.packages("crayon", defaultLibraryLoc)
install.packages("rlang", defaultLibraryLoc)

install.packages("packrat", lib=defaultLibraryLoc)

install.packages("openxlsx", defaultLibraryLoc)
install.packages("pbkrtest", defaultLibraryLoc)

install.packages("shinythemes", defaultLibraryLoc)

install.packages("data.table")
install.packages("car")


update.packages(lib.loc = "C:/Program Files/RStudio/library/3.2")

library("data.table", lib.loc = "C:/Program Files/RStudio/library/3.2")

