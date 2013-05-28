# R examples--barplots with Cars93
# 1 April 2013 
#

library(MASS)
cr = Cars93

# ------------ Basic boxplots, or box-and-whisker plots ------

# features: display Q1, Mean, Q3, outliers (as circles)

# do manual transmission cars get better gas mileage in this dataset?
boxplot(formula=MPG.city~Man.trans.avail, 
        data=cr, 
        xlab="Manual Transmission Available?", 
        ylab="MPG, city",
        col=c("red", "darkblue"))
title("Miles per Gallon with Transmission Type")

# Relationship between horsepower and number of cylinders?
colors=rainbow(length(levels(cr$Cylinders)))
boxplot(formula=Horsepower~Cylinders, 
        data=cr,  
        xlab="# Cylinders", 
        ylab="Horsepower",
        col=colors)
title("Vehicle Horsepower with Number of Cylinders")

# --------------  MPG city and highway: as a box plot --------------

# Note that MPG is a numeric value, but still, we are doing some statistics on it!
# hence we get a boxplot. 

par(mfrow=c(1,2))
xl = "MPG.city"
yl="MPG.highway"
colors=rainbow(length(levels(factor(cr$MPG.city))))
boxplot(formula=MPG.highway~MPG.city, 
        data=cr, 
        xlab=xl, 
        ylab=yl,
        col=colors)
title("MPG city and highway")

# same MPG data as above as a scatterplot. Which is more informative, scatter or box?
xl = "MPG.city"
yl="MPG.highway"
plot(formula=MPG.highway~MPG.city, 
     data=cr, 
     xlab=xl, 
     ylab=yl,
     pch=1)
title("MPG city and highway")
fit2=lm(cr$MPG.highway~cr$MPG.city)
abline(fit2)
par(mfrow=c(1,1))

# wow, which cars do better than 40 MPG in the city?
#
# cr[cr$MPG.city>40,
#        c("Make","MPG.city","MPG.highway","Weight","Passengers")]
#
#Make MPG.city MPG.highway Weight Passengers
#39   Geo Metro       46          50   1695          4
#42 Honda Civic       42          46   2350          4

# ------------------------------------------

# boxplots of vehicle weight by type. Ordering the categorical variables for clarity.

colors=rainbow(length(levels(cr$Type)))
par(mfrow=c(1,2))

# notice that the categorical variables are ordered alphabetically:
boxplot(formula=Weight~Type, 
        data=cr, 
        cex.axis=0.6,
        las=2,        
        xlab='Vehicle Type', 
        ylab='Weight/lbs.')
title("Vehicle weight by type, first try")

# using a reorder() call, we can order the vehicle types by weight instead of alphabetical order:
type=reorder(cr$Type,cr$Weight)
colors=rainbow(length(levels(cr$Type)))
boxplot(formula=Weight~type, 
        data=cr, 
        cex.axis=0.6,
        las=2,        
        xlab='Vehicle Type', 
        ylab='Weight/lbs.',
        col=colors)
title("Vehicle weight by type, type ordered by weight")
par(mfrow=c(1,1))

# ---- Violin Plot ----------

# A violin plot is a combination of a box plot and a kernel density plot. 
# Specifically, it starts with a box plot. It then adds a rotated kernel 
# density plot to each side of the box plot.

# Here is a violin plot of Weight and Type.
# library(vioplot)
# x1 <- cr$Weight[cr$Type=="Small"]
# x2 <- cr$Weight[cr$Type=="Sporty"]
# x3 <- cr$Weight[cr$Type=="Compact"]
# x4 <- cr$Weight[cr$Type=="Midsize"]
# x5 <- cr$Weight[cr$Type=="Large"]
# x6 <- cr$Weight[cr$Type=="Van"]
# vioplot(x1,  x2,  x3, x4, x5, x6, names=levels(cr$Type),
#         col="blue")
# title("Violin Plots: Vehicle MPG City and Highway")
# detach("package:vioplot", unload=TRUE)

# ------------ Another order-your-categorical-variable example Vehicle Price and Type: --------------
#
# comparing we can see:
# colors=rainbow(length(levels(cr$Type)))
# par(mfrow=c(1,2))
# xl = "Auto Type"
# boxplot(formula=Price~Type, 
#         data=cr, 
#         xlab=xl,
#         cex.axis=0.6,
#         las=2,
#         ylab="Average Price in thousands of Dollars")
# title(paste("Price with Auto Type, first try"))
# tp=reorder(cr$Type,cr$Price) # reorder type factor by price
# boxplot(formula=Price~tp, 
#         data=cr, 
#         xlab=xl, 
#         cex.axis=0.6,
#         las=2,
#         ylab="Average Price in thousands of Dollars",
#         col=colors)
# title(paste("Price with Auto Type, type ordered by price"))
# par(mfrow=c(1,1), pch=1)

