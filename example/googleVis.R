##  https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html

require(googleVis) ## googleVis 0.5.0-3
dat <- data.frame(Room=c("Room 1","Room 2","Room 3"),
                  Language=c("English", "German", "French"),
                  start=as.POSIXct(c("2014-03-14 14:00", 
                                     "2014-03-14 15:00",
                                     "2014-03-14 14:30")),
                  end=as.POSIXct(c("2014-03-14 15:00", 
                                   "2014-03-14 16:00",
                                   "2014-03-14 15:30")))
plot(
  gvisTimeline(data=dat, 
               rowlabel="Room", barlabel="Language", 
               start="start", end="end")
)




###################         LINE CHART
df=data.frame(country=c("US", "GB", "BR"), 
              val1=c(10,13,14), 
              val2=c(23,12,32))
Line <- gvisLineChart(df)
plot(Line)



###################         Column chart
Column <- gvisColumnChart(df)
plot(Column)


###################         Table with pages
PopTable <- gvisTable(Population, 
                      formats=list(Population="#,###",
                                   '% of World Population'='#.#%'),
                      options=list(page='enable'))
plot(PopTable)


###################         TEST FIELD
dtTest <- data.table(TransYearMonth = dtSums$TransYearMonth, Debit = as.numeric(dtSums$Debit) )
Line1 <- gvisLineChart(dtTest)
plot(Line1)

