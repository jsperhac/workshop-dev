# fiddling with the protein dataset: more
# 5 Apr 2013
# Playing a little with the classified protein crystallization data
# What are some interesting questions to ask?
#
#   False/true negatives/positives: how does the classifier do on the samples?
#
#   How do the different cocktails do on the different proteins?
#
#   (Not represented here: compare same samples across timeseries)

#load the package for ggplot
library(ggplot2)

# ----------------------------- Load the dataset -------------------------------------------

# set current directory
setwd("/home/jsperhac/ccr-office/summer-workshop/2013/project/protein-data/second-iteration/hsw-export")
# load a workspace into the current session
# if you don't specify the path, the cwd is assumed
load("hwi-gen8-3wayclass.RData") 

# --- Make a subset of experiment data frame that contains only successful crystallizations. ---

cr8=experiment[experiment$human_crystal==1,]
cr8=factorify(cr8)
cr8 = merge(cr8, sample) # merge on sample_id to get sample (protein) info

exp = merge(experiment, sample)

# ----------------------------------------------------------------------------------------------

# In the experiment table:
# there are 13 different proteins here, two timepoints (week_number 2 and week_number 5) with 1536 wells each.
# Each well has a different cocktail_no.
table(exp$p_number, exp$week_number)

#               2    5
# P000009605 1536 1536
# P000009607 1536 1536
# P000009644 1536 1536
# P000009648 1536 1536
# P000009664 1536 1536
# P000009686 1536 1536
# P000009715 1536 1536
# P000009782 1536 1536
# P000009787 1536 1536
# P000009800 1536 1536
# P000009834 1536 1536
# P000009886 1536 1536
# P000009889 1536 1536

# ----------- to look at the proteins separately, subset the experiments data frame: -----------

# I'm using the last 3 digits of the p_number to identify the protein:
p605 = exp[exp$p_number=='P000009605', ] # p605 = subset(exp, p_number=='P000009605');
p715 = exp[exp$p_number=='P000009715', ] # p715 = subset(exp, p_number=='P000009715');

# ----------------------------------------------------------------------------------------------

# make subsets of those human-verified crystal samples:
c605 = p605[p605$human_crystal==1, ] # 25 crystallized samples here
dim(c605)[1]/dim(p605)[1]            # [1] 0.008138021; less than 1 percent crystallization rate

c715 = p715[p715$human_crystal==1, ] # 102 crystallized samples here
dim(c715)[1]/dim(p715)[1]            # [1] 0.03320312; ~3.3 percent crystallization rate

# -------------------------------------------------

# TODO JMS: poll the classifiers to "assign" crystals; add this to the data frame. (It's an option...)

# -------------------------------------------------

# Q: Write a function that determines the # of crystallized samples and the percent crystallization
# rate for each protein in the dataset.

cryRate = function() {
  prot = levels(exp$p_number)
  ccount = by(exp[,"human_crystal"],ex$p_number,sum) # gets crystallization count per protein
  len = length(levels(exp$cocktail_no)) * length(unique(exp$week_number)) # a scalar
  pct = as.vector(ccount)/len
  
  df = data.frame(p_number=factor(prot),
                  cry_count = as.vector(ccount),
                  cry_pct = pct)
  return(df)
}

crystRate = cryRate()

print(crystRate)
# p_number cry_count      cry_pct
# 1  P000009605        25 0.0081380208
# 2  P000009607        71 0.0231119792
# 3  P000009644        62 0.0201822917
# 4  P000009648         3 0.0009765625
# 5  P000009664        20 0.0065104167
# 6  P000009686         5 0.0016276042
# 7  P000009715       102 0.0332031250
# 8  P000009782        65 0.0211588542
# 9  P000009787        67 0.0218098958
# 10 P000009800        37 0.0120442708
# 11 P000009834        79 0.0257161458
# 12 P000009886        27 0.0087890625
# 13 P000009889        74 0.0240885417

# JMS: note that we have calculated this elsewhere...in a different way.

# ---------------

# how about some boxplots on some of these data?
par(mfrow=c(1,2))
# confirmed-crystal subset
boxplot(formula=class3_crystal~p_number, 
        data=exp[exp$human_crystal==1,], 
        xlab="protein number", 
        ylab="classifier crystal score",
        cex.names=0.6, # x axis ???
        cex.axis=0.6,
        las=2,                   
        col=c("red"))
#title("Classifier crystal score, confirmed crystals by protein number")
title("Confirmed crystals")

# non-crystal subset
boxplot(formula=class3_crystal~p_number, 
        data=exp[exp$human_crystal==0,], 
        xlab="protein number", 
        ylab="classifier crystal score",
        cex.names=0.6, # x axis ???
        cex.axis=0.6,
        las=2,                   
        col=c( "darkblue"))
