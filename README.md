Human Activity Recognition Using Smartphones - tidy dataset project
========================================================
Bartosz Janeczek

Getting and Cleaning Data - Course Project
## Data
Data produced here comes from ["Human Activity Recognition Using Smartphones Dataset"](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Script
Whole R script is built in one file: run_analysis.R. Id downloads data, reads it, combine files to one dataset. Then it replaces numerical IDs with more descriptive values/names and finally aggregates data to calculate means for each variable for every Subject/Activity combination. More details:

### Download data
Download data from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
```r
setwd("E:\\Coursera\\Coursera1\\Getting_cleaning_data")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","source.zip")
unzip("source.zip")
```

### Read source data.
Use simple read.table function to read source datasets.
```r
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt")
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt")
features <- read.table("UCI HAR Dataset\\features.txt")
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt")
```

### Merge the training and the test sets to create one data set.
Merge features (X), subject and activities (y) data to one dataset for test data, the same for traind data and then combine them together to build one dataset (row bind / union all).
```r
test <- cbind(subject_test,y_test,X_test)
train <- cbind(subject_train,y_train,X_train)
dataset <- rbind(test,train)
names(dataset)[1] <- 'Subject'
names(dataset)[2] <- 'Activity'
```

### Extract only the measurements on the mean and standard deviation for each measurement. 
Create logical variable "Selected" and give it TRUE value for features whose names include "mean" or "std" (mean / standard deviations) - FALSE for all other features. Feature names comes from the "features" dataset.
```r
features$Selected <- FALSE
features$Selected[features$V2 %like% 'mean' | features$V2 %like% 'std'] <- TRUE
dataset <- dataset[,cbind(TRUE,TRUE,t(features$Selected))]
```

### Use descriptive activity names to name the activities in the data set.
Replace numerical Activity IDs with their descriptive values (from activity_labels dictionary).
```r
dataset$Activity <- with(activity_labels, V2[match(dataset$Activity, V1),drop=F])
```

### Appropriately label the data set with descriptive variable names. 
Replace original column names with names of the features (from the features dictionary).
```r
names(dataset)[-c(1,2)] <- t(as.character(features$V2[features$Selected]))
```

### Create independent tidy data set with the average of each variable for each activity and each subject.
Aggregate data (calculate mean value) of all features (columns 3-81), for all Subject / Activity combination and save tidy (wide form) dataset.  
```r
tidy_dataset <- aggregate(x=dataset[,3:81],by=dataset[,1:2],FUN="mean")
write.table(tidy_dataset,"tidy_dataset.txt",row.name=FALSE)
```