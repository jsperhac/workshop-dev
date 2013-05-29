# 28 Mar 2013
# Playing a little with the classified protein crystallization data

# Notes about data presentation: the classifier's winning classification is stored in column class_10way.
# One possible outcome is "crystal", another is "precip_crystal". 
#
# Human-verified crystal samples are notated with entry of 1 in the column "verified_crystal". All other 
# samples are marked NA in this column.
#
# Note that there are 1536 cocktails used per experiment (or plate, or protein). With a large number of
# proteins (plates, experiments) in play we can compare successful cocktails (e.g. those that give us crystals
# reliably, for different proteins).

# What does a human verified crystal look like? There are image urls in the dataset.

#load the package for ggplot
library(ggplot2)

# ----------------------------- Load the dataset -------------------------------------------

# Load data (read.delim triggered by picking "Import Dataset" off of RStudio's gui). User gets prompted for details.
filepath <- "~/ccr-office/summer-workshop/2013/project/protein-data/experiments.tsv"
experiments <- read.delim(filepath)

# alternately, all on the cmd line, specify that header exists, and separation is by tabs:
filepath2 <- "~/ccr-office/summer-workshop/2013/project/protein-data/samples.tsv"
samples = read.table(filepath2, header=TRUE, sep="\t");

# ----------------------------------------------------------------------------------------------

# there are two different proteins here, with 1536 wells each: 
table(experiments$plate_no)

#X000009589 X000009786 
#      1536       1536 

# ----------- to look at the proteins separately, subset the experiments data frame: -----------

# I'm using the last digit of the plate no to identify the protein:
p9 = subset(experiments, plate_no=='X000009589');
p6 = subset(experiments, plate_no=='X000009786');


# ----------------------------------------------------------------------------------------------

# make a subset of those human-verified crystal samples (note: this is whole dataset, not per-protein):
vc <- subset(experiments, verified_crystal==1)

# how many are in the subset? 
dim(vc)
# 76 human-verified crystals

# how did the classifier classify these human-verified crystals?
table(vc$class_10way)

# clear        crystal          phase         precip precip_crystal    precip_skin 
#     5             54              7              4              1              5 

# foreign key, primary key, image name, and classifier assignment on human-verified 
# crystal samples:
bvc <- data.frame(vc$plate_no, vc$read_number, vc$image_url, vc$class_10way)

# how many did the classifier misclassify as crystal?
mc <- subset(experiments, verified_crystal!=1 & (class_10way=='crystal' | class_10way=='precip_crystal'))
dim(mc)
mc <- subset(mc, class_10way=='crystal')

mc <- subset(experiments, (is.na(verified_crystal) & (class_10way=='crystal' | class_10way=='precip_crystal')))
# there are 1002 of these

# number of samples human-verified as non-crystal: 2996
dim(subset(experiments, (is.na(verified_crystal))))
# 2996 

# number of samples classifier classified as crystal: 1049
dim(subset(experiments, (class_10way=='crystal')))
# 1049 

# number of samples classifier correctly classified as crystal: 54
dim(subset(experiments, (class_10way=='crystal' & verified_crystal==1)))
#  54

# number of samples classifier incorrectly classified as crystal: 995
dim(subset(experiments, (class_10way=='crystal' & is.na(verified_crystal))))
#  995

# number of samples classifier incorrectly classified as precip-crystal: 7 (1 was correct)
dim(subset(experiments, (class_10way=='precip_crystal' & is.na(verified_crystal))))
#  7

# ----------------------------------------------------------------------------------------------

# Note that there are 1536 cocktails used per experiment (or plate, or protein). With a larger number of
# proteins (plates, experiments) in play we can compare successful cocktails (e.g. those that give us crystals
# reliably, for different proteins).
#
# For this small dataset: Are there cocktails that crystallize both proteins successfully?

# detail of verified crystals: get primary and foreign keys, cocktail no, and some other stuff.
dvc = data.frame(vc$read_number, vc$plate_no, vc$cocktail_no, vc$verified_crystal, vc$solution_components, vc$class_10way)

# what are the frequencies with which each cocktail_no crystallizes the protein? 
# use table() command, make the result a data frame:
cn = data.frame(table(dvc$vc.cocktail_no))
str(cn)

#'data.frame':	1536 obs. of  2 variables:
# $ Var1: Factor w/ 1536 levels "C0001","C0002",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ Freq: int  0 0 0 0 0 0 0 0 0 0 ...

subset(cn,Freq>1)
#      Var1 Freq
# 1101 C1101    2
# 1505 C1505    2
# 1506 C1506    2

# OK, in this (very small) set of proteins, three cocktails crystallize them both.

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
geom_histogram(aes(fill = factor(class_10way)))  + ggtitle("X000009786 crystal scores, shaded by class")  	
# ggsave("p6_crystal_hist_class.png")

# p6 crystal score, colored by verified crystal:	    	
ggplot(p6, aes(crystal)) + 
geom_histogram(aes(fill = factor(verified_crystal))) + ggtitle("000009786 crystal scores, shaded by verified crystal assignment")
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
