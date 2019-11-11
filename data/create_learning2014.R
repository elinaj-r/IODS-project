# Elina Järvelä-Reijonen
# 11.11.2019
# R script for data wrangling, data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt 

#Reading the data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#Exploring the dimensions of the data
dim(lrn14)

#Looking at the structure of the data
str(lrn14)

#Data includes 183 observations (rows) and 60 variables (columns). Most of the values are integers.


#Scaling the combination variables (Attitude, Deep, Surf, Stra) to the original scales (by taking the mean).

#Attitude is a sum of 10 variables, creating attitude by taking the mean of Attitude.
lrn14$Attitude
lrn14$attitude <- lrn14$Attitude / 10
lrn14$attitude

# Access the dplyr library
install.packages("dplyr")
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

#Creating analysis dataset with the variables gender, age, attitude, deep, stra, surf and points
# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the stucture of the new dataset
str(learning2014)

# change the name of the second column
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014) [7] <- "points"

# print out the new column names of the data
colnames(learning2014)


#Excluding observations where the exam points variable is zero
summary(learning2014)
learning2014 <- filter(learning2014, points > 0)


#Exploring the dimensions and structure of the data
dim(learning2014)
str(learning2014)

#The new dataset learning2014 has 166 observations and 7 variables.

#Set the working directory of the R session to the IODS project folder
setwd("~/IODS-project")

#Save the analysis dataset to the 'data' folder
?write.csv

write.csv(learning2014, file = "~/IODS-project/data/learning2014.csv")

#Demonstrate that you can also read the data again.
readtest = read.csv("~/IODS-project/data/learning2014.csv", header = TRUE, row.names = 1)

#Make sure that the structure of the data is correct.
str(readtest)
str(learning2014)

head(readtest)
head(learning2014)

#The results are equal!

