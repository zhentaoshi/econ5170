library(caret)

load("lianjia.Rdata")

train_ind=createDataPartition(1:nrow(lianjia),p=0.75)$Resample1

price_reg=price~
  t_trade+age+fiveYearsProperty+subway+factor(district)+dist_center+
  square+livingRoom+drawingRoom+kitchen+bathRoom+
  factor(floor_type)+floor_total+elevator+ladderRatio+
  factor(renovationCondition)+factor(buildingType)+factor(buildingStructure)+
  communityAverage+DOM+followers

boostingReg=gbm::gbm(price_reg,
                     data=lianjia[train_ind,],
                     distribution="gaussian", # to decide the lost function
                     n.trees=100,
                     shrinkage=0.1,
                     interaction.depth=4,
                     n.minobsinnode=20)

lmReg=train(price_reg,data=lianjia[train_ind,],method="lm")

target=lianjia[-train_ind,]$price

pred.boosting=predict(boostingReg,newdata=lianjia[-train_ind,],n.trees=100)
cat("R-squared of GBM prediction =",miscTools::rSquared(target,target-pred.boosting),"\n")

###  compare it with OLS
pred.lm=predict(lmReg,newdata=lianjia[-train_ind,])
cat("R-squared of LM prediction =",miscTools::rSquared(target,target-pred.lm),"\n")

