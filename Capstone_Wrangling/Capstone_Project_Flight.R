#Step 1 - read file
flightDF <- read.csv(file="CapstoneDataset.csv", header=TRUE, sep=",")

#step2 - Renaming and deleting unused columns
colnames(flightDF)[c(8:10)] <- c("payload","freight","mail")
flightDF[,c("payload","freight","mail")]<- NULL

#step3 - Replacing hyphen with NA
flightDF[ flightDF == "-" ] <- NA

#step4 - Deleting rows with zero seats as they are outliers
flightDF<- flightDF[!(flightDF$Seats== 0),]

#step5 - Removing carriers that do not have data for atleast 12 months
flightDF <- flightDF %>% group_by(Carrier) %>% filter(n() > 12) 

#step 6 - write the clean file
write.csv(flightDF, file = "CapstoneDataset_Clean.csv",row.names=FALSE)

