library(ggplot2)

monthnames <- c("Jan","Feb","Mar",
                "Apr","May","Jun",
                "Jul","Aug","Sep",
                "Oct","Nov","Dec")
years <- c(2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017);

#
# Function for calculating Number of airlines at different seat utilization percentages for every month
#
monthPlot <- function(df, monthIndex, year){
  print(
        df %>%
        filter(MONTH == monthIndex) %>%
        filter(YEAR == year) %>%
        ggplot(aes(x = SEAT_UTILIZATION)) +
        geom_histogram() +
        ggtitle(paste(monthnames[monthIndex], year))
  )
}

#
# Function for Plotting the seat utilization for each airline (151 airlines) by month 
# and seat utilization and color coding it by year.
#
airlinesPlot <- function(carrierName) {
  
  print(ggplot(masterDF[masterDF$UNIQUE_CARRIER_NAME==carrierName, ], aes(x = MONTH, y = SEAT_UTILIZATION, col=factor(YEAR))) +
          geom_point()+
          geom_smooth(method="lm")+
          scale_x_continuous(breaks = masterDF$MONTH)+
          ggtitle(paste(carrierName)))
}

#
# load the data
#
masterDF <- read.csv("Datasets/masterAirlineDataset_Clean.csv",
                 header = TRUE,
                 stringsAsFactors = FALSE)
masterDF$DATE <- as.Date(masterDF$DATE)

#
# Number of airlines at different seat utilization percentages for every month
#
pdf("monthPlots.pdf", width=8.5, height=5)
for(year in years)
  for(monthIndex in c(1:12)){
    monthPlot(masterDF, monthIndex, year)
  }
dev.off()

#
# average seat utilization by year across all airlines
#
ggplot(aggDF, aes(x = MONTH, y = SEAT_UTILIZATION, col=factor(YEAR))) +
  geom_point()+
  geom_smooth(method="loess")+
  scale_x_continuous(breaks = aggDF$MONTH)

#
# Seat Utilization By Date across all airlines
#
masterDF %>%
  ggplot(aes(x = DATE, y = SEAT_UTILIZATION)) +
  geom_smooth(method = "loess", se = FALSE, span = 0.05)

#
# Plotting the seat utilization for each airline (151 airlines) by month and seat utilization and color coding it by year.
#
pdf("airlinePlots.pdf", width=8.5, height=5)
for(i in seq_along(levels(factor(masterDF$UNIQUE_CARRIER_NAME)))) {
    airlinesPlot(levels(factor(masterDF$UNIQUE_CARRIER_NAME))[i]) 
}
dev.off()