#title("Classifier crystal score, confirmed non-crystals by protein number")
title("Confirmed non-crystals")
par(mfrow=c(1,1), pch=1)
# Note that the scales are different. Go back and enforce same scale for both plots.

# Overplot one on the other: use 'add=TRUE'. 
# Change whisker, outlier, and box outline color using 'border'.

# non-crystal subset
boxplot(formula=class3_crystal~p_number, 
        data=exp[exp$human_crystal==0,], 
        xlab="protein number", 
        ylab="classifier crystal score",
        cex.names=0.6, # x axis ???
        cex.axis=0.6,
        las=2,                   
        col="darkblue", # box fill color
        border="blue")  # box outline color
#title("Classifier crystal score, confirmed non-crystals by protein number")
title("Classifier crystal scores by protein number")

# overplot the confirmed crystals on the same plot:
# confirmed-crystal subset
boxplot(formula=class3_crystal~p_number, 
        data=exp[exp$human_crystal==1,], 
        xlab="", # suppress xlabels
        ylab="", # suppress ylabels
        #cex.names=0.6, # x axis ???
        #cex.axis=0.6,
        #las=2,
        names="", # suppress x and y axis names
        add = TRUE, # add this plot to the existing one...
        col="red",
        border="darkred")

# add a legend to identify the two subsets in the plot:
legend(x="bottomright",               # location for legend
       title="Expert classification", # title for legend
       c("Non-crystal","Crystal"),  # names in legend
       fill=c("darkblue","red"))    # colors for legend



# based on these figures, which proteins would you like to look into further? Which ones
# are especially easy or hard to crystallize? On which cases did the classifier do an
# especially good or especially bad job?

# Here's a command we can use: get the same data we just plotted, in a data
# structure, using plot = FALSE:
# non-crystal subset
nonCrystal = boxplot(formula=class3_crystal~p_number, 
                      data=exp[exp$human_crystal==0,], 
                      plot = FALSE)
isCrystal = boxplot(formula=class3_crystal~p_number, 
                      data=exp[exp$human_crystal==1,], 
                      plot = FALSE)       

# we can get a friendlier output a different way. Maybe use  by() ...

# of interest: P9648 means are quite well separated. Which others?

# -------------

# JMS: This is a kind of bogus question...

# Q: Write a function that determines the range, mean, std, for the three classifications that
# were assigned by the classifier. What kind of groupings are meaningful?

# simplify the input data frame for analysis:
ex <- data.frame(p_number=factor(exp$p_number),
                 week_number=exp$week_number,
                 cocktail_no=factor(exp$cocktail_no),
                 vcrystal=exp$human_crystal, 
                 ccrystal=exp$class3_crystal,
                 cclear=exp$class3_clear,
                 cother=exp$class3_other)

# get the statistical summary for these 
by(ex[,5:7],ex$p_number,summary)
by(ex[,c("ccrystal","cclear","cother")],ex$p_number,summary)

# output structure for "by()" is a list with the grouping column for the rownames. 
means=by(ex[,"ccrystal"],ex$p_number,mean)
mins=by(ex[,"ccrystal"],ex$p_number,min)
maxes=by(ex[,"ccrystal"],ex$p_number,max)
sds=by(ex[,"ccrystal"],ex$p_number,sd)

# now build a dataframe summarizing the classifier's crystal numbers by protein:
ccrystal = data.frame(p_number=factor(rownames(means)),
                      min=as.vector(mins), 
                      mean=as.vector(means),
                      max=as.vector(maxes),
                      sd=as.vector(sds))
# these are exceedingly boring figures. 

# how about by cocktail_no? and by crystal/nocrystal
nocry = ex[ex$vcrystal==0,]; nocry=factorify(nocry)
cry = ex[ex$vcrystal==1,]; cry=factorify(cry)

# test case
# by(ex[,c("ccrystal","cclear","cother")],ex$cocktail_no,summary)

makeDF <- function(ex,factorname) {
  # output structure for "by()" is a list, with the grouping column's values for the rownames. 
  means=by(ex[,factorname],ex$cocktail_no,mean)
  mins=by(ex[,factorname],ex$cocktail_no,min)
  maxes=by(ex[,factorname],ex$cocktail_no,max)
  sds=by(ex[,factorname],ex$cocktail_no,sd)
  
  # now build a dataframe summarizing the classifier's <factorname> numbers by protein.
  # the output from by() calls must be cast to vector:
  dfout = data.frame(p_number=factor(rownames(means)),
                        min=as.vector(mins), 
                        mean=as.vector(means),
                        max=as.vector(maxes),
                        sd=as.vector(sds))
}

