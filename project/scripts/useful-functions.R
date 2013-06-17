# -------------------------------------------------------
# factorify()
# 
# input: data frame, df, that has been subset by factor
# output: data frame, ndf, with all factors re-evaluated
#
# -------------------------------------------------------
factorify <- function(df) {
  ndf = data.frame();
  dfc = colnames(df);
  execstr = "ndf = data.frame(";
  
  # for each item in dfc:
  for (i in 1:length(dfc)) {
    
    # if it's a factor, call the factor() function on the column name:
    if ( is.factor( df[,dfc[i]] ) ) {
      colname = paste0("factor(df$", dfc[i], ")")
    } else {
      colname = paste0("df$", dfc[i])
    }
    execstr = paste(execstr, colname)
    if (i<length(dfc)) {
      execstr = paste0(execstr,",")
    }
  }
  execstr = paste0(execstr,")")
  print(execstr)
  # eval it:
  eval(parse(text = execstr)) 
  # reassign column names and return:
  colnames(ndf) = dfc
  return(ndf)
}

# example call, using the sample data frame:
#testme = factorifyNew(sample)

# ----------- Load R data frame from csv file on github -------------

# ok for file sizes < 1GB
loadFile <- function(filestring) {
  library("RCurl")
  
  # read csv data from github:
  url=paste0(path, filestring)
  print(url)
  temp=getURL(url)
  temp = read.csv(textConnection(temp), row.names=1)
  temp = subset(temp, select=-X) # omit X column, if exists.
  return(temp)
}

path = "https://raw.github.com/jsperhac/workshop-dev/master/project/protein-data/"
experiment = loadFile("R-experiment.csv") 
drop = loadFile("R-drop.csv") 
sample = loadFile("R-sample.csv") 
rm(path)
