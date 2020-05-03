rm(list = ls())

library(quantmod)

stock <- readr::read_csv(
  "SH_stockid.csv", locale = readr::locale(encoding = "GB2312")
)


SH_data <- list()
for (i in 1:length(stock$id)) {
  try(setSymbolLookup(TEMP = list(name = paste0(stock$id[i], ".ss"))))
  try(getSymbols("TEMP", warnings = F))
  try(data[stock$name[i]] <- list(TEMP))
}


# library(plyr)
# closedata <- lapply(data, function(x) {
#   x <- as.data.frame(x)
#   return(list(x[, 4]))
# })
# 
# ldply(closedata, function(x) summary(x[[1]]))

save(SH_data, file = paste0("SH_data_", Sys.Date(), ".Rdata") )
     