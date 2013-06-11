# histogram-Cars93.R

library(MASS)
cr = Cars93

# ---------------------------------------------------------------
# histogram: how many examples in the dataset fall into each "bin"
#   of a fixed size. 
#   - need to: figure out sensible bin sizes (R uses defaults)
#   - x axis must have numeric values. Otherwise you see errors like this:
#       > hist(cr$Origin)
#       Error in hist.default(cr$Origin) : 'x' must be numeric
# ---------------------------------------------------------------

# ---- histograms and RPM data ----

# RPM (revs per minute at maximum horsepower).

# what can we say about the RPM column in our dataset?
table(cr$RPM)
summary(cr$RPM)

# extract the RPM data into a vector
rpms = cr$RPM
xname="engine RPM"

# default bin algorithm is:
hist(rpms, xlab=xname, main=paste("histogram of",xname,"default binning"),
     col="grey")

# R's named algorithms for determining binning. They come up with same answer!
# par(mfrow=c(1,2))
# hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=Scott"), breaks="Scott", col="grey")
# hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=FD"), breaks="FD", col="grey")
# par(mfrow=c(1,1), pch=1)

# ----------- Playing with the binning: -------------

# (suggested) number of bins for the histogram:
par(mfrow=c(2,4))
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=1"), breaks=1, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=2"), breaks=2, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=5"), breaks=5, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=10"), breaks=10, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=20"), breaks=20, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=50"), breaks=50, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=75"), breaks=75, col="grey")
hist(rpms, xlab=xname, main=paste("histogram of",xname, ", breaks=100"), breaks=100, col="grey")
par(mfrow=c(1,1), pch=1)

# how do we decide what bin size was most useful?

# --------------  experiment with bin size: define a function: ----------------

rpmHist <- function(bins) {
  hist(Cars93$RPM, 
       xlab=xname, 
       main=paste("histogram of",xname, ", breaks=",bins), 
       col="grey",
       breaks=bins)
}

# # Now call the function...
# # make 2x4 = 8 plots on one page:
# par(mfrow=c(2,4))
# 
# # create a vector of bin sizes to try:
# binvec = c(1,2,5,10,20,50,75,100)
# 
# # now "loop" over 8 possible bin sizes, plotting each:
# for (bin in binvec) {
#   rpmHist(bin)
# }
# # set plots per page back to default:
# par(mfrow=c(1,1), pch=1)

# --------- a more general bin size experiment: ----------

# for purposes of locating best breaks for the cols below...
doHist <- function(bins, colnum) {
  hist(cr[,colnum], 
       col="grey",
       xlab=colnames(cr)[colnum], 
       main=paste("histogram of",colnames(cr)[colnum], ", breaks=",bins), 
       breaks=bins)
}

tryBins <- function(colnum) {
  par(mfrow=c(2,4))
  binvec = c(8,10,12,15,18,20,25,50)
  for (bin in binvec) {
    doHist(bin, colnum)
  }
  par(mfrow=c(1,1), pch=1)
}

# # Now call the function...
# # The indices of some columns we'd like to try for bin size:
# hcols = c(12,13,19,20,22,25)
# for (co in hcols) {
#   tryBins(co)
# }

# ----- Compare histograms to kernel density plots: --------

# Horsepower
par(mfrow=c(1,3))
hist(cr$Horsepower, xlab="Max Horsepower", col="green", breaks=15) # col 13; breaks 15 or 18
hist(cr$Horsepower, col="green")
plot(density(cr$Horsepower))

# Wheelbase
par(mfrow=c(1,3))
hist(cr$Wheelbase, xlab="Vehicle Wheelbase/in.", col="orange", breaks=10) # 20; breaks 10 or 12
hist(cr$Wheelbase, xlab="Vehicle Wheelbase/in.", col="orange", breaks=12) # 20; breaks 10 or 12
plot(density(cr$Wheelbase))

# Engine Size (displacement)
par(mfrow=c(1,2))
hist(cr$EngineSize, xlab="Engine Size/liters", col="blue", breaks=15) # col 12; breaks 12
plot(density(cr$EngineSize))

# # Vehicle weight
# #hist(cr$Weight, xlab="Weight", col="red", breaks=15) # 25; breaks 15 or 18
# hist(cr$Weight, col="red", xlab="Weight")
# plot(density(cr$Weight))

# Vehicle Length
hist(cr$Length, xlab="Vehicle Length/in.", col="yellow", breaks=10) # 19; breaks 10 or 12
plot(density(cr$Length))

# # Vehicle Turn Circle
# hist(cr$Turn.circle, xlab="Turning circle/ft.", col="purple", breaks=8) # 22
# plot(density(cr$Turn.circle))
# par(mfrow=c(1,1))

# -------------- comparing groups: kernel density ------------------

# Compare MPG distributions for cars with different numbers of cylinders
library(sm) # need a special library, "Smoothing methods for...density estimation"

par(mfrow=c(1,2))

