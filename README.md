##1 merges the training and the test sets to create one data set.
First read the txt files from the computer. Then use the functions cbind and rbind to merge the txt files together.

```{r}
##1
library(stringr)
test_x<-read.table("./UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
train_x<-read.table("./UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
mergetest<-cbind(test_x,test_y,test_subject)
mergetrain<-cbind(train_x,train_y,train_subject)
mergdata<-rbind(mergetest,mergetrain)
```

##2 Extracts only the measurements on the mean and standard deviation for each measurement. 
First read the txt files, then use function grep to extract the features that meet the requirements. Then subset original data and allocate the result to data1. Finally, rename the variable names of data1.
```{r}
##2
features<-read.table("./UCI HAR Dataset/features.txt")
measurement<-grep("mean\\(\\)|std\\(\\)",features$V2)
data1<-mergdata[,c(measurement,ncol(mergdata)-1,ncol(mergdata))]
names(data1[,ncol(data1)-1])
colnames(data1) <- c(features[measurement,2],"activity","subject")

```

##3 Uses descriptive activity names to name the activities in the data set. 
First read the txt file, then use factor function to change the content of activity.
```{r}
##3
activitylabels<-read.table("./UCI HAR Dataset/activity_labels.txt")
data1$activity <- factor(data1$activity, levels = activitylabels[,1], labels = activitylabels[,2])

```

##4 Appropriately labels the data set with descriptive variable names. 
As I have already change the colnames in step 2, the variable names now are pretty tidy, so I just remove the () from the names of the variables to make them looks better.
```{r}
##4
names(data1)<-gsub("\\(\\)","",names(data1))

```

##5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
First I group the data2 by subject and activity, then I use the function summarise to form a new data set which includes the average of each variable. Finally, I write the data set into a txt file.
```{r}
library(dplyr)
data2 <- data1 %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))
write.table(data2, "TidyData.txt", row.names = FALSE)

```


