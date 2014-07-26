# Project for Data Science 3. Getting Data
# Copyright 2014, Weiyu Huang. All rights reserved. No part of this publication
# may be reproduced or transmitted in any form or by any means, electronic or 
# mechanical, including photocopy, recording, or any information storage and 
# retrieval system, without permission in writing from the author.
#

setwd("/Users/weiyuhuang/Documents/Courses/DataScience/3-GetData/project")

## 1. Merges the training set

# 1.1 Read data
if(!file.exists("data")) {dir.create("data")}
x.test <- read.table("./data/test/X_test.txt", sep = "")
y.test <- read.table("./data/test/y_test.txt", sep = "")
subject.test <- read.table("./data/test/subject_test.txt", sep = "")
x.train <- read.table("./data/train/X_train.txt", sep = "")
y.train <- read.table("./data/train/y_train.txt", sep = "")
subject.train <- read.table("./data/train/subject_train.txt", sep = "")

# 1.2 Add column names
feature <- read.table("./data/features.txt", sep = "")
feature <- feature[, 2]
colnames(x.test) <- feature
colnames(x.train) <- feature
colnames(y.test) <- "activity"
colnames(y.train) <- "activity"
colnames(subject.test) <- "subject"
colnames(subject.train) <- "subject"

# 1.3 cbind to create full test and train data
test <- cbind(x.test, y.test, subject.test)
train <- cbind(x.train, y.train, subject.train)

# 1.4 rbind to merge the training and testing data
data <- rbind(test, train)

## 2. Extract mean and std info

# 2.1 Find names of interest
names.interest <- grep("[Mm]ean\\(\\)|std\\(\\)", feature)

# 2.2 Extract names of interest (keep acticity and subject)
data.interest <- data[, c(names.interest, 562, 563)]

## 3. Descriptive activity names

activity <- read.table("./data/activity_labels.txt", sep = "")
activity <- activity[ ,2]
data.interest$activity <- factor(data.interest$activity, 
                levels = 1:6, labels = activity)

## 4. Descriptive variable names

variable.names <- names(data.interest)

# 4.0 Handle repetitive Body
variable.names <- sub("(Body){1,}", "Body", variable.names)

# 4.1 Handle time and frequency
variable.names <- sub("^t", "time domain - ", variable.names)
variable.names <- sub("^f", "frequency domain - ", variable.names)

# 4.2 Handle body, acc, gyro, etc
variable.names <- sub("BodyAccJerk", "Jerk of body acceleration - ", variable.names)
variable.names <- sub("BodyAcc", "body acceleration - ", variable.names)
variable.names <- sub("GravityAcc", "gravity acceleration - ", variable.names)
variable.names <- sub("BodyGyroJerk", "Jerk of body gyroscope - ", variable.names)
variable.names <- sub("BodyGyro", "body gyroscope - ", variable.names)

# 4.3 Change the order of Mag-mean() and Mag-std()
variable.names <- sub("Mag-mean\\(\\)$", "-mean\\(\\)-Mag", variable.names)
variable.names <- sub("Mag-std\\(\\)$", "-std\\(\\)-Mag", variable.names)

# 4.4 Handle Mag, X, Y, Z
variable.names <- sub("Mag", "magnitude in Euclidean space", variable.names)
variable.names <- sub("X", "on the X axis of the phone", variable.names)
variable.names <- sub("Y", "on the Y axis of the phone", variable.names)
variable.names <- sub("Z", "on the Z axis of the phone", variable.names)

# 4.5 Handle -mean(), -std()
variable.names <- sub("-mean\\(\\)-", "Mean value - ", variable.names)
variable.names <- sub("-std\\(\\)-", "Standard deviation - ", variable.names)

# 4.6 Set variable names
names(data.interest) <- variable.names

## 5. Create a new dataset with averaging mean, averating std

# 5.1 create a new variable subject_activity
data.interest$sub_act <- paste(data.interest$subject, data.interest$activity, sep="_")
data.interest$subject <- NULL
data.interest$activity <- NULL

# 5.2 Melt and cast
library(reshape)
mdata <- melt(data.interest, id=c("sub_act"), mea.vars = variable.names[1:66])
sub_act.means <- cast(mdata, sub_act~variable, mean)

# 5.3 Split sub_act
sub_act.means$subject <- sapply(strsplit(as.character(sub_act.means$sub_act), "_"), "[", 1)
sub_act.means$activity <- sapply(strsplit(as.character(sub_act.means$sub_act), "_"), "[", 2)
sub_act.means$sub_act <- NULL
sub_act.means <- sub_act.means[, c(67, 68, 1:66)]

# 5.4 Save data
if(!file.exists("processed_data")) {dir.create("processed_data")}
write.table(sub_act.means, file = "./processed_data/output.txt", row.names = FALSE, sep = " ")

