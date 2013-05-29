# the subsetted project dataset: 'drop' data frame
# generation 8; 2 data points per protein; 13 proteins total
# HWI protein crystallization data from Xtuition project
# 20 May 2013

# drop data: for 13 different proteins in the subsetted dataset, for 2 time points and 1536 cocktails:
#    - sample_id
#    - generation (of cocktail preparations) == 8
#    - cocktail_no 
#    - solution_component_no

# data are loaded from file:
# hwi-gen8-3wayclass.RData

# How to uniquely specify a record in the drop datastructure:
#
# note that we have 1536 cocktails, all with multiple components; each component has at least 2, and at most
# 6, components. Need to specify cocktail_id (or cocktail_no) PLUS solution_component_no to get a unique record
# in the drop datastructure as loaded.

# TODO: JMS could specify a unique key here...

str(drop)
# 'data.frame':  3930 obs. of  8 variables:
# $ cocktail_id          : Factor w/ 1536 levels "4f15c1c0eeaabc82340029fe",..: 1 1 2 2 3 3 4 4 5 5 ...
# $ generation           : int  8 8 8 8 8 8 8 8 8 8 ...
# $ cocktail_no          : Factor w/ 1536 levels "C0001","C0002",..: 1 1 2 2 3 3 4 4 5 5 ...
# $ solution_component_no: int  1 2 1 2 1 2 1 2 1 2 ...
# $ concentration        : num  3.56 0.1 3.56 0.1 2.38 0.1 2.38 0.1 1.19 0.1 ...
# $ units                : Factor w/ 3 levels "M","% (v/v)",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ name                 : Factor w/ 123 levels "1,4-Dioxane",..: 4 118 4 22 4 97 4 37 4 93 ...
# $ ph                   : num  8 8 10 10 4.2 4.2 7.5 7.5 5 5 ...

unique(drop$generation)
# [1] 8

unique(drop$solution_component_no) # we have up to 6 components in a drop here...
# [1] 1 2 3 4 5 6

# ------------------------------------------------------------------------------

# here's my analysis of numbers of components in 'drop' after the conversion done with perl

# upper and lower bound on # records in the drop data structure:
length(unique(drop$solution_component_no))
# [1] 6
# max # components is 6

# we will have in 'drop' absolutely no more records than (because some drops have 6 components)
6*6144
# [1] 36864

# and absolutely no fewer than (because each drop has at least 2 components):
2*6144
# [1] 12288

# and in fact the number of records in drop is equal to the sum of these values:
sum(drop$solution_component_no==6)
#[1] 1
sum(drop$solution_component_no==5)
#[1] 1
sum(drop$solution_component_no==4)
#[1] 21
sum(drop$solution_component_no==3)
#[1] 879
sum(drop$solution_component_no==2)
#[1] 1492
sum(drop$solution_component_no==1)
#[1] 1536

# Here's the sum; this is the number of records I loaded in 'drop':
1+1+21+879+1492+1536
# [1] 3930