# --- box plots with Manufacturer ----

# mention the quartiles we discussed earlier...
# appearance tips:
#     reorder the categorical x value by the y value.
#
#     rotate the x axis label 90 degrees; use las
#         The las setting sets the axis label style with respect to the axis: 
#         0=parallel, 1=all horizontal, 2=all perpendicular to axis, 3=all vertical
#
#     scale the axis labels by 60% of default text size; use cex.axis

# here's our first try:
#   notice that:
#       hard to interpret the graph
#       some x axis labels are missing: what's the one with the huge quartile extent?
#       
xl = "Auto Manufacturer"
boxplot(formula=Price~Manufacturer, 
        data=cr, 
        xlab=xl, 
        ylab="Average Price in Thousands of Dollars")
title("Vehicle Price with Manufacturer: first try")

# make some changes to improve the information conveyed by these plots:
#   - reorder the category "Manufacturer" (x axis) by the y axis quantity
#   - scale and rotate x axis labels
#   - colors for the boxes

# color boxes by Manufacturer
colors=rainbow(length(levels(cr$Manufacturer)))

# Vehicle Price by Manufacturer
mp=reorder(cr$Manufacturer,cr$Price)
xl = "Auto Manufacturer"
boxplot(formula=Price~mp, 
        data=cr, 
        xlab=xl, 
        ylab="Average Price in Thousands of Dollars", 
        cex.axis=0.6,
        las=2,
        col=colors)
title("Vehicle Price with Manufacturer")

# Vehicle MPG by Manufacturer
mpg=reorder(cr$Manufacturer,cr$MPG.highway)
boxplot(formula=MPG.highway~mpg, 
        data=cr, 
        xlab=xl, 
        ylab="MPG, highway",
        cex.axis=0.6,
        las=2,
        col=colors)
title("Highway MPG with Vehicle Manufacturer")

# this makes me wonder how the correlation between price and mpg looks in this dataset!
# the vector specifies column numbers 1=Manufacturer and 3 to 8 (Type, Price, MPG data)
# cor(cr[c(1,3:8)])

# We need to "cast" factors to ints, assemble a new data frame, then do the cor() call:
# manuf = as.integer(cr$Manufacturer)
# type = as.integer(cr$Type)
# compare = data.frame(manuf, type, cr$Price, cr$MPG.city, cr$MPG.highway)
# cor(compare)


# Vehicle Length by Manufacturer
# ml=reorder(cr$Manufacturer,cr$Length)
# boxplot(formula=Length~ml, 
#         data=cr, 
#         xlab=xl, 
#         ylab="Length in Inches",
#         cex.axis=0.6,
#         las=2,
#         col=colors)
# title("Vehicle Length with Manufacturer")

# ---------- box plots with auto type ---------------

# what are our auto types?
levels(cr$Type)
# [1] "Compact" "Large"   "Midsize" "Small"   "Sporty"  "Van"  

table(cr$Type)
# Compact   Large Midsize   Small  Sporty     Van 
#      16      11      22      21      14       9 

# ---- without reordering: ----
# xl = "Auto Type"
# boxplot(formula=Price~Type, 
#         data=cr,
#         xlab=xl,
#         ylab="Average Price in thousands of Dollars")
# title(paste("No reorder: Price with",xl))
# 
# boxplot(formula=Length~Type, 
#         data=cr, 
#         xlab=xl, 
#         ylab="Length in Inches")
# title(paste("No reorder: Length with",xl))
# 
# boxplot(formula=Wheelbase~Type, 
#         data=cr, 
#         xlab=xl, 
#         ylab="Wheelbase in Inches")
# title(paste("No reorder: Wheelbase with",xl))

# ---- now try some reordering to improve the plots: ----
xl="Vehicle Type"
tw=reorder(cr$Type,cr$Wheelbase) # order type category by wheelbase
colors=rainbow(length(levels(cr$Type)))
boxplot(formula=Wheelbase~tw, 
        data=cr, 
        xlab=xl, 
        ylab="Wheelbase in Inches",
        col=colors)
title(paste("Wheelbase with",xl))

