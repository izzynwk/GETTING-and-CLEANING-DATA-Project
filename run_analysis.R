# This script does the following:

# 1. Reads in the files then merges the training and the test sets to create one data set.

temp1 <- read.table("X_train.txt")
temp2 <- read.table("X_test.txt")
X <- rbind(temp1, temp2)

temp1 <- read.table("subject_train.txt")
temp2 <- read.table("subject_test.txt")
S <- rbind(temp1, temp2)

temp1 <- read.table("y_train.txt")
temp2 <- read.table("y_test.txt")
Y <- rbind(temp1, temp2)

# 2. Extracts only the measurements on the mean and standard deviation.

features <- read.table("features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, indices_of_good_features]
flag(X) <- features[indices_of_good_features, 2]
flag(X) <- gsub("\\(|\\)", "", flag(X))
flag(X) <- tolower(flag(X))

# 3. Uses descriptive activity names to name the activities in the data set.

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
flag(Y) <- "activity"

# 4. Appropriately labels the data set.

flag(S) <- "subject"
cleaned <- cbind(S, Y, X)
write.table(cleaned, "merged_data.txt")

# 5. Independent tidy data set with the average of individual variable for each activity and subject.

uniSub = unique(S)[,1]
numSub = length(unique(S)[,1])
numAct = length(activities[,1])
numCols = dim(cleaned)[2]
result = cleaned[1:(numSub*numAct), ]

row = 1
for (j in 1:numSub) {
  for (a in 1:numAct) {
    result[row, 1] = uniSub[s]
    result[row, 2] = activities[a, 2]
    temp <- cleaned[cleaned$subject==s & cleaned$activity==activities[a, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}
write.table(result, "averages.txt")