# # one of our values is string: make "rotary" = "8" for our purposes:
# crkd = cr;
# crkd[cr$Cylinders=="rotary", "Cylinders"] = "8";
# 
# # Same comparison plot, for highway:
# # plot the densities for the cylinder numbers:
# sm.density.compare(crkd$MPG.highway, as.integer(crkd$Cylinders), xlab="MPG, highway")
# title(main="Highway MPG Distribution by # Vehicle Cylinders")
# 
# # add legend to indicate identities of line colors
# cl = levels(factor(crkd$Cylinders))
# #legend(x="topright", colfill, fill=rainbow(length(colfill))) # JMS: pin legend to top right
# # add legend 
# colfill<-c(2:(2+length(cl)))
# legend(x="topright", cl, fill=colfill) 
# 
# # -------
# 
# # plot the densities for the cylinder numbers:
# sm.density.compare(crkd$MPG.city, as.integer(crkd$Cylinders), xlab="MPG, city")
# title(main="City MPG Distribution by # Vehicle Cylinders")
# 
# # add legend to indicate identities of line colors
# cl = levels(factor(crkd$Cylinders))
# #legend(x="topright", colfill, fill=rainbow(length(colfill))) # JMS: pin legend to top right
# # add legend 
# colfill<-c(2:(2+length(cl)))
# legend(x="topright", cl, fill=colfill) 

# ------------------------------

# compare MPGs for different transmissions: kernel density plots

# plot the densities:
sm.density.compare(cr$MPG.highway, as.integer(cr$Man.trans.avail), xlab="MPG, highway")
title(main="Highway MPG Distribution by Man.trans.avail")

# add legend to indicate identities of line colors
cl = levels(factor(cr$Man.trans.avail))
colfill<-c(2:(2+length(cl)))
legend(x="topright", cl, fill=colfill) 

# ---- without sm library: ---
# use same x and y limits in each plot
par(mfrow=c(1,1))

# x and y limits are found by experimentation:
yl=c(0,0.055)
xl=c(15,55)

# Subset the MPG.highway column on whether the Man.trans is available or not:
manTrans =   cr$MPG.highway[which(cr$Man.trans.avail=="Yes")]
noManTrans = cr$MPG.highway[which(cr$Man.trans.avail=="No")]

# weight each point according to the prevalence of its group in the dataset
lm = length(manTrans)
ln = length(noManTrans)
len = lm+ln

# now plot one subset (no man trans):
plot(density(noManTrans, weights=rep(1/len,ln)),
     col="blue",
     main="Highway MPG Distribution by Man.trans.avail",
     xlab="MPG, highway", 
     ylim=yl,
     xlim=xl)

# do the overplotting with the other subset
lines(density(manTrans, weights=rep(1/len,lm)),
      col="red",
      ylim=yl,
      xlim=xl)

grid(col="grey") # add a grid

# add a legend to identify each line clearly
legend(x="topright",
       title="Manual trans. available?",
       c("No","Yes"),
       fill=c("blue","red"))


# ---

# Same comparison plot, for city MPG:
# plot the densities:
sm.density.compare(cr$MPG.city, as.integer(cr$Man.trans.avail), xlab="MPG, city")
title(main="City MPG Distribution by Man.trans.avail")

# add legend to indicate identities of line colors
cl = levels(factor(cr$Man.trans.avail))
colfill<-c(2:(2+length(cl)))
legend(x="topright", cl, fill=colfill) 

# ----------------------------------------

# compare MPGs for different drivetrains: kernel density plots

# plot the densities:
sm.density.compare(cr$MPG.highway, as.integer(cr$DriveTrain), xlab="MPG, highway")
title(main="Highway MPG Distribution by Drivetrain")

# add legend to indicate identities of line colors
cl = levels(factor(cr$DriveTrain))
colfill<-c(2:(2+length(cl)))
legend(x="topright", cl, fill=colfill) 

# compare MPGs for drivetrain
# plot the densities:
sm.density.compare(cr$MPG.city, as.integer(cr$DriveTrain), xlab="MPG, city")
title(main="City MPG Distribution by Drivetrain")

# add legend to indicate identities of line colors
cl = levels(factor(cr$DriveTrain))
colfill<-c(2:(2+length(cl)))
legend(x="topright", cl, fill=colfill) 

# ---- without sm library: ---
# use same x and y limits in each plot
par(mfrow=c(1,1))

# x and y limits are found by experimentation:
yl=c(0,0.06)
xl=c(10,57)

# Subset the MPG.highway column on whether the Man.trans is available or not:
fourWD =   cr$MPG.highway[which(cr$DriveTrain=="4WD")]
front =   cr$MPG.highway[which(cr$DriveTrain=="Front")]
rear =   cr$MPG.highway[which(cr$DriveTrain=="Rear")]

# weight each point according to the prevalence of its group in the dataset
l4 = length(fourWD)
lf = length(front)
lr = length(rear)
len = l4+lf+lr

# now plot one subset (no man trans):
plot(density(fourWD, weights=rep(1/len,l4)),
     col="blue",
     main="Highway MPG Distribution by Drivetrain",
     xlab="MPG, highway", 
     ylim=yl,
     xlim=xl)

# do the overplotting with the other subset
lines(density(front, weights=rep(1/len,lf)),
      col="red",
      ylim=yl,
      xlim=xl)

# do the overplotting with the other subset
lines(density(rear, weights=rep(1/len,lr)),
      col="darkgreen",
      ylim=yl,
      xlim=xl)

grid(col="grey") # add a grid

# add a legend to identify each line clearly
legend(x="topright",
       title="Drivetrain",
       c("4WD","Front","Rear"),
       fill=c("blue","red","darkgreen"))