# -------- what's the best way to plot this data? ------------

#table(cr$DriveTrain)
# 4WD Front  Rear 
#  10    67    16 

#table(cr$RPM)
# 3800 4000 4100 4200 4400 4500 4600 4800 5000 5100 5200 5300 5400 5500 5550 5600 5700 5750 5800 5900 6000 6200 6300 
# 1    2    1    3    1    1    4   13   10    1   10    1    4    8    1    6    2    1    4    1   14    1    1 

# 6500 
# 2 

# reorder drivetrain for a nicer plot
# dt=reorder(cr$DriveTrain, cr$RPM)
# colors=rainbow(length(levels(cr$DriveTrain)))
# plot(formula=RPM~dt, 
#      data=cr, 
#      xlab="drivetrain", 
#      ylab="engine RPM at max horsepower",
#      col=colors) # a boxplot, since one value is categorical
# title("RPM with Drivetrain type")

# reverse the formula; what does it mean?
#plot(formula=DriveTrain~RPM, data=cr, ylab="drivetrain", xlab="engine RPM") # what does it mean?
#title("RPM with Drivetrain type")


# --------------- Looking into Wheelbase ------------------

# Vehicle Wheelbase by Manufacturer
colors=rainbow(length(levels(cr$Manufacturer)))

mw=reorder(cr$Manufacturer,cr$Wheelbase)
boxplot(formula=Wheelbase~mw, 
        data=cr, 
        xlab=xl, 
        ylab="Wheelbase in Inches",
        cex.axis=0.6,
        las=2,
        col=colors)
title("Vehicle Wheelbase with Manufacturer")

# note: what's the story with some of these wheelbases? 
# Ford, for instance, has a huge range. Let's look:
ford=cr[cr$Manufacturer=="Ford",]
summary(ford$Wheelbase)
# Ford wheelbases really do range from 90 to 114 inches!
# 
# # calling factor() enables us to strip unused levels from Make and Type variables
# # refer here, use the factor() call to lose extra levels.
# # http://www.r-bloggers.com/drop-unused-factor-levels/
ford <- data.frame(factor(ford$Make), 
                  factor(ford$Type), 
                  factor(ford$Model),
                  ford$Wheelbase) 
summary(ford)
#     factor.ford.Make. factor.ford.Type. ford.Wheelbase ...
# 1        Ford Festiva             Small             90
# 2         Ford Escort             Small             98
# 3          Ford Tempo           Compact            100
# 4        Ford Mustang            Sporty            101
# 5          Ford Probe            Sporty            103
# 6       Ford Aerostar               Van            119
# 7         Ford Taurus           Midsize            106
# 8 Ford Crown_Victoria             Large            114

# here's another way to do the same subsetting operation, with better control of column names:
# # refer here, use the factor() call to lose extra levels.
# # http://www.r-bloggers.com/drop-unused-factor-levels/
model=factor(cr[cr$Manufacturer=="Ford","Model"])   # was a factor
type=factor(cr[cr$Manufacturer=="Ford","Type"])   # was a factor
wheelbase=cr[cr$Manufacturer=="Ford","Wheelbase"] # was an int

# here we could make a data frame containing whatever we want:
# ford = data.frame(model, type, wheelbase)

# here's a Ford Wheelbase boxplot with Type:
par(mfrow=c(1,2))

colors=rainbow(length(levels(type)))
mw=reorder(type,wheelbase)
boxplot(formula=wheelbase~mw, 
        data=cr, 
        xlab=xl, 
        ylab="Wheelbase in Inches",
        col=colors)
title("Ford Vehicle Wheelbase with Type")

# with Model, it's still essentially a boxplot, since x is categorical:
mw=reorder(model,wheelbase)
plot(formula=wheelbase~mw, 
        data=cr, 
        xlab="Ford Model", 
        cex.axis=0.8,
        las=2,     
        ylab="Wheelbase in Inches",
        pch=1) # pch gets ignored
title("Ford Vehicle Wheelbase with Model")
par(mfrow=c(1,1))

# And looking over at MPG.city with wheelbase:
# wheelbase=cr[cr$Manufacturer=="Ford","Wheelbase"] # an int
# plot(formula=mpg.city~wheelbase, 
#      ylab="MPG.city", 
#      xlab="Wheelbase in Inches",
#      pch=1)
# title("Ford Vehicle MPG.city with Wheelbase")
# # create and draw regression line:
# fit2=lm(mpg.city~wheelbase)
# abline(fit2,col="purple")







