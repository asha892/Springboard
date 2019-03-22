#Step 0 - read file
  titanicDF <- read.csv(file="titanic_original.csv", header=TRUE, sep=",")

#Step 1 - Port of embarkation
  #setting all blank values in data frame to NA
  titanicDF[titanicDF==""] <- NA 
  
  #replacing NA's in embarked column with S
  titanicDF[is.na(titanicDF$embarked), "embarked"] <- 'S' 
  
#Step 2 - Age
  #calculating mean and assigning it to the missing values in the age column
  titanicDF[is.na(titanicDF$age), "age"] <- mean(titanicDF$age, na.rm = TRUE)
  
  #Another approach: As the names contain Miss/Master to identify children, we can take mean ages
  #of all the children and assign it to any blank rows who name identifies them as a child
  #Same way for adults. This would be a slightly better approach to be more accurate.
  
#Step 3 - Lifeboat
  #adding None to factors and refactoring boat column as boat column's class is a factor
  levels <- levels(titanicDF$boat)
  levels <- c(levels, "None");
  titanicDF$boat <- factor(titanicDF$boat, levels = levels)
  
  #populating all missing values in the boat column with the string 'None'
  titanicDF[is.na(titanicDF$boat), "boat"] <- 'None'
  
#Step 4 - Cabin
  #Creating has_cabin_number column which has 1 if there is a cabin number and 0 otherwise
  titanicDF <- titanicDF %>%
    mutate(has_cabin_number=case_when(!is.na(cabin)~"1",TRUE~"0"))
  
