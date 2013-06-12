# barplots-Cars93.R
#
# -------------- bar plots ---------------

# What can barplots tell us? 
#   - a general graphical sense of the contents of one or two variables in our dataset
#   - typically used on categorical data
# 	- a visual contingency table between two variables
#   - assist in data exploration
#
# NOTE NOTE on fiddling with sizes of axis annotations:
#   to adjust x label magnification: cex.names=0.75
#   to adjust y label magnification: cex.axis=0.75
# ----------------------------------------

# load the Cars93 dataset
library(MASS)
cr = Cars93

# -------------- bar plots ---------------

# In the cars dataset, how many cylinders does the typical car have?
# Compute a contingency table using table() to find out all the counts.
# Try to answer the question using a barplot.

table(cr$Cylinders)

# cylinder count or type
# 3      4      5      6      8 rotary 
# -     --      --    --      --  ----
# 3     49      2     31      7      1 

# try with "barplot": view the car dataset by # cylinders
counts=table(cr$Cylinders) 
title="Cars93 Car Distribution by Number of Cylinders"
colors=rainbow(length(counts))
barplot(counts, 
		    main=title,
        xlab="number of cylinders", 
        ylab="car count from Cars93 dataset",
        col=colors)

# Auto Type barplot
#counts=table(cr$Type) 
# better: order Type by Weight:
type=reorder(cr$Type,cr$Weight)
counts=table(type) 
colors=rainbow(length(counts))        
title="Cars93 Car Distribution by Vehicle Type"
barplot(counts, 
		main=title,
        xlab="Vehicle Type", 
        ylab="car count from Cars93 dataset",
        col=colors)        
        
# Airbags
# counts=table(cr$AirBags) 
# colors=rainbow(length(counts))      
# title="Cars93 Car Distribution by Vehicle Airbags"  
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle Airbags", 
#         ylab="car count from Cars93 dataset",
#         col=colors)             
#         
# # Origin
# counts=table(cr$Origin) 
# colors=rainbow(length(counts))      
# title="Cars93 Car Distribution by Origin"  
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle Origin", 
#         ylab="car count from Cars93 dataset",
#         col=colors)    
#         
# # DriveTrain
# counts=table(cr$DriveTrain) 
# colors=rainbow(length(counts))      
# title="Cars93 Car Distribution by Vehicle DriveTrain"  
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle DriveTrain", 
#         ylab="car count from Cars93 dataset",
#         col=colors)    

# Manufacturer
counts=table(cr$Manufacturer) 
colors=rainbow(length(counts))      
title="Cars93 Car Distribution by Vehicle Manufacturer"  
barplot(counts, 
        main=title,
        #cex.axis=0.6,
        cex.names=0.7, # x axis
        las=2,                
        xlab="", 
        ylab="car count from Cars93 dataset",
        col=colors)    

# We could sort this barplot by manufacturer counts, instead:
# counts=sort(table(cr$Manufacturer) ) # sort in ascending order
# colors=rainbow(length(counts))      
# title="Cars93 Car Distribution by Vehicle Manufacturer"  
# barplot(counts, 
#         main=title,
#         cex.axis=0.6,
#         las=2,                
#         xlab="", 
#         ylab="car count from Cars93 dataset",
#         col=colors)    

# now MPG--we can do this on numeric data. Resembles a histogram.
# but note that there are gaps at e.g. 35 and 39-40 MPG, etc. Not a histogram!
# counts=table(cr$MPG.highway) 
# colors=heat.colors(length(counts))      
# title="Cars93 Car Distribution by Vehicle MPG, highway"  
# barplot(counts, 
#         main=title,     
#         xlab="MPG, highway", 
#         ylab="car count from Cars93 dataset",
#         col=colors)   
        
# ---------- barplots on combination of variables: contingency table --------------

