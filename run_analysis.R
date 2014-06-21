
# This code reads the training and testing data collected from Samsumg smartphone,
# and creates a tidy data set

# Read and merge the feature values in training and testing set
xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
x <- rbind(xtrain,xtest)

# Read the names of features and identify mean and standard deviation measures
feature_names <- read.table('./UCI HAR Dataset/features.txt')
l_idx <- (grepl("[Mm][Ee][Aa][Nn]\\(\\)", feature_names$V2)
                | grepl("[Ss][Tt][Dd]\\(\\)", feature_names$V2))

# Subset the feature data to include only the mean and standard deviation measures
x_subset <- x[,l_idx]

# Name the features (columns) appropriately
feature_subset <- feature_names$V2[l_idx]
colnames(x_subset) <- feature_subset

# Read and merge the activity labels in training and testing set
ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
y <- rbind(ytrain,ytest)

# Read the activity names corresponding to each label
activity_names <- read.table('./UCI HAR Dataset/activity_labels.txt')

# Change the activity labels to descriptive activity names
factor_y <- as.factor(y$V1)
levels(factor_y) <- activity_names[,2]

# Read and merge the subject labels in training and testing set
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subject <- rbind(subject_train,subject_test)

# Change the subject as factors
factor_subject <- as.factor(subject$V1)

# Create a data set with subject identifier, activity identifier, and features
data <- data.frame(Subject = factor_subject, Activity = factor_y, x_subset)

# Create a tidy data set with average of each variable for each activity and
# each subject
meltData <- melt(data, id = c("Subject","Activity"))
tidyData <- dcast(meltData, Subject + Activity ~ variable, mean)

# Write the tidy data into a .txt file
write.table(tidyData, file = "TidyDataSet.txt", sep=",")