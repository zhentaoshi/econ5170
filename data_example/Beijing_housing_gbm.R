library(caret)


load("lianjia.RData")
train_ind=createDataPartition(1:nrow(lianjia),p=0.75)$Resample1

price_reg=price~
  t_trade+age+fiveYearsProperty+subway+factor(district)+dist_center+
  square+livingRoom+drawingRoom+kitchen+bathRoom+
  factor(floor_type)+floor_total+elevator+ladderRatio+
  factor(renovationCondition)+factor(buildingType)+factor(buildingStructure)+
  communityAverage+DOM+followers


## GBM

## Tuning Parameters
train_tune=createDataPartition(1:nrow(lianjia),p=0.1)$Resample1
gbmGrid=expand.grid(interaction.depth=1:10,
                    n.trees=seq(100,300,by=50),
                    shrinkage=c(0.01,0.05,0.1,0.25,0.5,0.75),
                    n.minobsinnode=20)
gbmControl=trainControl(method="repeatedcv",number=5,repeats=1)
boostingReg=train(price_reg,data=lianjia[train_tune,],method="gbm",distribution="gaussian",
                  trControl=gbmControl,tuneGrid=gbmGrid,metric="Rsquared",verbose=F)
gbmTune=boostingReg$bestTune
cat("The best tuning parameters for GBM are: \n");print(gbmTune)

## Estimation and Prediction
boostingReg=gbm::gbm(price_reg,data=lianjia[train_ind,],
                     distribution="gaussian", # to decide the lost function
                     n.trees=gbmTune$n.trees,
                     shrinkage=gbmTune$shrinkage,
                     interaction.depth=gbmTune$interaction.depth,
                     n.minobsinnode=gbmTune$n.minobsinnode)
pred.boosting=predict(boostingReg,newdata=lianjia[-train_ind,],n.trees=gbmTune$n.trees)


## LM

lmReg=lm(price_reg,data=lianjia[train_ind,])
pred.lm=predict(lmReg,newdata=lianjia[-train_ind,])


## Comparison

target=lianjia[-train_ind,]$price
cat("R-squared of GBM prediction =",miscTools::rSquared(target,target-pred.boosting),"\n")
cat("R-squared of LM prediction =",miscTools::rSquared(target,target-pred.lm),"\n")


