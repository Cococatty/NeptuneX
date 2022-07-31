# "Seq",
comDT[, c("Seq", "Date", "Amount", "Other.Party", "Reference", "Acct.Type", "Note") :=
        list(
          seq(from = nrow(comDT), by = 1)
          , Transaction.Date
          , Amount
          , Other.Party
          , Credit.Plan.Name
          , "CC"
          , NA_character_
        )
      ]


comDT[, c("Seq", "Date", "Amount", "Other.Party", "Reference", "Acct.Type", "Note") :=
        list(
          as.integer(1) 
          , as.Date("10/04/2018", "%d/%m/%Y")
          , 100
          , "Other.Party"
          , "Credit.Plan.Name"
          , "CC"
          , "NA_character_"
        )
      ]



lapply(ProcessDate, as.Date, format ="%d/%m/%Y") 