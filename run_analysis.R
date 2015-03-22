#run_analysis.R

# When executed from the "UCI HAR Dataset" folder the following script will 
# clean the raw data provided and created 
# a tidy data set per the specifications of the project.  


library(data.table)
library(plyr)

# Load Features and Activity data tables
DTfeatures <- data.table(read.table("features.txt"))
DTactivity <- data.table(read.table("activity_labels.txt"))

# Load data sets
DTtrain <- data.table(read.table("train/X_train.txt"))
DTtest <- data.table(read.table("test/X_test.txt"))

# Load activity 
activity_train <- data.table(read.table("train/y_train.txt")) 
activity_test  <- data.table(read.table("test/y_test.txt"))  

# Load subject
subject_train <- data.table(read.table("train/subject_train.txt")) 
subject_test  <- data.table(read.table("test/subject_test.txt")) 

## 1. Append train and test data
# Append data sets
DT <- rbind(DTtrain,DTtest)

# Append activity
activity <- rbind(activity_train,activity_test)


# Append subject
subject <- rbind(subject_train,subject_test)

## Construct tidy data set 
#Label DT, activity and subject 
setnames(DT,as.character(DTfeatures[,V2]))


# merge subject column
DT[,subject:=subject]

# merge activity column
DT[,activity:=activity]

## 2. Extracts only the measurements on the mean and standard deviation 
##      for each measurement. 
# Identify mean and std columns
subsetCols <- c(as.character(DTfeatures$V2[
        grep("mean\\(|std\\(",DTfeatures$V2)]),"subject",
                "activity")

# Subset data for specified columns
Data <- subset(DT,select=subsetCols)


## 3. Uses descriptive activity names to name the activities in the data set
Data[,activity:=DTactivity[activity,2,with=FALSE]]

## 4. Appropriately labels the data set with descriptive variable names. 
setnames(Data,grep("^t",names(Data)),
         gsub("^t","time" ,names(Data)[grep("^t",names(Data))]))  # Replace Time
setnames(Data,grep("^f",names(Data)),
         gsub("^f","frequency" ,names(Data)[grep("^f",names(Data))]))  # Replace Freq
setnames(Data,grep("Acc",names(Data)),
         gsub("Acc","Accelerometer" ,names(Data)[grep("Acc",names(Data))]))  # Replace Acc
setnames(Data,grep("Gyro",names(Data)),
         gsub("Gyro","Gyroscope" ,names(Data)[grep("Gyro",names(Data))]))  # Replace Gyro
setnames(Data,grep("Mag",names(Data)),
         gsub("Mag","Magnitude" ,names(Data)[grep("Mag",names(Data))]))  # Replace Mag
setnames(Data,grep("BodyBody",names(Data)),
         gsub("BodyBody","Body" ,names(Data)[grep("BodyBody",names(Data))]))  # Replace Body

## 5. From the data set in step 4, creates a second, 
##    independent tidy data set with the average of each variable for each activity and each subject.

Data1 <- data.table(aggregate(. ~subject + activity, Data, mean))
setorder(Data1,subject,activity)


