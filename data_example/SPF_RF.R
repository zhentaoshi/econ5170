# an example from Cheng, Huang and Shi (2020)
# authored by Ka Yan Cheng
# revised by Zhentao Shi (2020-4-20)


# the script can be finished within 5 minutes





# 1. Prepare the required packages

library(doParallel)
library(ranger)
library(caret)

# 2. Parallel Computing
cluster <- makeCluster(detectCores() - 1) # leave only one idle core
registerDoParallel(cluster)

# 3. Import the data
# SPF : Survey of Professional Forecasters;
rawdata <- readxl::read_excel("SPF_Individual.xlsx")

# 4. Data useful for analysis (Dropping the first column recording the date)
mydata <- as.matrix(rawdata[, -c(1)])

# 5. Set up the Train Control for *forecasting*

# Sample Period: 1982Q4 to 2018Q3;
# Start of the Out-of-sample period: 1993Q1;
# Window length = 10yrs + 1Q
# Rolling Window

sampling_setting <- list(
  start = 2, initialWindow = 41,
  fixedWindow = TRUE
)

# General Function
get_fit_time_slices <- function(x) { # Input is the sampling setting

  start <- x$start
  initialWindow <- x$initialWindow
  fixedWindow <- x$fixedWindow

  createTimeSlices(start:nrow(mydata),
    initialWindow = initialWindow,
    horizon = 1,
    fixedWindow = fixedWindow
  )
}

# Slicing the data
fit_time_slices <- get_fit_time_slices(sampling_setting)


# Position of the training dataset and the test dataset in the whole dataset
fit_time_slices_train <- lapply(fit_time_slices$train, function(x) {
  x + sampling_setting$start - 1
})


fit_time_slices_test <- lapply(fit_time_slices$test, function(x) {
  x + sampling_setting$start - 1
})

# 6. Set up the Train Control for *validation* data set

validation_timecontrol <- lapply(fit_time_slices$train, function(x) {
  st <- as.integer(head(x, n = 1))
  end <- as.integer(tail(x, n = 1))
  tl <- (end - st) + 1

  validation_time_slices <- createTimeSlices(st:end,
    initialWindow = ceiling(tl * 0.8),
    horizon = 1,
    fixedWindow = sampling_setting$fixedWindow
  )


  trainControl(
    method = "timeslice",
    initialWindow = ceiling(tl * 0.8),
    savePredictions = "all",
    horizon = 1,
    fixedWindow = sampling_setting$fixedWindow,
    allowParallel = TRUE,
    index = validation_time_slices$train,
    indexOut = validation_time_slices$test
  )
})


# 7. Train data on the Random Forest Model (rf)
# using the "ranger" package
rf_tuneGrid <- expand.grid(
  mtry = seq(5, 20, 5),
  splitrule = c("variance"),
  min.node.size = seq(30, 50, 10)
)

n_models <- nrow(mydata) - sampling_setting$initialWindow - 1

rf.mod <- vector(mode = "list", length = n_models)

set.seed(2019)

for (i in 1:n_models) {
  valid <- validation_timecontrol[[i]]
  horizon <- fit_time_slices_train[[i]]
  start <- head(horizon, n = 1)
  end <- tail(horizon, n = 1)

  rf.mod[[i]] <- train(Actual_inflation ~ .,
    data = mydata[start:end, ],
    metric = "RMSE",
    method = "ranger", # call random forecast
    tuneGrid = rf_tuneGrid,
    trControl = valid
  )
}

# 8. Find out the forecasts from the rf model

predictions_rf.mod <- vector(mode = "list", length = n_models)

for (i in 1:n_models) {
  test <- fit_time_slices_test[[i]]
  test_predictors <- t(mydata[test, -1])
  colnames(test_predictors) <- rf.mod[[i]]$coefnames

  predictions_rf.mod[i] <- predict(rf.mod[[i]]$finalModel, test_predictors)
}

predictions_rf.mod <- unlist(predictions_rf.mod)



# 9. Evaluate the performance of models

# Define function of  Performance indicator
rmse <- function(predictions, observe) {
  sqrt(mean((predictions - observe)^2))
}

mae <- function(predictions, observe) {
  mean(abs((predictions - observe)))
}

# Check the RMSE and MAE on the *test data*

# The general function to get the actual observations  of the test data

testdata <- mydata[unlist(fit_time_slices_test), 1]

# rf performances

RMSE_rf.mod <- rmse(predictions = predictions_rf.mod, observe = testdata)
MAE_rf.mod <- mae(predictions = predictions_rf.mod, observe = testdata)

# 10. Result
result <- cbind(RMSE_rf.mod, MAE_rf.mod)

print(result)

#                 RMSE_rf.mod MAE_rf.mod
# rollwindow_f       1.127272  0.8453679

# Stop the Parallel Computing
stopCluster(cluster)
registerDoSEQ()
