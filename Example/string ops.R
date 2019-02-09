otherPartyList <- unique(dtReportData$OtherParty)[1:30]
tC <- unlist(acctKeywordsList$Coffee)

gregexpr(tC, otherPartyList)
otherPartyList[grepl(paste0(tC, collapse = "|"), otherPartyList) == TRUE]

grepl(acctKeywordsList$Eatout, dtReportData)
grepl(acctKeywordsList$Event, dtReportData)

??grepl

match(acctKeywordsList$Eatout, dtReportData)
match(dtReportData, acctKeywordsList$Eatout)

acctKeywordsList$Eatout %in% dtReportData
dtReportData %in% acctKeywordsList$Eatout
str_detect(acctKeywordsList$Eatout, dtReportData)
str_detect(dtReportData, acctKeywordsList$Eatout)


listT <- unlist(acctKeywordsList$Eatout)
pmatch(listT, dtReportData)
pmatch(acctKeywordsList$Eatout, dtReportData)
pmatch(dtReportData, listT)


charmatch(listT,  dtReportData$Reference)
charmatch(dtReportData$OtherParty, listT)

unique(dtReportData$OtherParty)

dtReportData$Reference