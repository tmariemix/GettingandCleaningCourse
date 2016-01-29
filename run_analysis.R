####Coursera Getting and Cleaning Data 
##Final Course Assigment

##check working directory
getwd()
##set new one
setwd("/Users/taylormickelson/Desktop/Coursera/UCI HAR Dataset/test")
##check it agin 
getwd()
list.files()

##call the curl package 
library(curl)
library(reshape2)

##1. Download the Data
##This is data on the accelerometers for Samsung Galaxy smartphone
##Bring in the Test Data
subject_test = read.table("subject_test.txt")
##check it out
View(subject_test)
X_test = read.table("X_test.txt")
Y_test = read.table("Y_test.txt")

##Bring in The Training Data
setwd("/Users/taylormickelson/Desktop/Coursera/UCI HAR Dataset/train")
subject_train = read.table("subject_train.txt")
##check it out
View(subject_train)
X_train = read.table("X_train.txt")
View(X_train)
Y_train = read.table("Y_train.txt")
View(Y_train)


##Bring in Lookup Info
setwd("/Users/taylormickelson/Desktop/Coursera/UCI HAR Dataset")
features <- read.table("features.txt", col.names=c("featureId", "featureLabel"))
activities <- read.table("activity_labels.txt", col.names=c("activityId", "activityLabel"))
activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)

##Merge Test and Training Together
subject <- rbind(subject_test, subject_train)
##names the column 'SubjectID'
names(subject) <- "subjectId"
##merge together X test and X train
X <- rbind(X_test, X_train)
X <- X[, includedFeatures]
names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
##merge togther Y test and Y train 
Y <- rbind(Y_test, Y_train)
##names it 'activityid"
names(Y) = "activityId"
activity <- merge(Y, activities, by="activityId")$activityLabel

# merge data frames of different columns to form one data table
data <- cbind(subject, X, activity)
##export the tidy dataset
write.table(data, "merged_tidy_data.txt")

##calculations 
library(data.table)
dataDT <- data.table(data)
calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
write.table(calculatedData, "calculated_tidy_data.txt")




