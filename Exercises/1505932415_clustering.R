# This mini-project is based on the K-Means exercise from 'R in Action'
# Go here for the original blog post and solutions
# http://www.r-bloggers.com/k-means-clustering-from-r-in-action/

# Exercise 0: Install these packages if you don't have them already

# install.packages(c("cluster", "rattle.data","NbClust"))

# Now load the data and look at the first few rows
data(wine, package="rattle.data")
head(wine)

# Exercise 1: Remove the first column from the data and scale
# it using the scale() function
df <- scale(wine[-1])

# Now we'd like to cluster the data using K-Means. 
# How do we decide how many clusters to use if you don't know that already?
# We'll try two methods.

# Method 1: A plot of the total within-groups sums of squares against the 
# number of clusters in a K-means solution can be helpful. A bend in the 
# graph can suggest the appropriate number of clusters. 

wssplot <- function(data, nc=15, seed=1234){
	              wss <- (nrow(data)-1)*sum(apply(data,2,var))
               	      for (i in 2:nc){
		        set.seed(seed)
	                wss[i] <- sum(kmeans(data, centers=i)$withinss)}
	                
		      plot(1:nc, wss, type="b", xlab="Number of Clusters",
	                        ylab="Within groups sum of squares")
	   }

wssplot(df)

# Exercise 2:
#   * How many clusters does this method suggest?
#   * Why does this method work? What's the intuition behind it?
#   * Look at the code for wssplot() and figure out how it works

# the bend is between 2 and 4 clusters, so 3 clusters is what this method suggests
# Sum of squares distance is the distance between each data point to the centroid in its group.
# With lower sum of squares, the accuracy is higher.
# Also, we can see that with additional clusters, the improvement is only marginal in the sum of squares value
# so choosing the number of clusters at the bend is the best. 

# wssplot takes in the dataset, the number of total possible clusters and a random seed number as input
# it takes the sum of variance across all the columns and multiplies it with the number of columns
# Then it takes the sum of the groups of sum of squares by passing the number of clusters as centers to the kmeans
# The function then plots the number of clusters against the sum of squares

# Method 2: Use the NbClust library, which runs many experiments
# and gives a distribution of potential number of clusters.

library(NbClust)
set.seed(1234)
nc <- NbClust(df, min.nc=2, max.nc=15, method="kmeans")
barplot(table(nc$Best.n[1,]),
	          xlab="Numer of Clusters", ylab="Number of Criteria",
		            main="Number of Clusters Chosen by 26 Criteria")


# Exercise 3: How many clusters does this method suggest?

# The suggested number of clusters is between 2 and 10

# Exercise 4: Once you've picked the number of clusters, run k-means 
# using this number of clusters. Output the result of calling kmeans()
# into a variable fit.km

fit.km <- kmeans( df, centers=3 )

# Now we want to evaluate how well this clustering does.

# Exercise 5: using the table() function, show how the clusters in fit.km$clusters
# compares to the actual wine types in wine$Type. Would you consider this a good
# clustering?
clusters <- table(fit.km$cluster,wine$Type)

# yes, except for 6 observations, everything seems to be clustered correctly
#    1  2  3
# 1  0  3 48
# 2  0 65  0
# 3 59  3  0

# Exercise 6:
# * Visualize these clusters using  function clusplot() from the cluster library
# * Would you consider this a good clustering?
library("cluster")
clusplot(df, fit.km$cluster)

# yes, the clusters are identified fairly clearly, but there is some minor overlap between the clusters