ccrystal0 <- makeDF(nocry,"ccrystal")
ccrystal1 <- makeDF(cry,"ccrystal")

# ok, but is it legitimate??
colMeans(ccrystal1[2:5],na.rm=TRUE)
# min       mean        max         sd 
# 0.43253267 0.43895814 0.44497200 0.01508436 

colMeans(ccrystal0[2:5])
# min       mean        max         sd 
# 0.36666016 0.41573666 0.46130062 0.02525931 

# --------------------------------------

# TODO: below is from earlier...take another look.

# we do know that the same cocktails are used in each plate:
table(exp$cocktail_no) # freq of 26 for each cocktail. This is 13x2, 13 proteins, two weeks.
# ok, why such different crystallization behavior between these two protein? 
# Hmmm...these proteins must be very different. Can we learn something?

# how did the classifier classify these human-verified crystals?

# for protein 605:
c605[,c('class3_crystal','class3_clear','class3_other')]

# 50+1 in 70 classified correctly by classifier (72.9%)
table(vc6$class_10way)
# clear        crystal          phase         precip precip_crystal    precip_skin 
#     5             50              7              4              1              3 
t6=table(vc6$class_10way)
(subset(t6,names(t6)=="crystal")+subset(t6,names(t6)=="precip_crystal"))/dim(vc6)[1]
# 0.7285714 hits

# misses (e.g. human classified as crystal, machine as something else) look like this
# (JMS excluded "precip_crystal" by hand here...)
subset(t6,names(t6)!="crystal")/dim(vc6)[1]
# clear          phase          precip         precip_skin 
# 0.14285714     0.81428571     0.15714286     0.08571429 

# and for protein 9:

# 4 in 6 (66.67%) are correctly classified as crystal by the classifier:
table(vc9$class_10way)
# clear        crystal          phase         precip precip_crystal    precip_skin 
#     0              4              0              0              0              2 
t9=table(vc9$class_10way)
(subset(t9,names(t9)=="crystal")+subset(t9,names(t9)=="precip_crystal"))/dim(vc9)[1]
# 0.6666667 

# OK, that was hits; shall we go for different kinds of misses?
# misses (e.g. human classified as crystal, machine as something else) look like this
# (JMS excluded "precip_crystal" by hand here...)
subset(t9,names(t9)!="crystal")/dim(vc9)[1]
#     clear          phase         precip     precip_skin 
# 0.0000000      0.0000000      0.0000000     0.3333333 

# -------------------------


# foreign key, primary key, image name, and classifier assignment on human-verified 
# crystal samples:
bvc6 <- data.frame(vc6$plate_no, vc6$read_number, vc6$image_url, vc6$class_10way)
bvc9<- data.frame(vc9$plate_no, vc9$read_number, vc9$image_url, vc9$class_10way)



# ---- data points that are not really crystal (and their autoclassification): P6 ----
nc6=subset(p6,is.na(p6$verified_crystal))
tnc6=table(nc6$class_10way)
#         clear        crystal          phase         precip precip_crystal    precip_skin 
#           219            470            355            348              5             69 

# wrongly classified as crystal
subset(tnc6,names(tnc6)=="crystal")

 # correctly classified as non crystal
subset(tnc6,names(tnc6)!="crystal")
        
# stuff that is not really a crystaL, but the classifier thinks it is:
sum(subset(tnc6,names(tnc6)=="crystal"))/dim(nc6)[1]
#       [1] 0.3206003

# stuff that is not really a crystaL, and the classifier got it as such:      
sum(subset(tnc6,names(tnc6)!="crystal"))/dim(nc6)[1]
 #       [1] 0.6793997
       
# here's an interesting plot that I'd like to see subset by samples that are autoclassified as crystal
# rather than as scores!
       
# p6 crystal score, colored by verified crystal:      	
 ggplot(p6, aes(crystal)) + 
         geom_histogram(aes(fill = factor(verified_crystal))) + ggtitle("000009786 crystal scores, shaded by verified crystal assignment")
      
# ----------------------------------------------------------------------------------------------


# Note that there are 1536 cocktails used per experiment (or plate, or protein). With a larger number of
# proteins (plates, experiments) in play we can compare successful cocktails (e.g. those that give us crystals
# reliably, for different proteins).
#
# For this small dataset: Are there cocktails that crystallize both proteins successfully?

# detail of verified crystals: get primary and foreign keys, cocktail no, and some other stuff.
detailVerifiedCrystal <- function(vc) {
  dvc = data.frame(vc$read_number, 
                 vc$plate_no, 
                 vc$cocktail_no, 
                 vc$verified_crystal, 
                 vc$solution_components, 
                 vc$class_10way);
 return(dvc);
}

dvc6 = detailVerifiedCrystal(vc6);
dvc9 = detailVerifiedCrystal(vc9);

