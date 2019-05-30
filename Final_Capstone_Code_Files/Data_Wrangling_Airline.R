library(dplyr)
library(formattable)

#
# Function for reading and wrangling the financial information for every finance file
#
readAndPrepFINFile <- function(fileName) {
  #
  # read Airline Finance Dataset
  #
  DF <- read.csv(file=fileName, header=TRUE, sep=",", na.strings = "ZZZ")
  
  #
  # Grouping by month, carrier and taking a sum of all the other variables like income,profit,revenue and expense.
  #
  DF <- DF %>% 
    group_by(UNIQUE_CARRIER, UNIQUE_CARRIER_NAME, YEAR) %>%
    summarise(NET_INCOME = sum(NET_INCOME), OP_PROFIT_LOSS = sum(OP_PROFIT_LOSS),
              OP_REVENUES = sum(OP_REVENUES), OP_EXPENSES = sum(OP_EXPENSES))
  
  DF$MONTHLY_NET_INCOME <- DF$NET_INCOME/12
  DF$MONTHLY_OP_PROFIT_LOSS <- DF$OP_PROFIT_LOSS/12
  DF$MONTHLY_OP_REVENUES <- DF$OP_REVENUES/12
  DF$MONTHLY_OP_EXPENSES <- DF$OP_EXPENSES/12
  
  return(DF)
}

#
# Function for reading and wrangling each Seat Utilization data file and for merging the finance data together
#
readAndPrepSUFile <- function(fileName, finDF) {
  
  subsetFinDF <- finDF[ ,c("UNIQUE_CARRIER", "MONTHLY_NET_INCOME", "MONTHLY_OP_PROFIT_LOSS", "MONTHLY_OP_REVENUES", "MONTHLY_OP_EXPENSES")]
  
  #
  # read Airline Dataset
  #
  DF <- read.csv(file=fileName, header=TRUE, sep=",", na.strings = "NNN")
  #
  # Removing column X and Class from DF
  #
  DF[ ,c('X', 'CLASS')] <- list(NULL)
  #
  # Selecting only rows that are for domestic US flights
  # 
  DF <- DF[(DF$ORIGIN_COUNTRY=="US" & DF$DEST_COUNTRY=="US"),]
  #
  # Grouping by month, carrier and taking a sum of all the other variables like seats etc.
  #
  DF <- DF %>% 
    group_by(UNIQUE_CARRIER, UNIQUE_CARRIER_NAME, YEAR, MONTH) %>%
    summarise(DEPARTURES_SCHEDULED = sum(DEPARTURES_SCHEDULED), DEPARTURES_PERFORMED = sum(DEPARTURES_PERFORMED),
              SEATS = sum(SEATS), PASSENGERS = sum(PASSENGERS))
  
  #
  # Deleting rows with zero seats as they are outliers
  #
  DF<- DF[!(DF$SEATS== 0),]
  
  #
  # Changing the month coloumn from number to abbreviation
  #
  monthnames <- c("Jan","Feb","Mar",
                  "Apr","May","Jun",
                  "Jul","Aug","Sep",
                  "Oct","Nov","Dec")
  
  DF$MONTHNAME <- monthnames[DF$MONTH]
  DF$DATE <- ISOdate(DF$YEAR, DF$MONTH, 1, 0, 0, 0)
  
  #
  # Removing carriers that do not have data for all 12 months
  #
  DF <- DF %>% group_by(UNIQUE_CARRIER_NAME) %>% filter(n() == 12)
  DF <- merge(DF, subsetFinDF, by="UNIQUE_CARRIER", all.x = TRUE)
  
  return(DF)
}

#
# Reading and Wrangling each of the finance files
#
DFF2017 <- readAndPrepFINFile("Datasets/2017Fin.csv")
DFF2016 <- readAndPrepFINFile("Datasets/2016Fin.csv")
DFF2015 <- readAndPrepFINFile("Datasets/2015Fin.csv")
DFF2014 <- readAndPrepFINFile("Datasets/2014Fin.csv")
DFF2013 <- readAndPrepFINFile("Datasets/2013Fin.csv")
DFF2012 <- readAndPrepFINFile("Datasets/2012Fin.csv")
DFF2011 <- readAndPrepFINFile("Datasets/2011Fin.csv")
DFF2010 <- readAndPrepFINFile("Datasets/2010Fin.csv")
DFF2009 <- readAndPrepFINFile("Datasets/2009Fin.csv")
DFF2008 <- readAndPrepFINFile("Datasets/2008Fin.csv")

#
# Reading and Wrangling each of the Seat Utilization Data files
#
DFSU2017 <- readAndPrepSUFile("Datasets/2017New.csv", DFF2017)
DFSU2016 <- readAndPrepSUFile("Datasets/2016New.csv", DFF2016)
DFSU2015 <- readAndPrepSUFile("Datasets/2015New.csv", DFF2015)
DFSU2014 <- readAndPrepSUFile("Datasets/2014New.csv", DFF2014)
DFSU2013 <- readAndPrepSUFile("Datasets/2013New.csv", DFF2013)
DFSU2012 <- readAndPrepSUFile("Datasets/2012New.csv", DFF2012)
DFSU2011 <- readAndPrepSUFile("Datasets/2011New.csv", DFF2011)
DFSU2010 <- readAndPrepSUFile("Datasets/2010New.csv", DFF2010)
DFSU2009 <- readAndPrepSUFile("Datasets/2009New.csv", DFF2009)
DFSU2008 <- readAndPrepSUFile("Datasets/2008New.csv", DFF2008)

#
# Combining data of all the years to form master dataframe.
#
masterDF <- rbind(DFSU2017, DFSU2016, DFSU2015, DFSU2014, DFSU2013, DFSU2012, DFSU2011, DFSU2010, DFSU2009, DFSU2008)
#
# Calculating seat utilization
#
masterDF$SEAT_UTILIZATION <- percent(masterDF$PASSENGERS/masterDF$SEATS)

seatUtilizationDF <- masterDF[,c("YEAR", "MONTH", "SEAT_UTILIZATION")]
masterDF$SEAT_UTILIZATION <- gsub("%", "", masterDF$SEAT_UTILIZATION)
masterDF$SEAT_UTILIZATION <- as.numeric(masterDF$SEAT_UTILIZATION)
masterDF$DATE <- as.Date(masterDF$DATE)

#
# aggregating by month across airlines to calculate average seat utilization.
#
aggDF <- aggregate(seatUtilizationDF,
                    by = list(seatUtilizationDF$MONTH, seatUtilizationDF$YEAR),
                    FUN = mean)

#
# Writing the clean file
#
write.csv(masterDF, file = "Datasets/masterAirlineDataset_Clean.csv",row.names=FALSE)

