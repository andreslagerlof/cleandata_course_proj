# Load useful libraries
library(tidyverse)

#------ Assignment ----------------------------------------------------#
# You should create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

#------------------------------------------------------------------------#

# ------- Prepare to download data --------------------------------------#
# Create a directory called data
if(!file.exists("./data")) {
  dir.create("./data")
}

# Download zip
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(data_url, destfile = "./data/project.zip", method = "curl")

# Unzip file. Destination = current working directory
unzip("./data/project.zip")

# -------- Download and read data files ---------------------------------#
## Read in files and prepare the files
## There are 3 types of files: 1) features file, 2) test data files, 3) train data files
## Each type of files will be prepared and finally merged

## -- Start with features file -- ##
## The features files will be used to set variable names to the test and train data 

# Read in the features file
path_features <- "./UCI HAR Dataset/features.txt"
features <- read_table(path_features, col_names = F)

# Clean the features dataset, separate values into 2 columns named "number"and "description"
features <- features %>% 
              separate(X1, sep = " ", into = c("number", "description"))

# Convert the variable "description" to vector that will be used as names to
# test and train data
to_names <- as.vector(features$description)

# Make all lower case
to_names<- tolower(to_names)

# Remove parentheses
to_names <- str_remove(to_names, "\\(")
to_names <- str_remove(to_names, "\\)")


## -- Prepare the test files -- ##
## There are 3 test data files
# Read in the test files
path_x_test <- "./UCI HAR Dataset/test/X_test.txt"
path_y_test <- "./UCI HAR Dataset/test/y_test.txt"
path_subject <- "./UCI HAR Dataset/test/subject_test.txt"
test_data <- read_table(path_x_test, col_names = F)
test_labels <- read_table(path_y_test, col_names = F)
test_subjects <- read_table(path_subject, col_names = F)
table(test_subjects$X1) # 9 subjects

# Set columnames to the dataframe test_data, from the to_names vector prepared above
test_data <-  set_names(test_data, to_names)

# Add new descriptive column to test_labels data frame
test_labels<- test_labels %>% mutate(activity = case_when(
                X1 == 1 ~ "WALKING",
                X1 == 2 ~ "WALKING_UPSTAIRS",
                X1 == 3 ~ "WALKING_DOWNSTAIRS",
                X1 == 4 ~ "SITTING",
                X1 == 5 ~ "STANDING",
                X1 == 6 ~ "LAYING"))

# Create descriptive colum name
test_labels<- rename(test_labels, activity_code = X1)

# Create descriptive variable name to test_subjects dataframe
test_subjects <- rename(test_subjects, subject_no = X1) 

# Combine the 3 test data frames
test_data_full <- bind_cols(test_subjects, test_labels, test_data)


## -- Prepare the train files -- ##
## There are 3 files with train data
# Read in the train files
path_x_train <- "./UCI HAR Dataset/train/X_train.txt"
path_y_train <- "./UCI HAR Dataset/train/y_train.txt"
path_subjects_train <- "./UCI HAR Dataset/train/subject_train.txt"
train_data <- read_table(path_x_train, col_names = F)
train_labels <- read_table(path_y_train, col_names = F)
train_subjects <- read_table(path_subjects_train, col_names = F)
table(train_subjects$X1) # 30 subjects

# Set columnames to the dataframe test_data, from the to_names vector prepared above
train_data <-  set_names(train_data, to_names) 

# Create descriptive variable name to test_subjects dataframe
train_subjects <- rename(train_subjects, subject_no = X1) 

# Add new descriptive column to train_albels data frame
train_labels<- train_labels %>% mutate(activity = case_when(
  X1 == 1 ~ "WALKING",
  X1 == 2 ~ "WALKING_UPSTAIRS",
  X1 == 3 ~ "WALKING_DOWNSTAIRS",
  X1 == 4 ~ "SITTING",
  X1 == 5 ~ "STANDING",
  X1 == 6 ~ "LAYING"))

# Create descriptive colum name
train_labels<- rename(train_labels, activity_code = X1)

# Combine the two train data frames
train_data_full <- bind_cols(train_subjects, train_labels, train_data)

## Now we are are ready for the 1st part of the assignment:
# 1. Merges the training and the test sets to create one data set.

## -- Combine the test and train data frames -- ##

all_data <- bind_rows("test" = test_data_full, 
                      "train" = train_data_full, 
                        .id = "train_or_test")

# Check result
head(all_data)
table(all_data$train_or_test)
names(all_data)


## And now for the 2nd part of the assignment:
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# This will be done in 4 steps: 
# 1) create a data frame with the variables "subject_no",
#    "activity_code" and "activity"  
# 2) create a data frame with all variables containing mean 
# 3) create a data frame with all variables containing standard deviations
# 4) step merge the three data sets

# Step 1: Extract variables about data (train or test) and activity
all_data_activity <- select(all_data, subject_no:activity) # 3 variables 

# Step 2: Extract variable containing measurements om the mean 
all_data_mean <- select(all_data, contains("mean")) # 53 variables

# Step 3: Extract variable containing measurements om the standard deviation "std" 
all_data_sd <- select(all_data, contains("std")) # 33

# Step 4: Combine the 3 data sets, one with mean and the other with sd
all_data_selected <- bind_cols(all_data_activity, all_data_mean, all_data_sd)

## Part 3 and 4 of the assignment are already taken care off that is
## decriptive activity and variable names have been set in previous steps

## Part 5

final_dataset <- all_data_selected %>% 
                group_by(subject_no, activity) %>%
                summarise_all(mean)

# Create a csv file with the complete final dataset
write.table(final_dataset, file = "final_data.txt", row.names = FALSE)

### -------- Data for the code book ---------------- ###
# Create a dataset of the activities and activity codes
activity <- test_data_full %>% group_by(activity_code) %>% distinct(activity) %>% arrange(activity_code)
# Create a csv with activity data info
write.csv(activity, file = "activity.csv")

