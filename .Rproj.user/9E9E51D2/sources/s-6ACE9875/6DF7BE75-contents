# Clean data course project
The course project for *Getting and Cleaning Data* involves these steps:  

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

Please note that, in my solution, the 3rd and 4th steps are done early when the files are downloaded and prepared and thus before all data is merged to one big data set.

## About the data analysis files
The data analysis files for this project comes from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and the data zip file can be downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  
For this data analysis project the following files have been used:

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

## About the scripts
The code for the whole project can be found in the file "run_analysis.R". This file is thoroughly commented but here is an description of the code

## The libraries used
The libraries used for this is mainly `dplyr` and some other packages such as `strngr`from the `tidivyerse`library.


```{r}
library(tidyverse)
```
## First steps: preparing the data sets
Before actually doing the steps in the assignment some preparation is needed. Let's start with downloading the files and preparing the data in R. Just a reminder: I've done the 3rd step _use descriptive activity names to name the activities in the data set_ early, in the preparation phase. 

#### Download the files
In order to start the analysis a R Project file is created. Also directory for the downloaded file is created. Thereafter the project zip file is downloaded and unzipped.

```{r}
# Create a directory called data
if(!file.exists("./data")) {
  dir.create("./data")
}

# Download zip
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(data_url, destfile = "./data/project.zip", method = "curl")

# Unzip file. Destination = current working directory
unzip("./data/project.zip")
```
#### Read in files
With the files downloaded, the next step is to read in the files to R. This is done sequentially, starting with the *features file*. Information from this file will be used as variable labels. This requires some preparation an cleaning. Here is the  code to complete this task:

```{r}
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
```

This results in a vector named "to_names" that will be used to set variable (column) names.

Now it's time for the other files. The workflow I have used is:  

- Read in the files the 3 files to separate data frames
- Set the column names, using he "to_names" vector that we just created
- Add descriptive labels, and clean up column names
- Finally, combine the data frames to a single data frame called "test_data_full"

I start with the with the *test data files*, but the exact same workflow is repeated for the *train data files*.

Here is the code for the *test data files*:

```{r}
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
```
And here's the code for the *train data files* that are saved to the data frame named "train_data_full":

```{r}
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
```
## Back to the assignment!
Now, when we have 2 data sets with all the test and train data.

#### The first task: merge the test and train data set to create one data set 
Above we have used `bind_cols`, merging the data frames *train_data_full* and *test_data_full* is done easily with `bind_rows` both functions from the `dplyr` package.

```{r}
## -- Combine the test and train data frames -- ##

all_data <- bind_rows("test" = test_data_full, 
                      "train" = train_data_full, 
                        .id = "train_or_test")

# Check result
head(all_data)
table(all_data$train_or_test)
names(all_data)
```
#### The 2nd task: extract only the measurements on the mean and standard deviation for each measurement
This will be done in 4 steps: 

 1. create a data frame with the variables "subject_no",
    "activity_code" and "activity"  
 2. create a data frame with all variables containing mean 
 3. create a data frame with all variables containing standard deviations
 4. step merge the three data sets  
 
Once again `dplyr` does it for us! Here's the code:
 
```{r}
# Step 1: Extract variables about data (train or test) and activity
all_data_activity <- select(all_data, subject_no:activity) # 3 variables 

# Step 2: Extract variable containing measurements om the mean 
all_data_mean <- select(all_data, contains("mean")) # 53 variables

# Step 3: Extract variable containing measurements om the standard deviation "std" 
all_data_sd <- select(all_data, contains("std")) # 33

# Step 4: Combine the 3 data sets, one with mean and the other with sd
all_data_selected <- bind_cols(all_data_activity, all_data_mean, all_data_sd)
```
#### The 3rd and 4th steps
A reminder: these steps are already taken care of! Let continue with the 5th step.

#### The 5th step: from the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
This looks complicated, but `dplyr` does all the heavy lifting. Check out the code:

```{r}
final_dataset <- all_data_selected %>% 
                group_by(subject_no, activity) %>%
                summarise_all(mean)
```
Just a few lines of code! Everything is saved  in the data frame _final_dataset_ While we're at it, let's create a csv file with the result.

```{r}
# Create a txt file with the complete final dataset  
write.table(final_dataset, file = "final_data.csv", row.names = FALSE, col.names = TRUE)
```
And we are done!
