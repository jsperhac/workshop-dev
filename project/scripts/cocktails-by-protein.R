# The HWI protein crystallization project
# focus: cocktails across various proteins
# 17 May 2013

# Note: JMS should give the students the factorify() function to apply to data frames...

# The intent of these questions is to guide you in your exploration of the dataset, and 
# to help you pose and answer interesting questions. But, you don't have to follow it.

# --------- Load dataset ---------

# set current directory
setwd("/home/jsperhac/ccr-office/summer-workshop/2013/project/protein-data/second-iteration/hsw-export")
# load a workspace into the current session
# if you don't specify the path, the cwd is assumed
load("hwi-gen8-3wayclass.RData") 

# --- Make a subset of experiment data frame that contains only successful crystallizations. ---

cr8=experiment[experiment$human_crystal==1,]
cr8=factorify(cr8)
cr8 = merge(sample, cr8) # merge on sample_id to get sample (protein) info

# use this subset to determine:

# --- How many crystallized proteins were found for each week in the dataset? ---

table(cr8$week_number)
# count of crystallized proteins for each of the weeks for this subset:
#   2   5 
# 243 394 

# -------- Max # of multiple crystallizations by some cocktails ----------

# Were there multiple crystallizations achieved by some cocktails? What was the maximum number
# of crystallizations achieved? How many cocktails crystallized this many proteins?

# this table counts up the number of crystallizations (appearances in the cr8 data frame)
# achieved by each cocktail_no in the experiments dataset.
table(cr8$cocktail_no)

# To answer the question we can look at the largest value in the table (use max()), and the number
# of times that value appears in the table (use sum() and a conditional)

# there are multiple crystallizations for some cocktails. One cocktail_no appears 5x:
max(table(cr8$cocktail_no))
# 5

# In fact, there are 3 such cocktails, that achieve 5 crystallizations:
sum(table(cr8$cocktail_no)==5) 
# equivalent statement is: sum(table(cr8$cocktail_no)==max(table(cr8$cocktail_no)))
# 3

# ------ Which cocktails achieved the maximum number of crystallizations? In which weeks? ------
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

# ------------ Which proteins were crystallized by these 3 cocktails? -----------------

# construct a contingency table with cocktail number and week numbers:
#t2=table(cr8$cocktail_no, cr8$sample_id)
t2=table(cr8$cocktail_no, cr8$p_number)

# this is a big contingency table, but let's take subsets. Can we index in for the rows we care about?
dim(t2)
# [1] 375  13

# specify rows for the cocktails that had max # crystallizations above:
#cocktails5 = c('C0335','C0424','C0791') is just the same as: "max crystallizations-cocktails":
maxcryc=rownames(t[which(t[,2]==max(t[,2]) | t[,1]==max(t[,1])), ])
# maxcryc
# [1] "C0335" "C0424" "C0791"
t3=t2[maxcryc,]

# now index into t3, excluding the columns that are all zeroes. Using function colSums():
t3[,which(colSums(t3)>0)]
#       P000009607 P000009715 P000009782 P000009787 P000009889
# C0335          0          1          0          2          2
# C0424          2          0          0          2          1
# C0791          1          0          2          2          0

# here are the p_numbers that were involved:
maxcryp = colnames(t3[,which(colSums(t3)>0)])
# [1] "P000009607" "P000009715" "P000009782" "P000009787" "P000009889"

# Now, break down the max crystallizations achieved, and the identities of the proteins
# crystallized, by week number.

# use a multidimensional table:
t4=table(cr8$cocktail_no, cr8$p_number, cr8$week_number)
dim(t4)
# [1] 375  13   2

# then subset it by the cocktails and proteins we found:
tsub=t4[maxcryc,maxcryp,]
dim(tsub)
# [1] 3 5 2

tsub[,,1] # == tsub[,,'2'] == week 2
# P000009607 P000009715 P000009782 P000009787 P000009889
# C0335          0          1          0          1          1
# C0424          1          0          0          1          0
# C0791          0          0          1          1          0

tsub[,,2] # == tsub[,,'5'] == week 5
# P000009607 P000009715 P000009782 P000009787 P000009889
# C0335          0          0          0          1          1
# C0424          1          0          0          1          1
# C0791          1          0          1          1          0

# ----------- Frequency of crystallization, 13 proteins --------------

# What's the story with protein sample_id==4f15c1fc945cdd89340005eb? 
# Note: this is p_number=P000009889.
# It is crystallized by all 3 of these cocktails, BOTH WEEKS.
# Was it crystallized by any other cocktails?

# looks like it was crystallized 67 times
easyp=cr8[cr8$p_number=="P000009889" & cr8$human_crystal==1,]
dim(easyp)
# [1] 67 13

# was any other protein crystallized so many times? Yup, some more...some a lot less.
st=table(cr8$p_number)
max(st)
# [1] 102
dim(st)
# [1] 13
st

# P000009605 P000009607 P000009644 P000009648 P000009664 P000009686 P000009715 P000009782 P000009787 P000009800 
# 25         71         62          3         20          5        102         65         67         37 
# P000009834 P000009886 P000009889 
# 79         27         74 

# This makes a great barplot, broken down by week_number. See the plots file.

# Additionally: may want to do plots of the cocktails that crystallized the other proteins! There
# will be lots of 1's, so break down by tables.

# for each cr8$p_number, find cr8$week_number and cr8$cocktail_no
pn = levels(cr8$p_number)
for (i in 1:length(pn)) {
  print(paste("protein:",pn[i],"crystallized:"))
  print(cr8[cr8$p_number==pn[i], c("week_number","cocktail_no")])
}

# Note for instance that protein 9648 looks fairly unusual. Only two cocktails crystallized it,
# and one worked on both weeks:

# [1] "protein: P000009648 crystallized:"
# week_number cocktail_no
# 159           2       C1083
# 160           5       C1082
# 161           5       C1083

# really this is the same as:
scr8=cr8[,c("p_number","week_number","cocktail_no")]

# now do some cross-tabs...
table(scr8$p_number,scr8$cocktail_no)


# ----------------------------------------------------------------------

# TODO:

# List the number of crystallizations achieved for each number up to the maximum,
# (the cocktails that were used, and the proteins they crystallized.)
# NOTE: Should it be possible to write functions that perform the above for other 
# numbers of crystallizations? If so, it's reasonable to ask these questions. If not, 
# be more at surveying with questions, less at depth.

sum(table(cr8$cocktail_no)==1)
# 183
sum(table(cr8$cocktail_no)==2)
# 141
sum(table(cr8$cocktail_no)==3)
# 35
sum(table(cr8$cocktail_no)==4)
# 13
sum(table(cr8$cocktail_no)==5)
# 3

# Make a plot of these data: # of cocktails that achieve # of crystallizations.

# Do you conclude that there's an especially successful cocktail in terms of number of
# crystallizations achieved in this dataset? Or a particularly unusual protein?

# What plots are useful to understand the protein/cocktail crystallization figures?
# Make some.

# ------------------------------------------------------------------
  
# Now let's determine which cocktails achieved multiple crystallizations, and for which weeks.
# Is there any overlap in the cocktails? In other words, did some cocktails crystallize the 
# same protein, both weeks? Did any proteins get crystallized by multiple cocktails?

# ------------------------------------------------------------------

# Index into the sample data frame for these crystallized proteins.
#
#   Note: you can "merge" data structures by joining them on a common column. For instance,
#     cr8 = merge(sample, cr8) # merge on sample_id to get sample (protein) info
# 
# 	Is there any dependence on MW (experimental_molecular_weight), sequence length (seq_len),
# 	or concentration for the crystallized proteins? Other numeric measures? Make some plots 
#   to explore this.
# 	
# 	In other words, did cocktails tend to crystallize proteins with similar values in these measures?
	
# ----------------------------------------------------------------

# Index into the 'drop' data frame for the crystallized proteins.
# 	Is there any dependence on solution component ph or concentration (note that concentration is given
# 	in varying units--you can, for instance, pick one prevalent set of units to focus on)?
# 	
# 	Make some plots and explore.
# 	
# Is there anything you can conclude about chemical similarity of the successful cocktails and/or the
# successfully crystallized proteins?
# 
# What plots are useful for exploring this angle of the crystallization data?