acctKeywordsList
t <- data.table(as.data.frame.list(acctKeywordsList, make.names = TRUE))
as.data.table(acctKeywordsList)
?as.data.frame.list


lengths(acctKeywordsList)

listLen <- sum(sapply(acctKeywordsList,length))


str(acctKeywordsList)
data.table(matrix(unlist(acctKeywordsList)
                  , nrow = listLen
                  , byrow = TRUE))


do.call(rbind.data.frame, acctKeywordsList)

dfKeywords <- data.frame(t(sapply(acctKeywordsList,c)))
unL <- unlist(dfKeywords)
length(unL)
for (i in unL) {
  print(i)
}

t <- sapply(dfKeywords, unlist)
str(t)
unlist(t)
t["NY2019"]
names(t)


acctKeywordsList["NY2019"]
View(dfKeywords)


melt(dfKeywords)
?melt
