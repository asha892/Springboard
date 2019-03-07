# CAPSTONE PROJECT PROPOSAL
## Problem to solve
   Summary: Predicting the number of empty seats ahead of time can help airlines to take actions for maximising reservation / reducing the planned number of flights.
   
   In the airline industry where the profit margins are usually razor-thin, ensuring that there are no empty seats on every flight is very important. Flights where there are many empty seats hurt the airline's bottom line as the costs to operate the flight is pretty high. Predicting the percentage of empty seats of a flight is critical as the airlines could then act on the data to maximize profits. 
   
   This can depend on a variety of factors like brand reputation, pricing of the different classes of seats (first, business, economy etc.) and month of the year as demand would be higher in certain months due to holidays or other factors. The goal of this project would be to focus on predicting the demand based on the month of the year.
   
## Potential Clients

   Given that this is a common problem across the entire airline industry, any airline would benefit from this analysis. If the airline could more accurately predict the demand for the flights for the next few months, they could either reduce the number of planned flights which will in turn reduce the operating costs or they can work on running promotions to increase the seat utilization. Unlocking the insights from this data would be critical to maximize seat utilization for the airline. 
    
## Data

The data for this project is sourced from AviationDB. This has data of the seat utilization for multiple airlines. For every month, this data set has the total number of seats and the total number of passengers that flew that month across all the flights. So we can calculate the total number of empty seats for an airline for that month. This data set also has other details like the number of departures, so we can find out the average seat utilization by flight as well. Also this data set has data for every month starting October 0f 2018 to January of 1990 (18 years). 

Reference: http://www.aviationdb.com/Aviation/F4SDetailQuery.shtm

## Approach

The goal would be to build a model that can predict the seat utilization for any given airline for a particular month of the year based on the number of planned flights for that month. From the number of planned flights, we can calculate the total number of seats. The first step of this project would be to gather all this data from the website in a spreadsheet by month. Then this data would be combined in a single csv where month would be a column, so we would have the data for every airline by month in the csv.

In the data wrangling phase of the project, after importing the csv in R, we would be eliminating rows that do not have enough data. So if the number of flights or number of passengers are very low, that the utilization is close to 0, we can elminate those rows, or if it is a common trend for certain airlines, we can eliminate those airlines from the data set. 

## Deliverables

The deliverables for this project will include code, documentation and a presentation which describes the project and the benefits of the analysis.
