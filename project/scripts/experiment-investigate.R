# fiddling with the subsetted project dataset: 'experiment' data frame
# HWI protein crystallization data from Xtuition project
# 15 May 2013

# experiment data: for 13 different proteins in the subsetted dataset, for 2 time points and 1536 cocktails:
#
#    - sample_id
#    - generation (of cocktail preparations)
#    - week_number
#    - cocktail_no
# 
# data are loaded from file:
# hwi-gen8-3wayclass.RData

# this was from the original dataset: we have taken only generation 8 proteins having 2 time points...
# table(experiment$generation, experiment$week_number)
# 
#        2     3     5     6 (week number)
# 5  19968  3072     0     0
# 6  23040 16896     0  1536
# 7  53760  1536 78336     0
# 8  35328     0 29184     0
# 8A 56832     0 36864     0
# 9  50688     0 41472  3072

table(experiment$generation, experiment$week_number)
# subsetted dataset: have only generation 8, weeks 2 and 5:
      2     5
8 19968 19968


str(experiment)
# 'data.frame':  39936 obs. of  13 variables:
# $ sample_id     : Factor w/ 13 levels "4f15c1fc945cdd89340005ae",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ plate_no      : Factor w/ 13 levels "X000009589","X000009591",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ generation    : int  8 8 8 8 8 8 8 8 8 8 ...
# $ read_number   : Factor w/ 39936 levels "X0000095890001200801181235",..: 1391 767 1 975 1007 1851 895 671 3063 1167 ...
# $ week_number   : int  2 2 2 2 2 2 2 2 2 2 ...
# $ cocktail_no   : Factor w/ 1536 levels "C0001","C0002",..: 1098 1464 1 1082 1086 1300 1372 1080 1535 998 ...
# $ cocktail_id   : Factor w/ 1536 levels "4f15c1c0eeaabc82340029fe",..: 1098 1464 1 1082 1086 1300 1372 1080 1535 998 ...
# $ date          : Factor w/ 599 levels "2008-01-18 12:15:00",..: 12 17 21 14 14 8 15 17 1 13 ...
# $ image_url     : Factor w/ 39936 levels "http://xtuition.ccr.buffalo.edu/image-data/X000009589/X000009589200801181215/X0000095890001200801181235.jpg",..: 696 384 1 488 504 926 448 336 1532 584 ...
# $ human_crystal : int  0 0 0 0 0 0 0 0 0 0 ...
# $ class3_crystal: num  0.44 0.456 0.415 0.432 0.407 ...
# $ class3_clear  : num  0.107 0.277 0.266 0.12 0.253 ...
# $ class3_other  : num  0.453 0.268 0.32 0.448 0.34 ...


# here's the contingency table for experiment sample number on week number.
#
table(experiment$sample_id, experiment$week_number)
# 
# sample_id                   2    5
# 4f15c1fc945cdd89340005ae 1536 1536
# 4f15c1fc945cdd89340005b0 1536 1536
# 4f15c1fc945cdd89340005ba 1536 1536
# 4f15c1fc945cdd89340005be 1536 1536
# 4f15c1fc945cdd89340005c6 1536 1536
# 4f15c1fc945cdd89340005cd 1536 1536
# 4f15c1fc945cdd89340005db 1536 1536
# 4f15c1fc945cdd89340005e6 1536 1536
# 4f15c1fc945cdd89340005eb 1536 1536
# 4f15c1fc945cdd89340005f2 1536 1536
# 4f15c1fc945cdd89340005f9 1536 1536
# 4f15c1fc945cdd893400060d 1536 1536
# 4f15c1fc945cdd8934000610 1536 1536