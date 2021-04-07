#setwd('../desktop/study/getting_cleaning_data')

# here is the data we work with
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# create a folder for this project
if (!file.exists("project_data")) {
  dir.create("project_data")
}

# download required .zip file if it was not done before
if (length(list.files("./project_data")) == 0) {
  dest <- "./project_data/dataset.zip"
  download.file(zipURL, dest)
}

# let's move into this folder, shall we?
setwd('./project_data')

# unpack .zip file if it is not unpacked yet
if (length(list.dirs(".", recursive=F)) == 0) {
  unzip("dataset.zip")
}

# let's look what we got there
for (val in list.dirs('.')) {
  print(val)
  print(list.files(val))
  print("-----")
}

# this function helps with reading X datasets into a nice data frame
# it replaces unwanted whitespaces so that the remaining ones could be used as separators
pre_parse <- function(x) {
  x <- gsub("(^|\n) +", "\n", x)
  x <- gsub("  ", ' ', x)
  return(x)
}

# reading all required datasets: X, y and subject
fileName <- './UCI HAR Dataset/test/X_test.txt'
X_test <- read.csv(text=pre_parse(readChar(fileName, file.info(fileName)$size)), sep=" ", header=F)
fileName <- './UCI HAR Dataset/train/X_train.txt'
X_train <- read.csv(text=pre_parse(readChar(fileName, file.info(fileName)$size)), sep=" ", header=F)

fileName <- "./UCI HAR Dataset/train/y_train.txt"
y_train <- read.csv(fileName, header=F)
fileName <- "./UCI HAR Dataset/test/y_test.txt"
y_test <- read.csv(fileName, header=F)

fileName <- "./UCI HAR Dataset/train/subject_train.txt"
s_train <- read.csv(fileName, header = F)
fileName <- "./UCI HAR Dataset/test/subject_test.txt"
s_test <- read.csv(fileName, header=F)

# adding y to X
X_test$activity_num <- y_test$V1
X_train$activity_num <- y_train$V1

# adding subject to X
X_test$Subject <- s_test$V1
X_train$Subject <- s_train$V1

# merging test and train datasets
df <- rbind(X_test, X_train)

# reading features that will become columnnames
fileName <- './UCI HAR Dataset/features.txt'
df_features <- read.csv(fileName, sep=" ", header=F)
#head(df_features)

# this will help to label activities properly
fileName <- "./UCI HAR Dataset/activity_labels.txt"
act_labels <- read.csv(fileName, sep=' ', header=F)
#act_labels

# labling activities
df$activity_label <- act_labels$V2[match(df$activity_num, act_labels$V1)]

# columnnames for X part of dataset
colnames(df)[1:561] = as.character(df_features[,2])
#colnames(df)

# extract only ... mean and standard deviation
needed_ixs <- grep("-(std|mean)[^A-Za-z]", colnames(df))
df_stdAndMean <- df[,needed_ixs]
# if you need to print this dataset from task 2:
df_stdAndMean

# make required tidy data set
df_stdAndMean$Subject <- df$Subject
df_stdAndMean$Activity <- df$activity_label
library(reshape2)
df_melted <- melt(df_stdAndMean, id = c("Subject", "Activity"))
df_tidy <- dcast(df_melted, Subject + Activity ~ variable, mean)
df_tidy

# write this tidy dataset into a .txt file
write.table(df_tidy, "./average_subject_activity_dataset.txt", row.names = FALSE, quote = FALSE)