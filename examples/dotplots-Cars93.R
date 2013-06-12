# dotplot-Cars93.R

library(MASS)
cr = Cars93

# --------------- Cars93 Dotplot: US only ---------------------

# Dotplot: Grouped, Sorted, and Colored
# Sort by mpg, group and color by cylinder
cr = Cars93
cr = cr[cr$Origin=="USA",]
Cylinders = factor(cr$Cylinders)
MPG.city = cr$MPG.city
Make = factor(cr$Make)
cr = data.frame ( Cylinders, MPG.city, Make )

x <- cr[order(cr$MPG.city),] # sort by mpg
#x$cyl <- factor(x$cyl) # it must be a factor
x$color[x$Cylinders=="3"] <- "red"
x$color[x$Cylinders=="4"] <- "orange"
x$color[x$Cylinders=="5"] <- "darkgreen"
x$color[x$Cylinders=="6"] <- "blue"
x$color[x$Cylinders=="8"] <- "darkblue"
x$color[x$Cylinders=="rotary"] <- "purple"
dotchart(x$MPG.city,
         labels=x$Make,
         cex=.5,
         pch=20,
         groups= x$Cylinders,
         main="Gas Mileage for USA Car Models\ngrouped by # Cylinders",
         xlab="Miles Per Gallon (city)", 
         gcolor="black", 
         color=x$color) 

# ---------- non-usa Cars93 dotplot --------------

# Dotplot: Grouped, Sorted, and Colored
# Sort by mpg, group and color by cylinder
cr = Cars93
cr = cr[cr$Origin=="non-USA",]
Cylinders = factor(cr$Cylinders)
MPG.city = cr$MPG.city
Make = factor(cr$Make)
cr = data.frame ( Cylinders, MPG.city, Make )

x <- cr[order(cr$MPG.city),] # sort by mpg
#x$cyl <- factor(x$cyl) # it must be a factor
x$color[x$Cylinders=="3"] <- "red"
x$color[x$Cylinders=="4"] <- "orange"
x$color[x$Cylinders=="5"] <- "darkgreen"
x$color[x$Cylinders=="6"] <- "blue"
x$color[x$Cylinders=="8"] <- "darkblue"
x$color[x$Cylinders=="rotary"] <- "purple"
dotchart(x$MPG.city,
         labels=x$Make,
         cex=.5,
         pch=20,
         groups= x$Cylinders,
         main="Gas Mileage for non-USA Car Models\ngrouped by # Cylinders",
         xlab="Miles Per Gallon (city)", 
         gcolor="black", 
         color=x$color) 

# -------------- mtcars dotplot -------------------

# Dotplot: Grouped, Sorted, and Colored
# Sort by mpg, group and color by cylinder
x <- mtcars[order(mtcars$mpg),] # sort by mpg
x$cyl <- factor(x$cyl) # it must be a factor
x$color[x$cyl==4] <- "red"
x$color[x$cyl==6] <- "blue"
x$color[x$cyl==8] <- "darkgreen"
dotchart(x$mpg,labels=row.names(x),
         cex=.7,
         pch=20,
         groups= x$cyl,
         main="Gas Mileage for Car Models\ngrouped by # Cylinders",
         xlab="Miles Per Gallon", 
         gcolor="black", 
         color=x$color) 