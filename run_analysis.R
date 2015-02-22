#setwd('C:/li/online/gettingandcleaningdata')

# download file
url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url,destfile="project.zip")

# unzip
unzip(zipfile="project.zip")

# view files

files = list.files("UCI HAR Dataset", recursive=TRUE)
files

subject_test = read.table('UCI HAR Dataset/test/subject_test.txt')
subject_train = read.table('UCI HAR Dataset/train/subject_train.txt')

y_test = read.table('UCI HAR Dataset/test/y_test.txt')
y_train = read.table('UCI HAR Dataset/train/y_train.txt')

x_test = read.table('UCI HAR Dataset/test/x_test.txt')
x_train = read.table('UCI HAR Dataset/train/x_train.txt')

features = read.table('UCI HAR Dataset/features.txt')

head(subject_test)
head(subject_train)
head(y_test)
head(y_train)
head(x_test)
head(x_train)
head(x_test)
head(features)

# 1. merge training and testing datasets

subject = rbind(subject_test, subject_train)
y = rbind(y_test, y_train)
x = rbind(x_test, x_train)

names(subject) = 'subject'
names(y) = 'activityid'
names(x) = features$V2

all = cbind(subject, y, x)

all[1:5, 1:10]

# 2. Extract data only on mearement of mean and SD

sub_all = all[, grep(pattern = 'subject|activity|mean()|std()', colnames(all))]
str(sub_all)

# 3. Uses descriptive activity names to name the activities in the data set

activity_labels = read.table('UCI HAR Dataset/activity_labels.txt', col.name = c('activityid', 'activity'))
activity_labels

data = merge(sub_all, activity_labels)
data = data[,-1]
head(data)
names(data)


# 4. Appropriately labels the data set with descriptive variable names.

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub

names(data)

# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

library(plyr)
data2 = aggregate(. ~subject + activity, data = data, mean)
data2
write.table(data2, file = "tidydata.txt",row.name=FALSE)