# Now combine them into a contingency table!  Vehicle Type, and Cylinders
# type=reorder(cr$Type,cr$Weight)
# counts=table(cr$Cylinders, type) 
# title="Cars93 Car Distribution by Vehicle Type and Cylinders"  
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle Type", 
#         ylab="car count from Cars93 dataset",
#         col=rainbow(length(table(cr$Cylinders))), # try ?rainbow for more info
#         legend=levels(cr$Cylinders))

# Airbags and Type        
# counts=table(cr$AirBags, cr$Type) 
# better: order Type by Weight first:
# type=reorder(cr$Type,cr$Weight)
# counts=table(cr$AirBags, type) 
# title="Cars93 Car Distribution by Vehicle Type and Airbags"
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle Type", 
#         ylab="car count from Cars93 dataset",
#         col=heat.colors(length(table(cr$AirBags))),
#         legend=levels(cr$AirBags))
        
# Transmission Type and Vehicle Type        
#counts=table(cr$Man.trans.avail, cr$Type) 
# better: order Type by Weight first:
type=reorder(cr$Type,cr$Weight)
counts=table(cr$Man.trans.avail, type) 
title="Cars93 Car Distribution by Vehicle Type and Manual Transmission Available"
barplot(counts, 
		main=title,
        xlab="Vehicle Type", 
        ylab="car count from Cars93 dataset",
        col=c("red","darkblue"),
        #legend=levels(cr$Man.trans.avail)
        )
legend(x="topright",                # location for legend
       title="Manual Transmission Available?",   # title for legend
       levels(cr$Man.trans.avail),               # names in legend
       fill=c("red","darkblue"))                 # colors for legend
        
# # Origin and Vehicle Type        
# # counts=table(cr$Origin, cr$Type) 
# # better: order Type by Weight first:
# type=reorder(cr$Type,cr$Weight)
# counts=table(cr$Origin, type) 
# title="Cars93 Car Distribution by Vehicle Type and Origin"
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle Type", 
#         ylab="car count from Cars93 dataset",
#         col=c("darkred","darkgreen"),
#         legend=levels(cr$Origin))                        
        
# Passengers and Vehicle Type        
#counts=table(cr$Passengers, cr$Type) 
# better: order Type by Weight first:
type=reorder(cr$Type,cr$Weight)
counts=table(cr$Passengers, type) 
title="Cars93 Car Distribution by Vehicle Type and Max. Passengers"
barplot(counts, 
		main=title,
        xlab="Vehicle Type", 
        ylab="car count from Cars93 dataset",
        col=rainbow(length(table(cr$Passengers))))
        #legend=levels(factor(cr$Passengers)))       
legend(x="topright",                # location for legend
       title="Max # Passengers",          # title for legend
       levels(factor(cr$Passengers)), # names in legend
       fill=rainbow(length(table(cr$Passengers)))) # colors for legend

        
# DriveTrain and Vehicle Type        
# type=reorder(cr$Type,cr$Weight)
# counts=table(cr$DriveTrain, type) 
# title="Cars93 Car Distribution by Vehicle Type and Drive Train"
# barplot(counts, 
# 		main=title,
#         xlab="Vehicle Type", 
#         ylab="car count from Cars93 dataset",
#         col=rainbow(length(table(cr$DriveTrain))),
#         legend=levels(cr$DriveTrain))         

# DriveTrain and Vehicle Type        
# Here's another way to annotate the legend, including a title:
# type=reorder(cr$Type,cr$Weight)
# counts=table(cr$DriveTrain, type) 
# colors=rainbow(length(table(cr$DriveTrain)))
# title="Cars93 Car Distribution by Vehicle Type and Drive Train, with legend title"
# barplot(counts, 
#         main=title,
#         xlab="Vehicle Type", 
#         ylab="car count from Cars93 dataset",
#         col=colors)
# legend(x="topright",                # location for legend
#        title="Drivetrain",          # title for legend
#        rownames(table(cr$DriveTrain) ), # names in legend
#        fill=colors)                     # colors for legend
