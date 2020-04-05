## --------- From discusson forum --------------#
# About the last step: clarification
# https://www.coursera.org/learn/data-cleaning/discussions/weeks/4/threads/LT34L_IvEeehOg4TMR5MNA

## ------- Testing bind_rows ----------------

# Create data frames to combine
boys_age <- c(18,15,16,17,19)
girls_age<- c(16,14,18,17,15)
boys <- as.data.frame(boys_age)
girls <- as.data.frame(girls_age)
b_g <- bind_rows(boys, girls)
b_g_id <- bind_rows(boys, girls, .id = "id")
b_g_grp <- bind_rows("group1" = boys, "group2" = girls)
b_g_dfr <- bind_rows(data.frame(boys), data.frame(girls))


data("mtcars")
one <- mtcars[1:4, ]
two <- mtcars[11:14, ]

one_two <- bind_rows(one, two)

bind_rows("group 1" = one, "group 2" = two, .id = "groups")

## ------ Check for differencies in 2 vectors -----------
# Create test vectors
a <- c(1, 1, 3, 4, 5, 7, 9)
b <- c(2, 3, 4, 6, 8, 2)
c <- c("a", "b", "c", "d", "e", "f")
d <- c("a", "b", "r", "d")

# Check what differs between b and a
vec_diff <- setdiff(b, a)
vec_diff

# Check what differs between d and c
setdiff(d, c)
setdiff(c, d)


names(train_data_full)

test_names <- names(test_data_full)
train_names <- names(train_data_full)
identical(test_names, train_names)
setdiff(test_names, train_names)
setdiff(train_names, test_names)

devtools::install_github("tidyverse/dplyr")

# Remove parentheses
new_vector <- str_remove(to_names, "\\(")
new_vector <- str_remove(new_vector, "\\)")
