# explore cr8
# looking at crystallization across different proteins: which cocktails are most effective?
# 

# ---------- load dataset -------------

# set current directory
setwd("/home/jsperhac/ccr-office/summer-workshop/2013/project/protein-data/second-iteration/hsw-export")
# load a workspace into the current session
# if you don't specify the path, the cwd is assumed
load("hwi-gen8-3wayclass.RData")


# we create and use cr8, which contains the subset from generation 8's multiweek experiments that 
# produced human-verified crystals. Now we have 3-way classification data as well.

# ------------ HWI protein crystallization data, generation 8, subset by two time points -------------

# let's make a subset of gen 8, 2 timepoints, human-verified crystals
cr8=experiment[experiment$human_crystal==1,]
cr8=factorify(cr8)

# perform merge on sample_id to get p_number (protein number) for labeling and viewing
big=merge(sample, cr8)

# dim(cr8)
# [1] 637  13

#str(cr8)
# 'data.frame':  637 obs. of  13 variables:
# $ sample_id  : Factor w/ 13 levels "4f15c1fc945cdd89340005ae",..: 1 1 1 1 1 1 2 2 2 2 ...
# $ plate_no   : Factor w/ 13 levels "X000009589","X000009591",..: 1 1 1 1 1 1 2 2 2 2 ...
# $ generation : Factor w/ 1 level "8": 1 1 1 1 1 1 1 1 1 1 ...
# $ read_number: Factor w/ 637 levels "X0000095890276200801181232",..: 2 1 5 3 6 4 16 23 13 25 ...
# $ week_number: int  2 2 2 2 2 2 2 2 2 2 ...
# $ cocktail_no: Factor w/ 375 levels "C0003","C0005",..: 296 350 324 373 287 374 312 164 187 169 ...
# $ cocktail_id: Factor w/ 375 levels "4f15c1c0eeaabc8234002a00",..: 296 350 324 373 287 374 312 164 187 169 ...
# $ date       : Factor w/ 317 levels "2008-01-18 12:17:00",..: 4 5 2 3 1 3 13 7 12 6 ...
# $ image_url  : Factor w/ 637 levels "http://xtuition.ccr.buffalo.edu/image-data/X000009589/X000009589200801181215/X0000095890276200801181232.jpg",..: 2 1 5 3 6 4 16 23 13 25 ...
# $ human_crystal : int  1 1 1 1 1 1 1 1 1 1 ...
# $ class3_crystal: num  0.464 0.439 0.448 0.451 0.445 ...
# $ class3_clear  : num  0.0948 0.0943 0.0742 0.0815 0.107 ...
# $ class3_other  : num  0.442 0.467 0.478 0.467 0.448 ...

#unique(cr8$week_number)
# [1] 2 5

#table(cr8$week_number)
# wow: crystallized proteins for each of the weeks for this subset:
#   2   5 
# 243 394 

# there are some crystals in each time point, and apparently some multiple crystallizations 
# for some cocktails. 
#max(table(cr8$cocktail_no))
# 5

# # there are also 4's, etc. How many?
# sum(table(cr8$cocktail_no)>1)
# # 192, wow
# sum(table(cr8$cocktail_no)>2)
# # 51, wow
# sum(table(cr8$cocktail_no)>3)
# # 16, not bad
# sum(table(cr8$cocktail_no)>4)
# # 3
# sum(table(cr8$cocktail_no)>5)
# # 0, good (ensures my assumptions are checking out ok)
# 
# # we will want to investigate the cocktails with 3, 4, 5 crystallizations!! and the proteins...
# sum(table(cr8$cocktail_no)==1)
# # 183, wow
# sum(table(cr8$cocktail_no)==2)
# # 141, wow
# sum(table(cr8$cocktail_no)==3)
# # 35, not bad
# sum(table(cr8$cocktail_no)==4)
# # 13
# sum(table(cr8$cocktail_no)==5)
# # 3, good


#ct=table(cr8$cocktail_no) # it's a vector with names attached

cocktailCrCount <- function(d) {
  cmax <- max(table(d$cocktail_no))
  for (i in 1:cmax) {
    print(paste("Found",sum(table(d$cocktail_no)==i),"cocktails that crystallized", i, "proteins"))
  }      
}