# what are the frequencies with which each cocktail_no crystallizes the protein? 
# use table() command, make the result a data frame:
cn6 = data.frame(table(dvc6$vc.cocktail_no))
cn9 = data.frame(table(dvc9$vc.cocktail_no))
str(cn9)

# example output, unsubsetted vc:
#'data.frame':  1536 obs. of  2 variables:
# $ Var1: Factor w/ 1536 levels "C0001","C0002",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ Freq: int  0 0 0 0 0 0 0 0 0 0 ...

subset(cn9,Freq>1)

# example output, unsubsetted vc:
#      Var1 Freq
# 1101 C1101    2
# 1505 C1505    2
# 1506 C1506    2

# OK, in this (very small) set of two proteins, three cocktails crystallize them both.

#--------------- How did the classifier assign the samples? -------------

# Considerations such as: did it do better with one protein than with another?

# across the whole dataset:
table(experiments$class_10way) 

#         clear        crystal          phase         precip precip_crystal    precip_skin 
#           376           1049            654            694              8            291 

# per protein:

table(p6$class_10way)
#         clear        crystal          phase         precip precip_crystal    precip_skin 
#           224            520            362            352              6             72 

table(p9$class_10way)
#          clear        crystal          phase         precip precip_crystal    precip_skin 
#           152            529            292            342              2            219 

# --------------------------------

# Let's plot some stuff...just for one protein, called here p6:

# with salary data we did:
#ggplot(d, aes(years_exp)) + 
#    		geom_histogram(aes(fill = factor(region)), binwidth=2) + 
#    		facet_grid(~region)
#    	

# p6 crystal score, faceted by different classes:	
ggplot(p6, aes(crystal)) + 
  geom_histogram(aes(fill = factor(class_10way))) + 
  facet_grid(~class_10way)+ ggtitle("X000009786 crystal scores, histograms by class")
# ggsave("p6_crystal_hist_facet_class.png")

# p6 crystal score, colored by different classes:	    	
ggplot(p6, aes(crystal)) + 
  geom_histogram(aes(fill = factor(class_10way)), binwidth=0.0025)  + ggtitle("X000009786 crystal scores, shaded by class")  	
  
# ggsave("p6_crystal_hist_class.png")

# p6 crystal score, colored by verified crystal:	    	
ggplot(p6, aes(crystal)) + 
  geom_histogram(aes(fill = factor(verified_crystal)), binwidth=0.0025) + ggtitle("000009786 crystal scores, shaded by verified crystal assignment")
# ggsave("p6_crystal_hist_verified.png")

# --------- now for different class scores: --------------

# p6 clear score, colored by different classes:	    	
ggplot(p6, aes(clear)) + 
  geom_histogram(aes(fill = factor(class_10way)))  + ggtitle("X000009786 clear scores, shaded by class")  	
# ggsave("p6_clear_hist_class.png")

# p6 precip score, colored by different classes:	    	
ggplot(p6, aes(precip)) + 
  geom_histogram(aes(fill = factor(class_10way)))  + ggtitle("X000009786 precip scores, shaded by class")  	
# ggsave("p6_precip_hist_class.png")

# p6 phase score, colored by different classes:	    	
ggplot(p6, aes(phase)) + 
  geom_histogram(aes(fill = factor(class_10way)))  + ggtitle("X000009786 phase scores, shaded by class")  	
# ggsave("p6_phase_hist_class.png")

# precip_crystal 
# p6 precip_crystal score, colored by different classes:	    	
ggplot(p6, aes(precip_crystal)) + 
  geom_histogram(aes(fill = factor(class_10way)))  + ggtitle("X000009786 precip_crystal scores, shaded by class")  	
# ggsave("p6_precip_crystal_hist_class.png")

# precip_skin
# p6 precip_skin score, colored by different classes:	    	
ggplot(p6, aes(precip_skin)) + 
  geom_histogram(aes(fill = factor(class_10way)))  + ggtitle("X000009786 precip_skin scores, shaded by class")  	
# ggsave("p6_precip_skin_hist_class.png")

# --- range information for classes ---

range(p6$skin)
# [1] 0.0114 0.1502

range(p6$phase_precip)
# [1] 0.006 0.062

range(p6$precip_crystal)
# [1] 0.0476 0.2550

range(p6$clear)
# [1] 0.0296 0.2604

range(p6$phase_crystal)
# [1] 0.0168 0.0904

range(p6$precip)
# [1] 0.0732 0.3186

range(p6$phase)
# [1] 0.0732 0.2494

range(p6$precip_skin)
# [1] 0.0450 0.2508

range(p6$crystal)
# [1] 0.0642 0.2666

range(p6$garbage)
# [1] 0.0042 0.1144
