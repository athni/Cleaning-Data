#Read the values in the activity_labels and features and store into 2 datasets
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")


#The above tables have 2 columns, 2nd one is changed to have characters
actLabels[,2] <- as.character(actLabels[,2])
features[,2] <- as.character(features[,2])

#Extracting only the mean and standard deviation for each measurement
featuresreq <- grep(".*mean.*|.*std.*", features[,2])
featuresreq.names <- features[featuresreq,2]
featuresreq.names = gsub('-mean', 'Mean', featuresreq.names)
featuresreq.names = gsub('-std', 'Std', featuresreq.names)
featuresreq.names <- gsub('[-()]', '', featuresreq.names)

#Load the train and test datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresreq]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresreq]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#Merge datasets and set names
maindata <- rbind(train,test)
colnames(maindata) <- c("subject", "activity", featuresreq.names)

#change activites and subjects to factors
maindata$activity <- factor(maindata$activity, levels = actLabels[,1], labels = actLabels[,2])
maindata$subject <- as.factor(maindata$subject)

maindata.melted <- melt(maindata, id = c("subject", "activity"))
maindata.mean <- dcast(maindata.melted, subject + activity ~ variable, mean)

write.table(maindata.mean, "tidy.txt", row.names = FALSE, quote=FALSE)
