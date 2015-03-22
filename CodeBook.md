---
title: "CodeBook.md"
author: "Michael Bailey"
date: "Sunday, March 22, 2015"
output: html_document
---

Getting and Cleaning Data Project

This code book describes the variables, the data, and transformations performed to clean up the data for the Coursera Getting and Cleaning Data course project.    

Motivation
Using data from the Human Activity Recognition Using Smartphones Data Set, we were to merge the seperate data files that made up the training and test data into one source, including the additional columns for "Subject" and "Activity".  With this merged data set we were to perform a subset of the columns and then proivde a tidy data set.  

Source Project
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


Source Data
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


Required libraries 
```{r}
library(data.table)
library(plyr)
```

Merges the training and the test sets to create one data set.

Utilizing the data.table function to load each of the data elements for the training and test data sets and simply used rbind to append the to major data sets.  

```{r}
DT <- rbind(DTtrain,DTtest)
```

Using the features.txt data we could assign labels to each column of the the data set.  

```{r}
setnames(DT,as.character(DTfeatures[,V2]))
```

Using the data.table features appended the additional column data for both subjects and activitys to the data set.  

```{r}
DT[,subject:=subject], DT[,activity:=activity]
```

Extracts only the measurements on the mean and standard deviation for each measurement. 

```{r}
Data <- subset(DT,select=subsetCols)
```

Uses descriptive activity names to name the activities in the data set

```{r}
Data[,activity:=DTactivity[activity,2,with=FALSE]]
```

Appropriately labels the data set with descriptive variable names. 

```{r}
setnames(Data,grep("^t",names(Data)),gsub("^t","time" ,names(Data)[grep("^t",names(Data))]))  # Replace Time
```

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


```{r}
Data1 <- data.table(aggregate(. ~subject + activity, Data, mean))
```

```{r}
setorder(Data1,subject,activity)
```


Source:

Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws
