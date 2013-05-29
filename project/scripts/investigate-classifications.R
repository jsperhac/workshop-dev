# ROC curves with the HWI protein crystallization data
library("pROC")

# first, load and subset the data. We have generation 8, 13 proteins, 2 time points:
# set current directory
setwd("/home/jsperhac/ccr-office/summer-workshop/2013/project/protein-data/second-iteration/hsw-export")
# load a workspace into the current session
# if you don't specify the path, the cwd is assumed
load("hwi-gen8-3wayclass.RData") 

# merge on sample_id to get sample (protein) info
exp = merge(experiment, sample)


# --------------------------------------

# Read about ROC curves; make one for full dataset, then for each protein; make remarks.

# ----- ROC curve of the full exp dataset, Generation 8, 2 time points: -------
fullroc = roc(exp$human_crystal, exp$class3_crystal)

plot.roc( fullroc,
          ylab="Sensitivity (True Positive Rate)",
          xlab="Specificity (1 - False Positive Rate)",
          print.auc = TRUE,
          main='Generation 8 ROC curve: 13 proteins, 2 time points each')

# Try taking the subset of experiment with human_crystal == 1. Create the ROC curve.
# What happens? Why?

# Naturally nothing comes of it when we try to produce a ROC curve with only human_crystal==1:
# cr8=experiment[experiment$human_crystal==1,]
# plot.roc(cr8$human_crystal, cr8$class3_crystal)
# Error in roc.default(x, predictor, plot = TRUE, ...) : 
# No case observation.

# now we can look into this by protein:
# just grab one that looked interesting...there was good separation of the means for 9648
P9648 = exp[exp$p_number=='P000009648',] # subset data frame by protein number; factorify if you like.
rocP9648=roc( P9648[,'human_crystal'],
          P9648[,'class3_crystal'],
          smooth=TRUE)
plot.roc( rocP9648)

# ------------------- ROC curves, by cocktail_no: --------------

# do a ROC curve for an arbitrarily selected cocktail_no:
# C0001 = exp[exp$cocktail_no=='C0001',] # subset data frame by cocktail_no
# plot.roc( C0001[,'human_crystal'],
#           C0001[,'class3_crystal'])

# oops, there's no crystallization achieved from that cocktail in this dataset!
#length(unique(C0001$human_crystal))
# [1]  1 # in other words, only 0s!
#unique(C0001$human_crystal)
# [1]  0

# Let's arbitrarily select a cocktail that successfully crystallized something. Look in cr8:
cr8=experiment[experiment$human_crystal==1,]
levels(cr8$cocktail_no)

# ... let's pick C0003
# do a ROC curve for an arbitrarily selected cocktail_no:
C0003 = exp[exp$cocktail_no=='C0003',] # subset data frame by cocktail_no
rocC0003 = roc( C0003[,'human_crystal'],
                C0003[,'class3_crystal'],
                smooth=TRUE) # Area under the curve: 0.8229
# Error in smooth.roc.binormal(roc, n) : 
# ROC curve not smoothable (not enough points).
plot.roc(rocC0003)

# make it a function; call it for some of our interesting cocktails.
# can I output the area under the curve and get the best-performing one?
rocCocktailPlot = function(cNo) {
  cSubset = exp[exp$cocktail_no==cNo,] # subset data frame by cocktail_no
  plot.roc( cSubset[,'human_crystal'],
            cSubset[,'class3_crystal'])
}

rocCocktailPlot('C0335') # Area under the curve: 0.6381 (not so great!)

# make it a function; output the area under the curve and get the best-performing one
rocCocktail = function(cNo) {
  cSubset = exp[exp$cocktail_no==cNo,] # subset data frame by cocktail_no
  rocObj = roc( cSubset[,'human_crystal'],
                cSubset[,'class3_crystal'])
  # get area under the curve, number of cases, number of controls for this cocktail_no
  if (as.numeric(length(rocObj$cases)) > 2) {
    retval = c(as.numeric(rocObj$auc), 
             as.numeric(length(rocObj$cases)), 
             as.numeric(length(rocObj$controls)))
    names(retval) = c("areaUnderCurve", "numCases", "numControls")
    return(retval)
  }
}
rocCocktail('C0335') # Area under the curve: 0.6381 (not so great!)

# no...
# by(exp, exp$cocktail_no, rocCocktail)

#length(levels(exp$cocktail_no))

# no....again, need to specify known cocktails that achieved crystals:
#vapply( levels(exp$cocktail_no), rocCocktail)

