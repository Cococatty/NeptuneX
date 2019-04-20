#######   URL
##  http://rstudio.github.io/packrat/commands.html#localrepos?version=1.1.463&mode=desktop

############        LIBRARIES SECTION STARTS        ############
install.packages(c("assertr", "data.table", "lubridate", "sqldf", "XLConnect", "googleVis"
                   , "shinytheme"))


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
                  , local.repos = c("C:/Projects/Neptune/downloaded_packages"))


packrat::restore(prompt = FALSE)


## Toggle packrat mode on and off, for navigating between projects within a single R session.
packrat::on()
packrat::off()
