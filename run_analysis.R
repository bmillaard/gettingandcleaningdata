



# Reading training tables:
x_train <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\train\\y_train.txt")
subject_train <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\train\\subject_train.txt")

# Reading test tables
x_test <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\test\\subject_test.txt")

# Read features and activities

features <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\features.txt")
  activities <- read.table("C:\\Users\\BZM11\\Documents\\R\\R programming\\Capstone cleaning data\\UCI HAR Dataset\\activity_labels.txt")
  colnames(activities) <- c('activityId','activityType')

 





## Step 1 Merges the training and the test sets to create one data set.


# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

## Assigning columnnames 
names(subject_data) <- c('subject')
names(y_data) <- c('activity')
names(x_data) <- features$V2


# create all data set
combine <- cbind(subject_data, y_data)
allData <- cbind(combine, x_data)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

#subset name of features by measurements on the mean

subfeatures <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

selectedNames<-c(as.character(subfeatures), "subject", "activity" )
allData<-subset(allData, select = selectedNames)

str(allData)
## 3. Uses descriptive activity names to name the activities in the data set

allData$activities <-factor(allData$activity,labels=activities[,2])

head(allData$activities)


## 4. Appropriately labels the data set with descriptive variable names.

names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))
names(allData)<-gsub("BodyBody", "Body", names(allData))
## Test Print
names(allData)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
newData<-aggregate(. ~subject + activities, allData, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')
