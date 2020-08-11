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

##2
features<-read.table("./UCI HAR Dataset/features.txt")
measurement<-grep("mean\\(\\)|std\\(\\)",features$V2)
data1<-mergdata[,c(measurement,ncol(mergdata)-1,ncol(mergdata))]
names(data1[,ncol(data1)-1])
colnames(data1) <- c(features[measurement,2],"activity","subject")

##3
activitylabels<-read.table("./UCI HAR Dataset/activity_labels.txt")
data1$V <- factor(data1$activity, levels = activitylabels[,1], labels = activitylabels[,2])

##4
names(data1)<-gsub("\\(\\)","",names(data1))

##5
library(dplyr)
data2 <- data1 %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))
write.table(data2, "TidyData.txt", row.names = FALSE)
