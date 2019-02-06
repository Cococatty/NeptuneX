getwd()

library(data.table)

list.files()
list.files("./Inputs")

##    REAWD ALL COLUMNS IN FILE OF DATA TYPE STRING
ccData <- data.table(read.csv("Inputs/2018-4/AXXXX_XXXX_XXXX_6144-10Apr18.csv", colClasses = c("character"))
                     , stringsAsFactors = F)

##  TAKE OUT SPECIAL CHARACTER OF "." IN COLUMN NAMES
names(ccData) <- gsub(pattern = "[.]", x = names(ccData), "")

##  TO DO: If col name like "date" then do the conversion
ccData[, ":=" ( ProcessDate = as.Date(TransactionDate, "%d/%m/%Y")
              , TransactionDate = as.Date(TransactionDate, "%d/%m/%Y")
              , Amount = as.numeric(Amount)
       )]


# dateCols <- c("ProcessDate", "TransactionDate")


# dailyData <- data.table(read.csv("Inputs/2018-4/A0315920567389000-10Apr18.csv"))
# homeLoanData <- data.table(read.csv("Inputs/2018-4/A0315920567389091-10Apr18.csv"))




comDT <<- data.table( FullDate = as.Date(character())
                    , Amount = numeric()
                    , OtherParty = character()
                    , Reference = character()
                    , AcctType = character()
                    , Note = character()
                    , ID = integer()
                    , Day = integer()
                    , Month = integer()
                    , Year = integer()
                    )



lastID <- ifelse(nrow(comDT) == 0, 1 )

#########         Env Setup Start         #########
newData <- ccData
acctType <- "CC"

#########         Env Setup End         #########

basicProecss <- function(newData, acctType) {
  
  newDetails <- newData[ , .( TransactionDate
                              , Amount
                              , OtherParty
                              , CreditPlanName
                              , acctType
                              , ForeignDetails
                            )]
  #########         Env Setup Start         #########
  attach(newDetails)
  detach(newDetails)
  #########         Env Setup End         #########
  
  newDetails[, ":=" (
    ID = seq(from = lastID, by = 1, to = nrow(newDetails))
    , Date = mday(TransactionDate)
    , Month = month(TransactionDate)
    , Year = year(TransactionDate)
  )]
  
  
  # temp <- rbind(comDT, newDetails, fill = TRUE)
  (temp <- rbind(comDT, newDetails, fill = FALSE))
  )
    

}


############            LAB            ############
rm(list = ls())
rm(newDetails)

class(ccData$Amount)
names(ccData)
class(ccData)
class(newDetails)

View(ccData)
View(dailyData)
View(homeLoanData)
View(comDT)

head(ccData)
head(dailyData)
head(homeLoanData)

# attach(ccData)



?merge

class(as.Date(ccData$ProcessDate, format ="%d/%m/%Y"))
class(ccData$ProcessDate)
class(ccData$TransactionDate)

