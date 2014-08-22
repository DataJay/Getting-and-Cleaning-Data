## Coursera Data Scientist
## Course 3: Getting and Cleaning Data
## Course Project
## R version 3.1.0 (2014-04-10)
## R Studio version Version 0.98.507
## Running on Windows 7, 64
## August 24 2014

## Instructions
## You should create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject

##  Manually download the data into the working directory
## PLEASE NOTE: The working directory must contain the unzipped data, with it's original file structure intact.

## Step 1:  
############################################################
############################################################
## Merges the training and the test sets to create one data set.

## Switch WD to where the test files are.
## PLEASE NOTE: The working directory must contain the unzipped data, with it's original file structure intact.
setwd("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test")

## Read in data
x_test <- read.table("x_test.txt")  ## These are the actual gyro data readouts

y_test <- read.table("y_test.txt")  ## these are the activity number IDs.

subject_test <- read.table("subject_test.txt")  ## these are the subject_IDs.

##Move one level up in the original file structure
setwd("..")

## Grab all column names.  
features <- read.table("features.txt")

## Set the column names to the x_test
colnames(x_test)  <- features[,2]

##Read in activity labels
activity_labels <-  read.table("activity_labels.txt")

## attach the y_test and subject_test
test1<- cbind(subject_test, y_test, x_test)

##name the first two columns
names(test1)[1]  <- "Subject_ID"
names(test1)[2]  <- "Activity_ID"

## Merge Activity labels 
test2 <- merge(activity_labels, test1, by.x = "V1", by.y = "Activity_ID", all=TRUE ) 

## Label the new columns from the merge
names(test2)[1]  <- "Activity_ID"
names(test2)[2]  <- "Activity_label"

## cleanup
rm(x_test)
rm(y_test)
rm(subject_test)
rm(test1)



############################################################
## TRAIN
## Switch WD to where the train files are.
setwd("train")
 
## Read in data
x_train <- read.table("x_train.txt")  ## These are the actual gyro data readouts

y_train <- read.table("y_train.txt")  ## these are the activity number IDs

subject_train <- read.table("subject_train.txt")  ## these are the subject_IDs.

## Set the column names to the x_train
colnames(x_train)  <- features[,2]

## attach the y_train and subject_train
train1<- cbind(subject_train, y_train, x_train)

##name the first two columns
names(train1)[1]  <- "Subject_ID"
names(train1)[2]  <- "Activity_ID"

## Merge the Activity labels
train2 <- merge(activity_labels, train1, by.x = "V1", by.y = "Activity_ID", all=TRUE ) ## so far this seems to work.

## Label the new columns from the merge
names(train2)[1]  <- "Activity_ID"
names(train2)[2]  <- "Activity_label"

## Cleanup
rm(x_train)
rm(y_train)
rm(subject_train)
rm(train1)
rm(activity_labels)
rm(features)

## Bind them together into one large dataset
Complete <- rbind(test2,train2)

##Step 2
############################################################
############################################################
## Extracts only the measurements on the mean and standard deviation for each measurement. 

## Get column indexs for those that meet requirments
x <- c(1, 2, 3,grep("mean", colnames(Complete)), grep("std", colnames(Complete)))

## Subset data with only desired column names
subsetData<- Complete[ ,c(x,grep("mean", colnames(Complete)), grep("std", colnames(Complete))) ] 

##cleanup
rm(x)

############################################################
############################################################
## STEP 3: Uses descriptive activity names to name the activities in the data set
## Already did this above.

############################################################
############################################################
## STEP 4: Appropriately labels the data set with descriptive variable names. 
## Already did this above.

############################################################
############################################################
## STEP 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject
## Aggregte the data on the Activity and Subject
Tidy <- aggregate(subsetData[,4:161], by=list(subsetData$Activity_label,subsetData$Subject_ID), FUN = mean)
## Label the new columns from the aggregate
names(Tidy)[1]  <- "Activity_label"
names(Tidy)[2]  <- "Subject_ID"


##Please upload the tidy data set created in step 5 of the instructions. 
##Please upload your data set as a txt file created with write.table() using row.name=FALSE 
##(do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).
## Back out 3 levels to original working directory
setwd("..")  
setwd("..")
setwd("..")
## Create a text file in the original working directory.
write.table(Tidy, "TidyData.txt", sep="\t", row.name=FALSE)

##cleanup
rm(test2)
rm(train2)
rm(subsetData)
rm(Complete)