# looking at crystallization rates for the proteins subjected to generation 8 cocktails:
cocktailCrCount(cr8)
# [1] "Found 183 cocktails that crystallized 1 proteins"
# [1] "Found 141 cocktails that crystallized 2 proteins"
# [1] "Found 35 cocktails that crystallized 3 proteins"
# [1] "Found 13 cocktails that crystallized 4 proteins"
# [1] "Found 3 cocktails that crystallized 5 proteins"

# the next questions are: any overlap in the cocktails? in the weeks? how related are the proteins?

# list the cocktails that crystallized <n> proteins
# arguments: the crystallized dataframe (derived from experiments), and n, number of proteins
cocktailCrList <- function(d, n) {
  cmax <- max(table(d$cocktail_no))
  for (i in 1:cmax) {
    print(paste("Found",sum(table(d$cocktail_no)==n),"cocktails that crystallized", i, "proteins"))
  }      
}

# ---------------------------------------------------


# now:
tcn=table(cr8$cocktail_no)
# a table is like a vector whose elements have names--the names are the cocktail_no.

# find the cocktail name(s) which crystallized more than 4 proteins
f=(tcn==5)
five=names(which(f==TRUE))
# the following crystallized 5 proteins:
# [1] "C0335" "C0424" "C0791"

pfive = cr8[cr8$cocktail_no %in% five,c("sample_id","week_number","read_number","cocktail_no")]
pfive= factorify(pfive)

# sample_id week_number                read_number cocktail_no
# 19  4f15c1fc945cdd89340005b0           2 X0000095910637200801181356       C0424
# 84  4f15c1fc945cdd89340005db           2 X0000096980715200802151330       C0335
# 122 4f15c1fc945cdd89340005e6           2 X0000097590234200803071328       C0791
# 153 4f15c1fc945cdd89340005eb           2 X0000097640637200803071554       C0424
# 158 4f15c1fc945cdd89340005eb           2 X0000097640234200803071559       C0791
# 159 4f15c1fc945cdd89340005eb           2 X0000097640715200803071553       C0335
# 243 4f15c1fc945cdd8934000610           2 X0000098110715200804111055       C0335
# 274 4f15c1fc945cdd89340005b0           5 X0000095910234200802081059       C0791
# 313 4f15c1fc945cdd89340005b0           5 X0000095910637200802081054       C0424
# 454 4f15c1fc945cdd89340005e6           5 X0000097590234200803280935       C0791
# 467 4f15c1fc945cdd89340005eb           5 X0000097640234200803281130       C0791
# 484 4f15c1fc945cdd89340005eb           5 X0000097640715200803281123       C0335
# 499 4f15c1fc945cdd89340005eb           5 X0000097640637200803281124       C0424
# 589 4f15c1fc945cdd8934000610           5 X0000098110637200805021133       C0424
# 619 4f15c1fc945cdd8934000610           5 X0000098110715200805021132       C0335

# find the sample_ids and weeks for each of the "five":
#                          2 5
# 4f15c1fc945cdd89340005b0 1 2
# 4f15c1fc945cdd89340005db 1 0
# 4f15c1fc945cdd89340005e6 1 1
# 4f15c1fc945cdd89340005eb 3 3
# 4f15c1fc945cdd8934000610 1 2

table(pfive$sample_id,pfive$cocktail_no)
#                           C0335 C0424 C0791
# 4f15c1fc945cdd89340005b0     0     2     1
# 4f15c1fc945cdd89340005db     1     0     0
# 4f15c1fc945cdd89340005e6     0     0     2
# 4f15c1fc945cdd89340005eb     2     2     2
# 4f15c1fc945cdd8934000610     2     1     0

counts=table(pfive$cocktail_no,pfive$sample_id) 
colors=rainbow(length(counts))      
title="Protein crystallization Distribution with sample id and cocktail, Generation 8"  
barplot(counts, 
        main=title,
        cex.axis=0.4,
        #las=2,                
        xlab="Sample Id", 
        ylab="crystallization count",
        col=colors)    
legend(x="topright",                # location for legend
       title="Cocktail No",          # title for legend
       rownames(table(pfive$cocktail_no) ), # names in legend
       fill=colors)                     # colors for legend

