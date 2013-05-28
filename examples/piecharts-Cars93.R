# piecharts-Cars93.R
#
# Playing with piecharts in the Cars93 dataset.
#
# What can pie charts tell us? 
# 	- a general graphical sense of the contents of some single variable in our dataset
# 	- establish whether we need to perform some binning for histograms
# 	- assist in data exploration
#
# Note: Pie charts can be made regardless of whether a variable is categorical or numeric.
# Either way, need to have small number of distinct values for an effective visual presentation.
#
# Basic syntax:
#   pie( x=table(data.frame.column.name) )

library(MASS)
cr = Cars93

# --------- super basic pie chart -----------------

# as basic as possible! Please label me!
pie(table(cr$Cylinders))

# plain jane: pie chart of Cylinders (categorical) from Cars93 data
slices <-table(cr$Cylinders)
lbls <- levels(cr$Cylinders)
pie(slices, 
    labels = lbls, 
    col=rainbow(length(lbls)),
    main="Example Piechart: Number of Cylinders in Auto Dataset") 

# plain jane: pie chart of Passengers (numeric) from Cars93 data
slices <-table(cr$Passengers)
lbls <- levels(factor(cr$Passengers))
pie(slices, 
    labels = lbls, 
    col=rainbow(length(lbls)),
    main="Example Piechart: Maximum Number of Passengers in Auto Dataset") 
        
# --------- pie chart with computed percentages -----------------  
#      
# pie chart of Cylinders from Cars93 data        
# same chart, with percents on the labels:    
slices <-table(cr$Cylinders)
lbls <- levels(cr$Cylinders)
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, "Cylinders:", pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # add % to labels
pie(slices,
    labels = lbls, 
    col=rainbow(length(lbls)),
    main="Example Piechart: Number of Cylinders in Cars93 Dataset") 

# --------------- Create a piechart function ------------------

# Here is a general makePie() function, plus calls for a number
# of different variables in the dataset:

# ----------------------------------------------------
# makePie()
#   col: column (numeric or categorical) in Cars93 dataset
#   name: string name to appear in title of piechart
# ----------------------------------------------------
makePie <- function(col, name) {
  
  # determine slices in the pie:
	slices <-table(col)
	
  # check for categorical or numeric and assign labels:
	if (is.factor(col)) {
	  lbls <- levels(col)
	} else { 
    # make it a factor, then get levels:
	  lbls <- levels(factor(col))
	}
  # calculate percentage for each slice
	pct <- round(slices/sum(slices)*100)
	
  # construct labels for the slices:
  lbls <- paste(lbls, ":", pct) # add percents to labels
	lbls <- paste(lbls, "%" ,sep="") # add % to labels
  
  # plot it:
	p <- pie(slices,
          labels = lbls, 
          col=rainbow(length(lbls)),
		      main=paste(name, "in Cars93 Dataset")) 
}

# a few examples:
#makePie(cr$Passenger, "Max Passengers")
#makePie(cr$Cylinders, "# Cylinders")
makePie(cr$Type, "Vehicle Type")
makePie(cr$AirBags, "Vehicle Airbags")
makePie(cr$Origin, "Vehicle Origin")
#makePie(cr$Man.trans.avail, "Manual Transmission Available")

makePie(cr$DriveTrain, "Vehicle Drivetrain")
# makePie(cr$Manufacturer, "Vehicle Manufacturer")
makePie(cr$Turn.circle, "Turn Circle")
#makePie(cr$Luggage.room, "Luggage Room")

# These variables have too many values to make good pie charts! 
# Try hist or barplot.
#makePie(cr$RPM, "RPM")
#makePie(cr$EngineSize, "Engine Size")
#makePie(cr$Horsepower, "Horsepower")
#makePie(cr$Weight, "Weight")
#makePie(cr$Length, "Length")
#makePie(cr$Wheelbase, "Wheelbase")
