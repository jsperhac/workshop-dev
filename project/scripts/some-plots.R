# looking at successfully crystallized data...from generation 8

# set current directory
setwd("/home/jsperhac/ccr-office/summer-workshop/2013/project/protein-data/second-iteration/hsw-export")
# load a workspace into the current session
# if you don't specify the path, the cwd is assumed
load("hwi-gen8-3wayclass.RData") 

# perform merge on sample_id to get p_number (protein number) for the labels:
cr8=experiment[experiment$human_crystal==1,]
cr8=factorify(cr8)
cr8 = merge(sample, cr8) # merge on sample_id to get sample (protein) info

# -------- no crystals vs. crystals: grim statistics -------------------

exp = merge(sample, experiment)

# number of experiments for which there is no crystallization:
nocr = dim(exp[exp$human_crystal==0,])[1]
cr = dim(exp[exp$human_crystal==1,])[1]


#freq = c(nocr,sum(freq))
freq = c(nocr,cr)
count = c("No","");

# with percents on the labels:    
slices <-freq
lbls <- count
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, "crystallizations:", pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # add % to labels
pie(slices,
    labels = lbls, 
    col=c("darkblue","red"),
    main="Crystallizations per Cocktail: 39936 experiments") 

# ------------- protein crystallization by week number, successful crystallizations -------------------

# nice to sort by frequency in the contingency table. Don't know how.
# also
# http://stackoverflow.com/questions/3778084/r-how-to-adjust-only-size-of-y-axis-labels

stw=table(cr8$week_number,cr8$p_number)

colors=c("red","darkblue")
barplot(stw,
        main="protein crystallization by week number",
        #xlab="protein id",
        ylab="crystallization events",
        las=2,             # turn the labels
        cex.names=0.75, # x axis magnification
        col=colors)
legend(x="topright",                # location for legend
       title="Week Number",         # title for legend
       legend=unique(cr8$week_number),     # names in legend
       fill=colors)                 # colors for legend

# ------------------ successful crystallizations: # cocktails that achieve # crystallizations

# Make a plot of # of cocktails that achieve # of crystallizations.

freq = c(sum(table(cr8$cocktail_no)==1), # 183
          sum(table(cr8$cocktail_no)==2), # 141
          sum(table(cr8$cocktail_no)==3), # 35
          sum(table(cr8$cocktail_no)==4), # 13
          sum(table(cr8$cocktail_no)==5)) # 3
count = c(1,2,3,4,5);

colors=rainbow(length(freq))

barplot(freq, 
        names.arg=count,
        main="# of crystallizations achieved per cocktail: 637 successful crystallizations",
        xlab="number of crystallizations per cocktail",
        ylab="count of proteins crystallized ",
     col=colors)

# --- try as a pie chart: # crystallizations by cocktail, successful ---

# with percents on the labels:    
slices <-freq
lbls <- count
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, "crystallizations:", pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # add % to labels
pie(slices,
    labels = lbls, 
    col=rainbow(length(lbls)),
    main="Crystallizations per Cocktail: 637 successful crystallizations") 

# ------------- proteins with numbers of times crystallized ---------------

# TODO please look into this...

# Additionally: do plots of the cocktails that crystallized the other proteins! There
# will be lots of 1's, so break down by tables.

# # so, for instance:
# p9715=cr8[cr8$p_number=='P000009715',c('week_number','cocktail_no')]
# p9715=factorify(p9715)
# str(p9715)
# 
# # 'data.frame':  102 obs. of  2 variables:
# # $ week_number: int  2 2 2 2 2 2 2 2 2 2 ...
# # $ cocktail_no: Factor w/ 67 levels "C0167","C0240",..: 56 60 42 4 7 40 44 57 10 67 ...
# p9715t=table(p9715$week_number,p9715$cocktail_no)
# p9715t

# three possible classes here: colSums to 2, colSums to 1, colSums to 0 (is the latter in the supertable?)
# under other circumstances we might have colSums > 2, but not for this case.

# C0167 C0240 C0249 C0253 C0260 C0262 C0267 C0281 C0285 C0295 C0303 C0312 C0313 C0321 C0335 C0336 C0396 C0404
# 2     1     0     1     1     1     1     1     0     1     1     0     1     1     1     1     1     1     1
# 5     1     1     1     0     1     1     1     1     1     1     1     1     1     1     0     1     1     1
# 
# C0413 C0416 C0418 C0437 C0467 C0540 C0569 C0674 C0680 C0709 C0771 C0776 C0780 C0781 C0795 C0836 C0851 C0863
# 2     0     0     1     0     0     0     0     0     0     1     0     0     1     0     1     1     1     0
# 5     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
# 
# C0878 C0895 C0915 C0916 C0917 C0941 C0943 C0944 C0948 C0959 C0963 C0964 C0983 C1023 C1048 C1099 C1100 C1101
# 2     0     0     1     1     1     1     0     1     1     1     1     1     1     0     0     0     0     0
# 5     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
# 
# C1126 C1157 C1204 C1216 C1218 C1224 C1239 C1255 C1266 C1287 C1294 C1318 C1473
# 2     1     1     1     0     0     1     1     0     0     1     1     0     1
# 5     1     1     0     1     1     1     1     1     1     1     1     1     0

# question: does any single cocktail show up more than twice?
# colnames(p9715t[,which(colSums(p9715t)>2)])
# 
# # turn the above into a function:
# # 
# lookForMultiCrystallizations = function(pNum, df) {
#   
#   p=df[df$p_number==pNum,c('week_number','cocktail_no')]
#   p=factorify(p)
#   pt=table(p$week_number,p$cocktail_no)
#   colnames(pt[,which(colSums(pt)>2)])
#   ones=sum(colSums(pt)==1)
#   twos=sum(colSums(pt)==2)
#   zeros=sum(colSums(pt)==0)
#   struct=c(zeros, ones, twos)
#   return(struct)
# }
# 
# lis=levels(cr8$p_number)
# ret=lookForMultiCrystallizations(lis, cr8)
# 
# # 'data.frame':  102 obs. of  2 variables:
# # $ week_number: int  2 2 2 2 2 2 2 2 2 2 ...
# # $ cocktail_no: Factor w/ 67 levels "C0167","C0240",..: 56 60 42 4 7 40 44 57 10 67 ...
# p9715t=table(p9715$week_number,p9715$cocktail_no)
# p9715t


# we'll do this for each protein...
# what does the all case look like? It gives me the 0,0 cases...
all9715=exp[exp$p_number=='P000009715',c('week_number','cocktail_no','human_crystal')]
all9715=factorify(all9715)
barplot()




# all9715t=table(all9715$week_number,all9715$cocktail_no,all9715$human_crystal)
# colnames(all9715t[,which(colSums(all9715t)>2)])
# 
# lookForMultiCrystallizations = function(pNum) {
#   
#   p=df[df$p_number==pNum,c('week_number','cocktail_no','human_crystal')]
#   p=factorify(p)
#     pt=table(p$human_crystal, p$week_number, p$cocktail_no)
#     zerosCr=sum(colSums(pt)==0)
#     onesCr=sum(colSums(pt)==1)
#     twosCr=sum(colSums(pt)==2)
#     struct=c(zeros, ones, twos)
#     
#   return(struct)
# }