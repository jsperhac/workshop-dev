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
# 
# ANS:
elasticband <- data.frame(stretch=c(46,54,48,50,44,42,52),
                          distance=c(148,182,173,166,109,141,166));

# b. Which is the dependent variable, and which is the independent variable? Which axis should
# each be plotted on?
# ANS: stretch is independent; it belongs on x axis
#      distance is dependent; it belongs on y axis

# c. In the data frame called elasticband, plot distance against stretch. Label your axes and the plot.
# Reminder: scatter plot syntax is: plot(formula=y~x, data=dataframe, main="plot title")
# ANS:
plot(formula=distance~stretch, 
     data=elasticband,
     main="Elastic Band distance traveled with stretch")

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
# ANS: year is independent; it belongs on x axis
#      snow cover is dependent; it belongs on y axis

# c. Plot snow.cover versus year. Label your axes and the plot.
# 
# ANS:
plot(formula=snow.cover~year, 
     data=snowcover, 
     ylab="snow cover, millions of km^2",
     main="Snow cover in Eurasia by Year")

# d. Use the hist() command to plot a histogram of the snow cover values. Label your axes and the plot. 
# Find the best binning to show the data. What is it? 
# Hint: use the histogram syntax: hist(x=data, breaks=suggest_num_bins, xlab="x-label", main="title")
# ANS:
hist(x=snowcover$snow.cover, 
     xlab="snow cover, millions of km^2",
     main="Snow cover in Eurasia, 1970-1979") 

hist(x=snowcover$snow.cover, breaks=1)
hist(x=snowcover$snow.cover, breaks=2)
hist(x=snowcover$snow.cover, breaks=5)

# e. Find the R summary of the snow cover column. Then make a boxplot of the snow cover column.
# Hint: use the boxplot syntax: boxplot(x=data, ylab="y-label", main="title")
# ANS:
summary(snowcover$snow.cover)

boxplot(x=snowcover$snow.cover, 
        ylab="Snow Cover, millions of km^2", 
        main="Snow Cover in Eurasia, 1970-1979")

# -------------------------------------------------------------

# 3. Mammals data frame
#
# The built-in data set mammals contains data on body weight versus brain weight for 
# 62 species of land mammals. Use the command ?mammals to find out about the dataset.
#
# a. Use the cor() function to find the Pearson and Spearman correlation coefficients 
# for body and brain weights. Are they similar? What do these coefficients suggest about 
# the body and brain weights of land mammals?

# ANS:
cor(mammals$body, mammals$brain, method="pearson")
cor(mammals$body, mammals$brain, method="spearman")


# b. Plot the data using the plot command, and label the plot and axes (include units). 
# You should be unsatisfied with this plot. Next, plot the logarithm (log) of each 
# variable; does that make a difference?

# ANS:
xl="body weight, kg"
yl="brain weight, g"
title="Body and Brain Weight of Land Mammals"

plot(formula=mammals$body~mammals$brain, 
     xlab=xl, 
     ylab=yl, 
     main=title)

plot(formula=log(mammals$body)~log(mammals$brain), 
     xlab=paste("log", xl), 
     ylab=paste("log", yl), 
     main=title)

# c. Overlay the log-log plot with a linear model. Are you satisfied with the fit?
#     Hint: the linear model takes the form lm(y~x). To overplot, call abline() on the linear model.
#     Don't forget that you have taken the log of the quantities on both axes.
#
# What do your log-log plots and the correlation results suggest about the data?

# ANS:
abline(lm(log(mammals$body)~log(mammals$brain)))
# Brain weight and body weight seem to scale together.

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

# a. --------------- The relationship between fat and vitamins --------------------

table(u$fat, u$vitamins) 
# looks like "enriched" covers a multitude of fatty cereals (plus lots of other stuff)

# lowest fat cereals
lowfat = which(u$fat<1)
print(u[lowfat,c("fat","vitamins")])

# highest fat cereals
highfat = which(u$fat>=4)
print(u[highfat,c("fat","vitamins")])

# boxplot of all
boxplot(formula=fat~vitamins, 
        data=u,
        main="Cereal fat and vitamins",
        xlab="vitamins and minerals",
        ylab="fat per portion/grams")

# barplot of vitamins
barplot(table(u$vitamins), 
        main="Cereal vitamins")

