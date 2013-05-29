# Interlude 5
# Visualizing Data in R: Plotting exercises
# =========================================
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
#   - To clear all plots in the workspace, click the broom icon in the Plots pane.
#
# -------------------------------

# 1. Elastic band data frame
# 
# The following data gives, for each amount by which an elastic band is stretched over the end of a
# ruler, the distance that the band moved when released:
# 
# stretch 46 54 48 50 44 42 52
# distance 148 182 173 166 109 141 166
# 
# a. Use the function data.frame() to create a data frame containing these data. 
# Give the data frame the name elasticband.
# 
# Hint: Use the function c() to create column vectors, and data.frame() to create the data frame.
#     Make sure you name the data frame's columns, e.g.
#         data.frame(name1=c(1,2,3), name2=c(4,5,6))


# b. Which is the dependent variable, and which is the independent variable? Which axis should
# each be plotted on?


# c. In the data frame called elasticband, plot distance against stretch. Label your axes and the plot.
# Reminder: scatter plot syntax is: plot(formula=y~x, data=dataframe, main="plot title")


# -------------------------------------------------------------

# 2. Snow cover data frame
# 
# The following ten observations, taken during the years 1970-79, are on October snow cover for Eurasia.
# (Snow cover is in millions of square kilometers):
# 
#   year snow.cover
#   ---- ----------
#   1970 6.5
#   1971 12.0
#   1972 14.9
#   1973 10.0
#   1974 10.7
#   1975 7.9
#   1976 21.9
#   1977 12.5
#   1978 14.5
#   1979 9.2
# 
# a. Use the following data frame in R for the snow cover exercises:
snowcover <- data.frame(year=c(1970:1979),
                        snow.cover=c(6.5, 12.0, 14.9, 10.0, 10.7, 7.9, 21.9, 
                                     12.5, 14.5, 9.2))

# b. Which is the dependent variable, and which is the independent variable? Which axis should
# each be plotted on?


# c. Plot snow.cover versus year. Label your axes and the plot.
# 


# d. Use the hist() command to plot a histogram of the snow cover values. Label your axes and the plot. 
# Find the best binning to show the data. What is it? 
# Hint: use the histogram syntax: hist(x=data, breaks=suggest_num_bins, xlab="x-label", main="title")


# e. Find the R summary of the snow cover column. Then make a boxplot of the snow cover column.
# Hint: use the boxplot syntax: boxplot(x=data, ylab="y-label", main="title")


# -------------------------------------------------------------

# 3. Mammals data frame
#
# The built-in data set mammals contains data on body weight versus brain weight for 
# 62 species of land mammals. Use the command ?mammals to find out about the dataset.
#
# a. Use the cor() function to find the Pearson and Spearman correlation coefficients 
# for body and brain weights. Are they similar? What do these coefficients suggest about 
# the body and brain weights of land mammals?


# b. Plot the data using the plot command, and label the plot and axes (include units). 
# You should be unsatisfied with this plot. Next, plot the logarithm (log) of each 
# variable; does that make a difference?

# c. Overlay the log-log plot with a linear model. Are you satisfied with the fit?
#     Hint: the linear model takes the form lm(y~x). To overplot, call abline() on the linear model.
#     Don't forget that you have taken the log of the quantities on both axes.
#
# What do your log-log plots and the correlation results suggest about the data?


# -------------------------------------------------------------

# 4. In the library MASS is a dataset called UScereal, which contains information about popular 
# breakfast cereals. Access the data set as follows:
#   
# library(MASS)   # make the data frame available
# names(UScereal) # to see the names of the columns
# 
# Now, pick one of the following relationships to investigate, and comment on what you see. 
# You can use tables, barplots, scatterplots, descriptive statistics, etc. to do your investigation.
# 
# a. The relationship between fat and vitamins
# b. the relationship between carbohydrates and sugars
# c. the relationship between fibre and manufacturer
# d. the relationship between sodium and sugars
# 
# Are there other relationships you can predict and investigate?

library(MASS)
names(UScereal)
u = UScereal

