#Course Project

#Poject Task

#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



#Change working directory to where the script and data are
setwd('C:/Users/diablo/Desktop/Coursera/Getting_and_Cleaning_Data_Course_Project')

# load in the necessary libraries
library(reshape)
library(plyr)
library(gsubfn)

#Read in the data

# reading in headings from file
featNames <- read.table("./Data/features.txt")
headings <- featNames$V2


#Reading the training data
xTrain <- read.table("./Data/train/X_train.txt")
yTrain <- read.table("./Data/train/y_train.txt")
subjectTrain <- read.table("./Data/train/subject_train.txt")

#Reading the testing data
xTest <- read.table("./Data/test/X_test.txt")
yTest <- read.table("./Data/test/y_test.txt")
subjectTest <- read.table("./Data/test/subject_test.txt")


# Add in the headings to the datasets
colnames(xTrain) <- headings
colnames(xTest) <- headings

# Give V1 variable a descriptive name called  "activity"
yTest <- rename(yTest, c(V1="activity"))
yTrain <- rename(yTrain, c(V1="activity"))

# Map data values in yTest to labels in the activity label file

activityDataLbl <- read.table("./Data/activity_labels.txt")
# change variable names to lowercase
activityLbl <- tolower(levels(activityDataLbl$V2))
# change $activity to factor and add descriptive labels
yTrain$activity <- factor(
  yTrain$activity,
  labels  = activityLbl
)
yTest$activity <- factor(
  yTest$activity,
  labels  = activityLbl
)

# rename the first variable in the subjectTrain and test data
subjectTrain <- rename(subjectTrain, c(V1="subjectid"))
subjectTest <- rename(subjectTest, c(V1="subjectid"))

## Create a complete training and the test sets (observations,subjects,labels).
trainSet <- cbind(xTrain, subjectTrain, yTrain)
testSet <- cbind(xTest, subjectTest, yTest)
# combine train and test set
fullData <- rbind(trainSet, testSet)


# keep only measurements on the mean and standard deviation for each measurement.
# keep the activity column as well
pattern <- "mean|std|subjectid|activity"
tidyData <- fullData[,grep(pattern , names(fullData), value=TRUE)]

# write file to output
write.table(tidyData, file="tidydata.txt", sep = "\t", append=F)

# remove parentheses, dash, commas
cleanNames <- gsub("\\(|\\)|-|,", "", names(tidyData))
names(tidyData) <- tolower(cleanNames)

# summarize data
result <- ddply(tidyData, .(activity, subjectid), numcolwise(mean))

# write file to output
write.table(result, file="new_data.txt", sep = "\t", append=F)
