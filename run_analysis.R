#setwd("E:\\Coursera\\Coursera1\\Getting_cleaning_data")
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","source.zip")
#unzip("source.zip")

#0 Read source data.
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt")
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt")
features <- read.table("UCI HAR Dataset\\features.txt")
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt")

#1 Merge the training and the test sets to create one data set.
test <- cbind(subject_test,y_test,X_test)
train <- cbind(subject_train,y_train,X_train)
dataset <- rbind(test,train)
names(dataset)[1] <- 'Subject'
names(dataset)[2] <- 'Activity'

#2 Extract only the measurements on the mean and standard deviation for each measurement. 
features$Selected <- FALSE
features$Selected[features$V2 %like% 'mean' | features$V2 %like% 'std'] <- TRUE
dataset <- dataset[,cbind(TRUE,TRUE,t(features$Selected))]

#3 Use descriptive activity names to name the activities in the data set.
dataset$Activity <- with(activity_labels, V2[match(dataset$Activity, V1),drop=F])

#4 Appropriately label the data set with descriptive variable names. 
names(dataset)[-c(1,2)] <- t(as.character(features$V2[features$Selected]))

#5 From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- aggregate(x=dataset[,3:81],by=dataset[,1:2],FUN="mean")
write.table(tidy_dataset,"tidy_dataset.txt",row.name=FALSE)