# histogram of fat content
hist(u$fat, 
     main="Cereal fat",
     col="grey")

# summaries
summary(u$fat)
summary(u$vitamins)

# --- Cereal fat and vitamins Dotplot: Grouped, Sorted, and Colored ---
# Sort by fat, group and color by vitamins
unique(as.integer(u$vitamins)) # to find the integers used to code vitamins

x = data.frame(u$vitamins, u$fat)
x <- u[order(u$fat),] # sort by fat
x$color[x$vitamins=="none"] <- "red"
x$color[x$vitamins=="100%"] <- "darkgreen"
x$color[x$vitamins=="enriched"] <- "darkblue"
dotchart(x$fat,
         labels=rownames(x),
         cex=.5,
         pch=20,
         groups= x$vitamins,
         main="Fat content for cereals \ngrouped by Vitamin content",
         xlab="Fat grams per serving", 
         gcolor="black", 
         color=x$color) 

# ---

# create data frame "lowfat":
fat=u$fat[u$fat<1.5]
vitamins=u$vitamins[u$fat<1.5]
lowfat=data.frame(fat, vitamins)
dim(lowfat)
# [1] 47  2

str(lowfat)
#'data.frame':  47 obs. of  2 variables:
#  $ fat     : num  0 0 1.49 0 1 ...
#  $ vitamins: Factor w/ 3 levels "100%","enriched",..: 2 2 2 2 2 2 2 2 2 2 ...

levels(lowfat$vitamins)
# [1] "100%"     "enriched" "none"  

boxplot(formula=fat~vitamins, 
        data=lowfat,
        main="Lowfat cereals fat and vitamins",
        xlab="vitamins and minerals",
        ylab="fat per portion/grams")

table(lowfat$fat, lowfat$vitamins)
#             100% enriched none
# 0            1       18    3
# 0.6666667    0        1    0
# 1            3        7    0
# 1.1363636    0        1    0
# 1.3333333    1        8    0
# 1.4925373    0        4    0

# ---

# create data frame "highfat":
fat=u$fat[u$fat>=4]
vitamins=factor(u$vitamins[u$fat>=4]) # using factor() cuts out unused categories
highfat=data.frame(fat, vitamins)
dim(highfat)
# [1] 6  2

str(highfat)
#'data.frame':  6 obs. of  2 variables:
#  $ fat     : num  4 4 6 9.09 4 ...
#  $ vitamins: Factor w/ 1 levels "enriched"

levels(highfat$vitamins)
# [1] "enriched"  

boxplot(formula=fat~vitamins, 
        data=highfat,
        main="Highfat cereals fat and vitamins",
        xlab="vitamins and minerals",
        ylab="fat per portion/grams")

table(highfat$fat, highfat$vitamins)
#             enriched
# 4                4
# 6                1
# 9.0909091        1

# ---------------- d. the relationship between sodium and sugars ---------------------------------

table(u$sodium, u$sugars) # it's a big table...
cor(u$sodium, u$sugars) # 0.2112437

summary(u$sugars)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.00    4.00   12.00   10.05   14.00   20.90 
summary(u$sodium)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.0   180.0   232.0   237.8   290.0   787.9 

# the line looks pretty flat:
plot(formula=sodium~sugars, 
        data=u,
        main="Cereals sodium and sugars",
        xlab="grams of sugar per portion",
        ylab="milligrams of sodium per portion")

# try a boxplot: yup, looks pretty flat
boxplot(formula=sodium~sugars, 
        data=u,
        cex.axis=0.6,
        las=2,                       
        main="Cereals sodium and sugars",
        xlab="grams of sugar per portion",
        ylab="milligrams of sodium per portion")

# Why would it be wrong to do the following? Hint: Look at the numbers
# on the x axis!! Are they in ascending order?
sug=reorder(u$sugars,u$sodium) # sort sugars by sodium content
boxplot(formula=sodium~sug, 
     data=u,
     cex.axis=0.6,
     las=2,               
     main="Cereals sodium and sugars: a misleading example",
     xlab="grams of sugar per portion",
     ylab="milligrams of sodium per portion")

hist(u$sugars,
     xlab="Sugar content, grams per portion",
     main="Sugar content in breakfast cereals",
     col="grey")

hist(u$sodium,
     xlab="Sodium content, milligrams per portion",
     main="Sodium content in breakfast cereals",
     col="grey")

