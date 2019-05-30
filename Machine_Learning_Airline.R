#
# demonstrate generating dummy variables
#
library(recipes)
library(dplyr)
library(lindia)

# linear regression function for individual airlines
lmFunc <- function(formula) {
  lm_model <- lm(formula,data=model_data)
  print(summary(lm_model))
}

#
# load the data
#
data <- read.csv("Datasets/masterAirlineDataset_Clean.csv",
                 header = TRUE,
                 stringsAsFactors = FALSE) %>%
  mutate(SEAT_UTILIZATION = as.numeric(gsub("%", "", SEAT_UTILIZATION)))


#
prelim_model_data <-
  data %>%
#
# drop vars we won't use in the model
#
  select(-UNIQUE_CARRIER_NAME, # duplicates UNIQUE_CARRIER
         -MONTHNAME, # duplicates MONTH
         -MONTHLY_OP_EXPENSES, # redundant with profits
         -MONTHLY_NET_INCOME, # redundant with revenue and profits
         -PASSENGERS) %>%
#
# converte date to numeric for model
#
  mutate(DATE = as.integer(as.Date(DATE))) %>%
#
# fix some issues with UNIQUE_CARRIER variable
# 1) some are NA
#
  mutate(UNIQUE_CARRIER = case_when(
    is.na(UNIQUE_CARRIER) ~ "XXX",
    TRUE ~ UNIQUE_CARRIER
  )) %>%
#
# 2) get rid of special characters
#
  mutate(UNIQUE_CARRIER = case_when(
    UNIQUE_CARRIER == 'OH (1)' ~ "OHX",
    UNIQUE_CARRIER == 'YX (1)' ~ "YXX",
    TRUE ~ UNIQUE_CARRIER
  ))
#
# No airlines were missing after the median impute, but wanted to have an "OTHER" airline for 
# predicting arlines that are not in the dataset
#
prelim_model_data <- prelim_model_data %>%
  group_by(MONTH , YEAR) %>%
  summarise_each("median", -UNIQUE_CARRIER) %>%
  mutate(UNIQUE_CARRIER = "OTHER") %>% 
  bind_rows(prelim_model_data, .) 
#  
# package recipes allows many transformations
# the basic structure is to define the data relationship
# here it is done as a "formula" the same as would be used in lm() etc.
#
recipe_obj <-
  prelim_model_data %>%
  recipe(SEAT_UTILIZATION ~ ., data = (.)) %>%
#
# Calculating the median to replace the NA values with median value
#
  step_medianimpute(MONTHLY_OP_PROFIT_LOSS, MONTHLY_OP_REVENUES) %>%
#
# step_dummy generates and populates dummy variables automatically
#
  step_dummy("UNIQUE_CARRIER") %>%
#
# "prep" is as if you were cooking--you prepare everythign first
#
  prep()
#
# now you "bake" with the actual ingredients
# which are "prelim_model_data) we created above
# and assign the baked recipe to a new data.frame
# we can now use model_data in any model we choose
#
model_data <-
  bake(recipe_obj, new_data = prelim_model_data)

#
# lm model for each airline with other factors only for comparison purposes 
#
for (carrier in colnames(model_data)) {
  if(substr(carrier, 0, 6) == "UNIQUE"){
    formulaString <- paste("SEAT_UTILIZATION ~ ", carrier, "+ MONTH + YEAR + MONTHLY_OP_REVENUES + DEPARTURES_PERFORMED")
    lmFunc(formulaString)
  }
}

#
# LM Model with seat utilization and all the dummy variables
#
lm_model <- lm(SEAT_UTILIZATION ~ .  -SEATS -DATE -MONTHLY_OP_PROFIT_LOSS -MONTHLY_OP_REVENUES ,data=model_data)
summary(lm_model)
plot(lm_model, which=c(1,2))

#
# lm model with all the columns without revenue info
#
lm_model1 <- lm(SEAT_UTILIZATION ~ . -MONTHLY_OP_PROFIT_LOSS -MONTHLY_OP_REVENUES ,data=model_data)
summary(lm_model1)
plot(lm_model1, which=c(1,2))

#
# lm model with all the columns 
#
lm_model2 <- lm(SEAT_UTILIZATION ~ . ,data=model_data)
summary(lm_model2)
par(mfrow = c(2, 2))
# plotting the Residuals vs Fitted (Predicted) plot
plot(lm_model2, which = c(1))

#
# plotting predicted vs actual
#
par(mfrow=c(1,1)) 
plot(predict(lm_model2),model_data$SEAT_UTILIZATION,
     xlab="predicted",ylab="actual")
abline(a=0, b=1, col = "blue")

#
# plotting histogram of residuals
#
gg_reshist(lm_model2, bins = NULL)




