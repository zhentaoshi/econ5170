rm(list= ls())


library(dplyr)
library(RColorBrewer)
library(ggthemes)
library(rgdal)
library(corrplot)
library(lubridate)
library(caret)
library(psych)
library(rgdal)
library(magrittr)
library(lubridate)
library(caret)


load(file = "DF3_Yangli.Rdata")


df3$tradeTimeTs <- as.Date(df3$tradeTime, format = "%Y-%m-%d")
df3$year <- year(df3$tradeTimeTs)
df3$month <- month(df3$tradeTimeTs)
df3$date<-date(df3$tradeTimeTs)
df3$monthlyTradeTS <- as.Date(paste0(df3$year,'-',df3$month,'-',df3$date,'-01'))
df3 %>% filter(year>2009) %>% group_by(monthlyTradeTS) %>% 
  summarise(count=n(), mean = mean(price)) %>% 
  ggplot(aes(x=monthlyTradeTS, y= mean)) + 
  geom_line(size=2, alpha=.25, color='steelblue') + geom_point(aes(size=count), alpha=.75) +
  theme_minimal(14) + theme(axis.title =element_blank()) + 
  labs(title='Average price of dailyly traded homes', 
       subtitle='number of homes traded by month is represented by the size of the area') + 
  scale_radius(range=c(1,10))




Lng=(df3$Lng-116.4)^2
Lat=(df3$Lat-39.9)^2
dis=Lng+Lat
df3$dis=dis

d4 <- as.data.frame(cbind(
  df3 %>% select_if(is.numeric) %>% select(-Lng, -Lat, -year, -month),
  'bldgType'= dummy.code(df3$buildingType),
  'bldgStruc'= dummy.code(df3$buildingStructure),
  'renovation'= dummy.code(df3$renovationCondition),
  'hasElevator'= dummy.code(df3$elevator),
  'hasSubway'= dummy.code(df3$subway),
  'IsFiveYears'= dummy.code(df3$fiveYearsProperty),
  'districtCat'= dummy.code(df3$district)))



train_ind = createDataPartition(1:nrow(d4), p = 0.75)$Resample1

gbmGrid <-  expand.grid(interaction.depth = 4, 
                        n.trees = 100, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)


 
trControl <- trainControl( method = "repeatedcv", number = 5, repeats = 1)


boostingReg = gbm::gbm(totalPrice ~ . ,
                   data = d4[train_ind,],
                   distribution = "gaussian", # to decide the lost function
                   n.trees = 100,
                   shrinkage = 0.1, 
                   interaction.depth = 4,
                   n.minobsinnode = 20)


lmReg = train(totalPrice ~., data = d4[train_ind, ] ,method="lm" )



target = d4[-train_ind, ]$totalPrice

pred.boosting = predict(boostingReg, newdata = d4[-train_ind, ], n.trees = 100 )
cat("\n R-squared of GBM prediction = ", miscTools::rSquared(target, target - pred.boosting) , "\n" )



###  compare it with OLS
pred.lm = predict(lmReg, newdata = d4[-train_ind, ] )
cat("\n R-squared of LM prediction = ", miscTools::rSquared(target, target - pred.lm ) , "\n" )