# lout = lapply( levels(cr8$cocktail_no), rocCocktail) # returns a list.
sout = sapply( levels(cr8$cocktail_no), rocCocktail) # returns a vector, with names.
names(sout)

# which cocktails, and how many, have an area under the curve > 0.96? Pick one and plot its ROC.
names(sout[sout>0.96])
length(sout[sout>0.96]) # 39 of them!!

# what's with these 1's? Does it just mean that the number of times anything crystallized
# is extremely small? YES!!

# for each cocktail we have 26 experiments (13 proteins, 2 weeks). If only one
# crystallized, how well can we possibly do? In a way, we should only care about
# ROC curves for cocktails with more crystallizations...? Check to verify this suspicion.

# dim(exp[exp$cocktail_no=='C0022',])
# [1] 26 26

# sout[sout>0.96]
# C0008     C0027     C0065     C0124     C0162     C0243     C0269     C0279     C0281     C0288 
# 0.9791667 1.0000000 1.0000000 1.0000000 0.9791667 1.0000000 1.0000000 1.0000000 1.0000000 1.0000000 
# C0293     C0326     C0361     C0365     C0366     C0383     C0587     C0612     C0669     C0675 
# 1.0000000 1.0000000 1.0000000 0.9800000 1.0000000 1.0000000 1.0000000 0.9791667 1.0000000 1.0000000 
# C0686     C0696     C0701     C0763     C0915     C0917     C0944     C0950     C0985     C0987 
# 1.0000000 1.0000000 1.0000000 1.0000000 0.9791667 1.0000000 1.0000000 1.0000000 0.9791667 0.9895833 
# C1168     C1203     C1224     C1258     C1265     C1280     C1428     C1477     C1505 
# 1.0000000 1.0000000 1.0000000 1.0000000 1.0000000 1.0000000 1.0000000 0.9687500 0.9791667 


# ------------------------ ROC curves by protein -------------------------------


# ROC computation: determien area under the curve, number of cases, number of controls 
# for the specified p_no
rocProtein = function(cNo) {
  cSubset = exp[exp$p_number==cNo,] # subset data frame by p_no
  rocObj = roc( cSubset[,'human_crystal'],
                cSubset[,'class3_crystal'])
  # get area under the curve, number of cases, number of controls for this p_no
  return(  c(as.numeric(rocObj$auc), 
           as.numeric(length(rocObj$cases)), 
           as.numeric(length(rocObj$controls)))
  )
}

# plot roc curves for proteins;
rocProteinPlot = function(cNo, doSmooth) {
  cSubset = exp[exp$p_number==cNo,] # subset data frame by p_no
  rocObj = roc( cSubset[,'human_crystal'],
                cSubset[,'class3_crystal'],
                smooth=doSmooth)
  plot.roc( rocObj,
            ylab="Sensitivity (True Positive Rate)",
            xlab="Specificity (1 - False Positive Rate)",
            print.auc = TRUE,
            main=paste('Generation 8 ROC curve: protein',cNo)
  )
}

# get the auc, numCases, numControls for our 13 proteins. Transform to data frame dfout
vout = vapply( levels(exp$p_number), rocProtein, c(auc=0, numCases=0, numControls=0)) 
vout=t(vout)
dfout=as.data.frame(vout)
dfout$p_number = factor(rownames(dfout))

# notice that: numCases is the number of verified crystallizations
# for the particular protein. numControls is the number of non-crystallizations.

# (rownames)       auc numCases numControls   p_number
# P000009605 0.6930226       25        3047 P000009605
# P000009607 0.6259604       71        3001 P000009607
# P000009644 0.7944566       62        3010 P000009644
# P000009648 0.9253829        3        3069 P000009648
# P000009664 0.6949951       20        3052 P000009664
# P000009686 0.7062602        5        3067 P000009686
# P000009715 0.6928897      102        2970 P000009715
# P000009782 0.8656417       65        3007 P000009782
# P000009787 0.8429409       67        3005 P000009787
# P000009800 0.8240839       37        3035 P000009800
# P000009834 0.7785233       79        2993 P000009834
# P000009886 0.8400170       27        3045 P000009886
# P000009889 0.7777753       74        2998 P000009889

sapply( levels(exp$p_number), rocProteinPlot, doSmooth=TRUE) 

# which ROC curves look most ideal? Least ideal? Why? How many cases (numCases) do each have?
# Can you look at only the AUC (area under the curve)? Do you need to consider numCases as well?
# Try calling it while setting smooth=TRUE and also FALSE
#    9648 looks nice, but only has numCases=3!


