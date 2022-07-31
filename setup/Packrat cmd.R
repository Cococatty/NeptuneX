#######   URL
##  http://rstudio.github.io/packrat/commands.html#localrepos?version=1.1.463&mode=desktop

############        LIBRARIES SECTION STARTS        ############

##  LIBRARY PATH CHECK
.libPaths()
myPaths <- .libPaths()


install.packages("packrat")
library(packrat)

install.packages(c(
  "data.table","shiny","lubridate","assertr","magrittr","pbkrtest","shinythemes","car", "googleVis"
  , "rsconnect"
  ,"sqldf", "XLConnect","openxlsx"
  ,"sourcetools","htmltools"
  ,"later","promises","crayon","rlang"
  ,"backports"
  ,"clisymbols"
  ,"desc"
  ,"devtools"
  ,"fs"
  ,"gh"
  ,"git2r"
  ,"ini"
  ,"pkgbuild"
  ,"pkgload"
  , "BioCircos"
), dependencies = TRUE)

############        LIBRARIES SECTION ENDS        ############


## SAVE SNAPSHOT
packrat::snapshot()

##  Remove unused packages from your library.
packrat::clean()

## Bundle a packrat project, for easy sharing.
packrat::bundle()
# packrat::unbundle()

##  SET SETUP OPTIONS
packrat::set_opts(auto.snapshot = TRUE, vcs.ignore.lib = FALSE
                  , local.repos = c("C:/Projects/NeptuneX/downloaded_packages"))


packrat::set_opts(vcs.ignore.lib = TRUE, vcs.ignore.src = TRUE)


packrat::restore(prompt = FALSE)


## Toggle packrat mode on and off, for navigating between projects within a single R session.
packrat::on()
packrat::off()
