# a new version based on Wang Yishu's implementation
# As in the paper in Feb 2020
# Only use 15% of the full data for demonstration

# The full data runs for 8 hours with 24 cores on Econsuper


library(caret)
library(doParallel)

set.seed(666)

# load("data_example/lianjia.RData") # the raw data
load("lianjia.RData")
N <- nrow(lianjia) # a smaller sample
lianjia <- lianjia[base::sample(1:N, round(N * 0.15 )), ]

tune_ind <- createDataPartition(1:nrow(lianjia), p = 0.1)$Resample1

gbmGrid <- expand.grid(
  interaction.depth = seq(from = 10, to = 50, by = 10),
  n.trees = seq(from = 1000, to = 10000, by = 2000),
  shrinkage = c(0.001, 0.005, 0.01, 0.05),
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

####### run the code
cat(paste("Starting Tuning with Coordinates at:", tc), "\n")
registerDoParallel(24)
Tune.GBM <- train(formula.GBM,
                  data = lianjia[tune_ind, ],
                  method = "gbm", distribution = "gaussian",
                  trControl = gbmControl, tuneGrid = gbmGrid, metric = "Rsquared",
                  verbose = F
)

stopImplicitCluster()
tc <- Sys.time() - tc
print(tc)

gbmTune <- Tune.GBM$bestTune
print(gbmTune)
print(Tune.GBM$resample)


save(formula.GBM, gbmTune, file = "GBMTune.RData")
