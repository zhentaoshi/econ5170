library(caret)
library(doParallel)

load("lianjia.RData")

price_reg=price~
  t_trade+age+fiveYearsProperty+subway+factor(district)+dist_center+
  square+livingRoom+drawingRoom+kitchen+bathRoom+
  factor(floor_type)+floor_total+elevator+ladderRatio+
  factor(renovationCondition)+factor(buildingType)+factor(buildingStructure)+
  communityAverage+DOM+followers


# GBM

## Tuning Parameters

train_tune=createDataPartition(1:nrow(lianjia),p=0.1)$Resample1
gbmGrid=expand.grid(interaction.depth=10:14,
                    n.trees=(15:20)*100,
                    shrinkage=c(0.01,0.05,0.1),
                    n.minobsinnode=20)
gbmControl=trainControl(method="repeatedcv",number=5,repeats=1)

registerDoParallel(8)
t=Sys.time()
boostingReg=train(price_reg,data=lianjia[train_tune,],
                  method="gbm",distribution="gaussian",
                  trControl=gbmControl,tuneGrid=gbmGrid,metric="Rsquared",
                  verbose=F)
cat("Time Cost of Finding Best Tuning Parameters:",Sys.time()-t,"\n")
stopImplicitCluster()

gbmTune=boostingReg$bestTune
cat("The best tuning parameters for GBM are: \n");print(gbmTune)

## Estimation and Prediction

train_ind=createDataPartition(1:nrow(lianjia),p=0.75)$Resample1
boostingReg=train(price_reg,data=lianjia[train_ind,],method="gbm",
                  distribution="gaussian", # to decide the lost function
                  tuneGrid=gbmTune,verbose=F)
pred.boosting=predict(boostingReg,newdata=lianjia[-train_ind,])


# LM

lmReg=lm(price_reg,data=lianjia[train_ind,])
pred.lm=predict(lmReg,newdata=lianjia[-train_ind,])


# Comparison

target=lianjia[-train_ind,]$price
cat("R-squared of GBM prediction =",miscTools::rSquared(target,target-pred.boosting),"\n")
cat("R-squared of LM prediction =",miscTools::rSquared(target,target-pred.lm),"\n")


