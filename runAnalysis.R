#Reading from files

#Train folders
trainingData = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)

trainingData[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)

trainingData[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

head(trainingData)

#Test Folders
testingData = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)

testingData[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)

testingData[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

head(testingData)

#ActivitiesLAbles
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read featureData
featureData = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

featureData[,2] = gsub('-mean', 'Mean', featureData[,2])

featureData[,2] = gsub('-std', 'Std', featureData[,2])

featureData[,2] = gsub('[-()]', '', featureData[,2])

# Merge training data and test data sets together
joinData = rbind(trainingData, testingData)

# data on mean and std. dev.
colsNeeded <- grep(".*Mean.*|.*Std.*", features[,2])

# 4 steps to get data

# 1. reduce the features table to what we want
features <- features[colsNeeded,]

# 2. add the last two columns (subject and activity)
colsNeeded <- c(colsNeeded, 562, 563)

# 3. remove the unwanted columns from allData
allData <- allData[,colsNeeded]

# 4. Add the column names (features) to allData
colnames(allData) <- c(features$V2, "Activity", "Subject")
colnames(allData) <- tolower(colnames(allData))


#Processing.
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}
allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)

tidy = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean)

write.table(tidy, "tidy.txt", sep="\t", row.name = FALSE)

