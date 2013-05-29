# Interlude 3
# Descriptive Statistics exercises
# ==================================
#
# Using your R editor, load this file and edit it, adding R code to complete each exercise.
# Save it.
#
# TIPS:
#   - Use comments (#) in your code, if you need to explain anything.
# 	- R is case-sensitive.
# 	- Type ?<command-name> in the console to access help on an R command
#   - Highlight code you want to run, then click "Run" at the top right of this pane to see the result.
#   - To clear all variables in the workspace, click the broom icon in the Workspace pane.
#   - To clear all plots in the workspace, click the broom icon in the Plots pane.
#
# ---- Vector data extraction summary: ------
# 
# length(x)     # how many elements?
# x[2]          # return ith element; (i = 2)
# x[-2]         # return all but ith element; (i = 2)  
# x[1:5]        # return first k elements; (k = 5) 
# x[(length(x)-5):length(x)]    # return last k elements; (k = 5)
# x[c(1,3,5)]                   # return specific elements; (First, 3rd and 5th)
# x[x>3]                        # return all elements that are greater than some value (the value is 3) 
# x[ x< -2 | x > 2]             # return elements bigger than or less than some values (the value is 2) 
# which(x == max(x))            # return index that corresponds to the largest value
#
# ---- Statistical functions: -----
#
# mean(x)       # average or mean value, of x
# median(x)     # median, or middle value, of x
# range(x)      # return minimum and maximum value of x
#   min(x)
#   max(x)
# var(x)        # variance of x
# sd(x)         # standard deviation, or square root of variance of x
# summary(x)    # R statistical summary of x
#
# -------------------------------

# 1. Suppose you keep track of your mileage each time you fill up your car's gas tank. 
# At your last 8 fill-ups, the mileage was:
#     65311 65624 65908 66219 66499 66821 67145 67447
#
# a. Enter these numbers into an R vector. Use the function diff() on the data. What is the result?
#

# b. Use the function length() to find the lengths of the miles and x vectors. 

# c. Use R functions to find the maximum and minimum number of miles between fill-ups, the 
# average number of miles between fill-ups, the standard deviation, and a statistical summary.

# d. Run the following command to create a boxplot of the miles between fill-ups. The bottom of the box 
# is Q1, the top of the box is Q3, the line in the center of the box is the median, and the "whiskers" 
# extend to the min and max:
boxplot(x, ylab="Distance between fill-ups/miles", main="Milage at fill-ups")

# --------------------------------

# 2. You track your commute times for two weeks (10 days) and you find the following times in minutes:
#       17 16 20 24 22 15 21 15 17 22
#
# a. Enter this into a vector called commute. Use R functions to find the longest and shortest commute 
# times, the average, and a statistical summary.

#
# b. Run the following command to create a boxplot of the miles between fill-ups. The bottom of the box 
# is Q1, the top of the box is Q3, the line in the center of the box is the median, and the "whiskers" 
# extend to the min and max:
boxplot(x, ylab="Commute time/minutes", main="Original commute data")
#
# c. Suppose the 24 was a mistake; it should have been 18. How can you fix this? Do so, and then find 
# the new average. Hint: Index into the vector, then use an assignment statement to fix this mistake.

#
# d. Now that you have fixed the datapoint, re-run the boxplot and the summary command. 
summary(commute)
boxplot(x, ylab="Commute time/minutes", main="Corrected commute data")
#
# e. How many times was your commute 20 minutes or more? To answer this you can try (if you called your 
# vector commute):
#   sum( commute >= 20 )
#
# f. What percent of your commutes are less than 17 minutes? How can you answer this with R?

# ----------------------------------------------------------

# 3. Your cell phone bill varies from month to month. Suppose that your bills had the following monthly 
# amounts last year:
# 46 33 39 37 46 30 48 32 49 35 30 48

# a. Enter this data into a variable called bill. 


# b. Find the total amount, and the average amount, that you spent last year on cell phone bills. 


# c. What is the smallest amount you spent on your phone bill last year? What is the largest? Assuming 
# the months are entered in order, which months were these? Hint: use the which() function to find the 
# months.


# d. Run the following calculation, and explain its result:
range(bill)[2] - range(bill)[1]

# e. How many months was the amount greater than $40? What percentage was this?