# counts=table(pfive$cocktail_no,pfive$week_number) 
# colors=rainbow(length(counts))      
# title="Protein crystallization Distribution with week number and cocktail, Generation 8"  
# barplot(counts, 
#         main=title,
#         #cex.axis=0.4,
#         #las=2,                
#         xlab="week number", 
#         ylab="crystallization count",
#         col=colors)    
# legend(x="topright",                # location for legend
#        title="Cocktail No",          # title for legend
#        rownames(table(pfive$cocktail_no) ), # names in legend
#        fill=colors)                     # colors for legend

counts=table(pfive$week_number,pfive$cocktail_no) 
colors=rainbow(length(counts))      
title="Protein crystallization Distribution with week number and cocktail, Generation 8"  
barplot(counts, 
        main=title,
        #cex.axis=0.4,
        #las=2,                
        xlab="cocktail number", 
        ylab="crystallization count",
        col=colors)    
legend(x="topright",                # location for legend
       title="Week No",          # title for legend
       rownames(table(pfive$week_number) ), # names in legend
       fill=colors)                     # colors for legend

# -----------

f=(tcn==4)
four=names(which(f==TRUE))
#  [1] "C0260" "C0267" "C0295" "C0312" "C0323" "C0336" "C0406" "C0440" "C0513" "C0596" "C1191" "C1193" "C1195"
pfour = cr8[cr8$cocktail_no %in% four,c("sample_id","week_number","read_number","cocktail_no")]
pfour=factorify(pfour)

table(pfour$sample_id,pfour$cocktail_no)
#                           C0260 C0267 C0295 C0312 C0323 C0336 C0406 C0440 C0513 C0596 C1191 C1193 C1195
# 4f15c1fc945cdd89340005b0     0     0     0     0     2     0     2     0     0     0     2     2     2
# 4f15c1fc945cdd89340005ba     0     0     0     0     0     2     0     2     0     0     0     0     0
# 4f15c1fc945cdd89340005c6     0     0     0     0     0     0     0     2     0     0     0     0     0
# 4f15c1fc945cdd89340005db     2     2     2     2     0     2     0     0     0     0     0     0     0
# 4f15c1fc945cdd89340005e6     2     1     2     1     0     0     0     0     0     0     0     0     0
# 4f15c1fc945cdd89340005eb     0     0     0     0     0     0     2     0     0     2     2     2     2
# 4f15c1fc945cdd89340005f9     0     1     0     1     2     0     0     0     2     0     0     0     0
# 4f15c1fc945cdd8934000610     0     0     0     0     0     0     0     0     2     2     0     0     0


# ----- Which cocktails achieved these maximum number of crystallizations? In which weeks? ---
# construct a contingency table with cocktail number and week numbers:
t=table(cr8$cocktail_no, cr8$week_number)

# t is a 375 x 2 table, with rownames. The rownames provide the cocktail_no variable.
# The colnames provide the week_number variable.
dim(t)

# find the indices of the rows that have a max # crystallizations in either week:
which(t[,2]==max(t[,2]) | t[,1]==max(t[,1]))
# C0335 C0424 C0791 
#    70   113   237 

# now index into t with these rows to get the weeks. The rownames show the cocktail ids:
t[which(t[,2]==max(t[,2]) | t[,1]==max(t[,1])),]
#	   
#  	     2 5
#  C0335 3 2
#  C0424 2 3
#  C0791 2 3

# TODO JMS: refer to project-cocktails-across-proteins.R

# ----------- Which proteins were crystallized? -----------
# ----- Which cocktails achieved these maximum number of crystallizations? In which weeks? ---
# construct a contingency table with cocktail number and week numbers:
t2=table(cr8$cocktail_no, cr8$sample_id)

# this is a big contingency table, but let's take subsets. Can we index in for the rows we care about?
dim(t2)
# [1] 375  13

# specify the cocktails that had max # crystallizations above:
cocktails5 = c('C0335','C0424','C0791')
t3=t2[cocktails5,]
# now can I index in, excluding the columns that are all zeroes? Yes, using function colSums:
t3[,which(colSums(t3)>0)]

# looking at things another way, 
t3=table(cr8$sample_id)