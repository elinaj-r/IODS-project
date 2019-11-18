# Elina Järvelä-Reijonen
# 18.11.2019
# R script for exercise 3, data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Reading and exploring the data student-mat
math <- read.csv("~/IODS-project/data/student-mat.csv", sep = ";" , header = TRUE)

dim(math)
str(math)
colnames(math)

# There are 395 observations and 33 variables in the math-data.

# Reading and exploring the data student-por
por <- read.csv("~/IODS-project/data/student-por.csv", sep = ";" , header = TRUE)

dim(por)
str(por)
colnames(por)

# There are 649 observations and 33 variables in the math-data.
# Both datasets include the same variables in the same order.

# access the dplyr library
library(dplyr)

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# see the new column names
colnames(math_por)

# glimpse at the data
glimpse(math_por)

# This dataset includes 382 observations and 53 variables.

# Let's combine the 'duplicated' answers in the joined data.
# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Taking a glimpse at the new combined data
glimpse(alc)

# Now there are 382 observations and 33 variables. 

# Taking the average of the answers related to weekday and weekend alcohol consumption
# access the 'tidyverse' packages dplyr and ggplot2
library(dplyr); library(ggplot2)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

# The joined data "alc" includes 382 observations and 35 variables. Same as in the instructions!

write.csv(alc, file = "~/IODS-project/data/alc.csv")

