# Interlude 4
# Writing Functions: Exercises
# ==================================
#
# Using your R editor, load this file and edit it, adding R code to complete each exercise.
# Save it.
#
# TIPS:
#   - Use comments (#) in your code, if you need to explain anything.
#   - R is case-sensitive.
# 	- Type ?<command-name> in the console to access help on an R command
#   - Highlight code you want to run, then click "Run" at the top right of this pane to see the result.
#   - To clear all variables in the workspace, click the broom icon in the Workspace pane.
#
# ---------------------------------
#
# 1. Driving Test
#
# Examine the drivingTest() function below, and decide what it does.
#
# Next, call the function several times with different inputs. 
# Does this confirm or change your explanation? What does paste()
# do?
#
# Is it possible to call the function with an vector or other data
# structure? With a non-numeric value? Why or why not? (Try it!)
# What happens?

drivingTest = function(age) {
  
  if ( is.numeric(age) & (!is.vector(age)) ) {
    
    if (age >= 17) {
      status ="You can drive!";
      
    } else if (age >= 16) {
      status = "You are almost old enough to drive!";
      
    } else {
      status = "You are not old enough to drive.";
      
    }  
    print(paste("You are", age, "years old.", status));
    
  } else {
    print("Please call this function with a single numeric input.");
  }    
}

age = 18;
drivingTest(age);

# ------------------------------
# 2. Miles to Kilometers Conversion
# 
# Write a simple function that accepts a numeric value, in miles, and 
# converts the value(s) to kilometers.
#
# Use the following information: 
#   kilometers = (8/5) * miles
# 
# Test the function with the following vector, and print the results.
miles = c(50, 100, 200, 275)

# What is the type (class) of the output, given the input vector miles?

# What is the type (class) of the output if you supply a single numeric value?
# What about a single character value?

# ------------------------------
# 3. Average and Standard Deviation
#
# Write a simple function that prints out the mean and standard deviation
# of an input set of numbers. Test the result on the body and brain columns of
# the dataset mammals (mammals$body in units of kg, mammals$brain in units of g).
#
# Hints: 
#   - The native R function mean() can be used for the mean.
#   - The standard deviation is calculated as the square root (sqrt()) of the variance (var())
#       of a set of numbers. Or, use native R function sd().
#   - To print out the values, you can use print() and paste(), or build an array from your
#       calculated values:
#         c(mean=avg, stdDev=sd)
#
library(MASS) # loads the dataset called "mammals"


# Function exercise in the survey dataset:
# =====================================================

# 4. In the survey dataset, convert all heights to inches ("Imperial") from Metric.

# Import the excerpted survey data frame by running the following load code:
library(MASS)

loadS <- function(survey) {
  # subset survey and omit NAs:
  s = data.frame(Gender=survey$Sex, 
                 Hand=survey$W.Hnd, 
                 Height=survey$Height, 
                 HtUnit=survey$M.I, 
                 Age=survey$Age);
  
  s = na.omit(s);
  
  # One-liner that converts anything labeled Imperial to Inches from cm.
  # This conversion is needed for the exercise below to work.
  s$Height[s$HtUnit=='Imperial']= s$Height[s$HtUnit=='Imperial']/2.54;
  return(s);
}

s = loadS(survey);

# --- end load code ---

# -------------------------------------------------------------------

# a. How many rows are in the data frame?

# ------------------------------------------------------------------- 

# How many height measurements are in Imperial units in the data frame? 
# How many height measurements are in Metric units?
# Hint: use table() function on the HtUnit column of the data frame.

# -------------------------------------------------------------------

# b. What is the range of Imperial heights in the data frame (in inches)?
#     What is the range of Metric heights in the data frame (in cm)?
#
#   Hint: index into the data frame, specifying:
#         Rows having Imperial (or Metric) units
#         Column of Height measurements
#       ...and take the range() of this construction.

# -------------------------------------------------------------------

# 5. Demo: Convert all heights in the data frame to inches ("Imperial") from Metric.
# one inch = 2.54 cm
#
# Implemented as a demo: look over it, play with it, understand it!
#
# First, construct a vector of the heights that are labeled 'Metric'. 
#
# To get this:
# We take the Heights column from the data frame (s$Height),
# then specify those indices having s$HtUnit equal to 'Metric'.
s$Height[s$HtUnit=='Metric']

# Create a one-liner that converts the Metric heights from cm to Inches:
#
# Set those heights labeled 'Metric' to the converted value.
s$Height[s$HtUnit=='Metric']= s$Height[s$HtUnit=='Metric']/2.54;

# Don't forget to set the Height Unit column to Imperial too!
s$HtUnit[s$HtUnit=='Metric']= "Imperial";  

# To make this into an R-style function:
convertToImperialR <- function(s) {
  s$Height[s$HtUnit=="Metric"]= s$Height[s$HtUnit=="Metric"]/2.54;
  s$HtUnit[s$HtUnit=="Metric"]= "Imperial"; 
  return(s);
}

# here's a quick test of it.
s = loadS(survey);
sImp1 = convertToImperialR(s)

# -------------------------------------------------------------------

# 6. Use the summary() function to find the mean and range for Height,
#   using the new, converted Imperial ("inches") dataset.

# -------------------------------------------------------------------

# 7. Extra credit

# Adapt the existing function to accept a second
# argument, Metric or Imperial. If "Imperial" is passed,
# then convert all heights labeled "Metric" to "Imperial".
# If "Metric" is passed, convert all heights labeled 
# "Imperial" to "Metric".
#
# Ensure your function checks for NAs before proceeding.


