

library(quantmod)
stock=read.csv('stockid.csv',stringsAsFactors=F)

data=list()
for(i in 1:length(stock$id)){
  try(setSymbolLookup(TEMP=list(name=paste0(stock$id[i],'.ss'))))
  try(getSymbols("TEMP",warnings=F))
  try(data[stock$name[i]]<-list(TEMP))
}


library(plyr)
closedata<-lapply(data,function(x){
  x=as.data.frame(x)
  return(list(x[,4]))
})
ldply(closedata,function(x)summary(x[[1]]))