# now we can give a threshold above which we'll consider...
dfout[dfout$numCases>75,]
# auc           numCases numControls   p_number
# 0.6928897      102        2970      P000009715
# 0.7785233       79        2993      P000009834

# these have lower AUCs but the number of points is better
aboveThresh75 = as.vector(dfout$p_number[dfout$numCases>75])
sapply(aboveThresh75, rocProteinPlot, doSmooth=FALSE) 

# probably the worst is P...9607, which has AUC 0.626
aboveThresh50 = as.vector(dfout$p_number[dfout$numCases>50])
sapply(aboveThresh50, rocProteinPlot, doSmooth=FALSE) 

# these have high AUCs but the number of points is low
belowThresh10 = as.vector(dfout$p_number[dfout$numCases<10])
sapply(belowThresh10, rocProteinPlot, doSmooth=FALSE) 

# -------------------------------------------------------

# by protein: How do the classifier crystal scores look for the various proteins?

# classifier crystal scores: histogram vs. density plot
par(mfrow=c(1,2))
hist(exp$class3_crystal, xlab="Classifier Crystal Score", col="purple") #, breaks=8) # 22
plot(density(exp$class3_crystal))
par(mfrow=c(1,1))

# plot histogram, density plot of crystal scores, per protein:
histProtein = function(cNo) {
  cSubset = exp[exp$p_number==cNo,] # subset data frame by p_no

    par(mfrow=c(1,2))
    hist(cSubset$class3_crystal, 
         xlab="Classifier Crystal Score", 
         col="green",
         xlim=c(0.30,0.51),
         main=paste("Histogram of Crystal Scores: protein",cNo) 
    )
    plot(density(cSubset$class3_crystal))
    par(mfrow=c(1,1))
}
sapply( levels(exp$p_number), histProtein) 
par(mfrow=c(1,1))


# ---------- Crystal scores distribution by protein: all in one plot -------------------

# plot the densities:
sm.density.compare(exp$class3_crystal, as.integer(exp$p_number), xlab="Classifier Crystal Score")
title(main="Crystal Scores Distribution by Protein")

# add legend to indicate identities of line colors
cl = levels(factor(exp$p_number))
colfill<-c(2:(2+length(cl)))
legend(x="topright", cl, fill=colfill) 

# --------- compare distributions for the different classifications: -----

# this is really weird. Why is the "clear" classification so very low??

#hist(exp$class3_crystal, xlab="Classifier Crystal Score", col="purple") #, breaks=8) # 22
xl=c(0.05,0.55)
yl=c(0,14)

plot(density(exp$class3_crystal),
     col="red",
     xlim=xl, 
     ylim=yl,
     main="Densities of Crystal/Clear/Other classifier scores")
par(new=T)
plot(density(exp$class3_clear),
     col="blue",
     axes=FALSE,
     xlim=xl, 
     ylim=yl,
     main="")
par(new=T)
plot(density(exp$class3_other),
     col="green",
     axes=FALSE,
     xlim=xl, 
     ylim=yl,
     main="")
# add legend to indicate identities of line colors
cl = levels(factor(exp$p_number))
colfill<-c(2:(2+length(cl)))
legend(x="topright", c("crystal","clear","other"), fill=c("red","blue","green")) 

# -------- The all-in-one plot, per protein ---------

# plot histogram, density plot of crystal scores, per protein:
proteinAllPlot = function(cNo, doSmooth) {
  cSubset = exp[exp$p_number==cNo,] # subset data frame by p_no
  
  par(mfrow=c(1,3))
  hist(cSubset$class3_crystal, 
       xlab="Classifier Crystal Score", 
       col="green",
       xlim=c(0.30,0.51),
       main=paste("Histogram of Crystal Scores: protein",cNo) 
  )
  plot(density(cSubset$class3_crystal))
  rocObj = roc( cSubset[,'human_crystal'],
                cSubset[,'class3_crystal'],
                smooth=doSmooth)
  plot.roc( rocObj,
            ylab="Sensitivity (True Positive Rate)",
            xlab="Specificity (1 - False Positive Rate)",
            print.auc = TRUE,
            main=paste('Generation 8 ROC curve: protein',cNo)
  )  
  par(mfrow=c(1,1))
}
sapply( levels(exp$p_number), proteinAllPlot, doSmooth=TRUE) 
par(mfrow=c(1,1))
