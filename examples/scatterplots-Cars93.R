# scatterplots-Cars93.R

library(MASS)
cr = Cars93

# --- Vehicle weight and MPG ---
par(mfrow=c(1,2))
yl = "MPG.city"
xl = "Vehicle Weight/lbs."
plot(formula=MPG.city~Weight, 
     data=cr, 
     xlab=xl, 
     ylab=yl)
fit=lm(cr$MPG.city~cr$Weight) 
abline(fit)
title("MPG city with Vehicle Weight")

yl="MPG.highway"
plot(formula=MPG.highway~Weight, 
     data=cr, 
     xlab=xl, 
     ylab=yl)
fit=lm(cr$MPG.highway~cr$Weight)
abline(fit)
title("MPG highway with Vehicle Weight")
par(mfrow=c(1,1), pch=1)

# --------- Overplotting on a single plot, using points() ----------

# weight and MPG 
# Color the points with "col", and give them a point type with "pch":

# labels for x and y axes:
yl = "MPG"
xl = "Vehicle Weight/lbs."

# plot MPG.city vs. Weight, in blue. 
# pch indicates point type:
plot(formula=MPG.city~Weight, 
     data=cr, 
     xlab=xl, 
     ylab=yl, 
     col="blue", 
     pch=1)

# compute and draw linear fit forMPG.city vs. Weight:
fit=lm(cr$MPG.city~cr$Weight) 
abline(fit, col="blue")
title("MPG with Vehicle Weight")

# overplot MPG.highway vs. Weight, in purple. 
# pch indicates point type:
points(cr$Weight, 
       cr$MPG.highway, 
       col="purple", 
       pch=3)

# compute and draw linear fit for MPG.highway vs. Weight:
fit2=lm(cr$MPG.highway~cr$Weight)
abline(fit2,col="purple")

#title(main="MPG with Vehicle Weight", sub="purple: Highway MPG; blue: City MPG")

# legend shows points and colors for each data type:
legend(x="topright",               
       title="MPG",         
       legend=c("Highway","City"), 
       pch=c(3,1),
       col=c("purple","blue"))          
par(mfrow=c(1,1), pch=1)

# ------------------ scatter plots ------------------

# scatter plots. Note that R labels the axes for you here:

# Wheelbase vs. Length, with regression line:
plot(Wheelbase~Length, data=cr)
title("Vehicle Wheelbase (in) by Length (in)")

# create and draw regression line:
fit2=lm(cr$Wheelbase~cr$Length)
abline(fit2,col="purple")

# ---- Relationship between engine size (displacement) and horsepower ---

# Horsepower vs. Engine Size
# R labels the axes for you here, but let's put units in:
plot(Horsepower~EngineSize, data=cr, xlab="Engine displacement (liters)", ylab="Horsepower (max)")
title("Horsepower with Engine Size")
# Does this suggest a linear relationship? Let's calculate it with a LINEAR MODEL, lm():
fit=lm(cr$Horsepower~cr$EngineSize)
abline(fit)

# ------------------------

# # following are pretty uninspiring/unilluminating. 
# 
# # Max Passengers vs. Weight
# # R labels the axes for you here:
# plot(Passengers~Weight, data=cr)
# title("Max Passengers with Weight")
# # Does this suggest a linear relationship? Let's calculate it with a LINEAR MODEL, lm():
# fit=lm(cr$Passengers~cr$Weight)
# abline(fit)
# 
# # Max Passengers vs. Engine Size
# # R labels the axes for you here:
# plot(Passengers~EngineSize, data=cr)
# title("Max Passengers with EngineSize")
# # Does this suggest a linear relationship? Let's calculate it with a LINEAR MODEL, lm():
# fit=lm(cr$Passengers~cr$EngineSize)
# abline(fit)
# 
# # Max Passengers vs. Horsepower
# # R labels the axes for you here:
# plot(Passengers~Horsepower, data=cr)
# title("Max Passengers with Horsepower")
# # Does this suggest a linear relationship? Let's calculate it with a LINEAR MODEL, lm():
# fit=lm(cr$Passengers~cr$Horsepower)
# abline(fit)
