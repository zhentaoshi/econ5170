library(caret)
library(doParallel)

set.seed(666)

load("data_example/lianjia.RData") # the raw data
N <- nrow(lianjia) # a smaller sample
lianjia <- lianjia[base::sample(1:N, round(N / 10)), ]

tune_ind <- createDataPartition(1:nrow(lianjia), p = 0.1)$Resample1

gbmGrid <- expand.grid(
  interaction.depth = seq(from = 10, to = 50, by = 20),
  n.trees = seq(from = 1000, to = 10000, by = 5000),
  shrinkage = c(0.001, 0.005, 0.01),
  n.minobsinnode = 20
)

gbmControl <- trainControl(method = "cv", number = 5)


# With Coordinates

formula.GBM <- price ~
square + livingRoom + drawingRoom + kitchen + bathRoom +
  floor_type + floor_total + elevator + ladderRatio +
  renovationCondition + buildingType + buildingStructure +
  age + DOM + followers + fiveYearsProperty +
  subway + district + Lng + Lat + t_trade +
  communityAverage

tc <- Sys.time()
cat(paste("Starting Tuning with Coordinates at:", tc), "\n")
# registerDoParallel(24)
Tune.GBM <- train(formula.GBM,
  data = lianjia[tune_ind, ],
  method = "gbm", distribution = "gaussian",
  trControl = gbmControl, tuneGrid = gbmGrid, metric = "Rsquared",
  verbose = F
)
# stopImplicitCluster()
tc <- Sys.time() - tc
print(tc)

gbmTune <- Tune.GBM$bestTune
print(gbmTune)
print(Tune.GBM$resample)


save(formula.GBM, gbmTune, file = "GBMTune.RData")
