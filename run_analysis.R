##Peer-graded Assignment: Getting and Cleaning Data Course Project

#1.Merges the training and the test sets to create one data set called: X_total, Y_total

X_test=read.table("./test/X_test.txt")
X_train=read.table("./train/X_train.txt")
X_total<-rbind(X_train, X_test)

Y_test=read.table("./test/Y_test.txt", col.names= c("activity"))
Y_train=read.table("./train/Y_train.txt", col.names= c("activity"))
subject_test=read.table("./test/subject_test.txt", col.names= c("subject"))
subject_train=read.table("./train/subject_train.txt", col.names= c("subject"))
Y_total<-rbind(Y_train, Y_test)
subject_total<-rbind(subject_train, subject_test)

#Here for tests
#X_total<-as.data.frame(X_total[0:50,])
#Y_total<-as.data.frame(Y_total[0:50,])
#subject_total<-as.data.frame(subject_total[0:50,])

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#features<-read.csv("./features.txt", colClasses="character",header = FALSE, col.names= c("id","label"))
features<-read.table("./features.txt", col.names= c("id","label"))
indexes <- grep("*-(mean|std)\\(\\)*",features$label)
extracted <- X_total[,indexes]

#3.Uses descriptive activity names to name the activities in the data set

#defining activities attributes
activities <- read.table("./activity_labels.txt", col.names=c("activity", "label"))
names(Y_total) <- "activity"
Y_total <- merge(Y_total,activities)

#4.Appropriately labels the data set with descriptive variable names.

#defining new attributes
labelnames <- features$label[indexes]
labelnames <-gsub("-mean\\(\\)","Mean", labelnames)
labelnames <-gsub("-std\\(\\)","Std", labelnames)
names(X_total) <- labelnames 

#defining subject
names(subject_total) <- "subject"
new_total <- cbind(Y_total,subject_total,X_total)

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData <- aggregate(. ~subject + activity, new_total, mean)

# final output
write.table(tidyData, "tidy_data.txt",row.name=FALSE)

