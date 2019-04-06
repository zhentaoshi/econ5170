# based on https://datascienceplus.com/gradient-boosting-in-r/
# with modifications
# It gives the workflow of a prediction exercise



require(gbm)
require(MASS) #package with the boston housing dataset
require(caret)

# train=sample(1:506,size=374) # get the index of the training sample
ind_train = createDataPartition(1:dim(Boston)[1], times = 1, p = 0.8)$Resample1

Boston.boost.1=gbm(medv ~ . ,
                 data = Boston[ind_train,],
                  distribution = "gaussian", # to decide the lost function
                  n.trees = 10000,
                  shrinkage = 0.01, 
                  interaction.depth = 4)

############################

fitControl = trainControl( method = "repeatedcv", number = 10, repeats = 10)

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = (10:20)*50, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
# if tuning is not needed, just give one line datafreme for the gbmGrid


Boston.boost= train(medv ~ . ,
                    data = Boston[ind_train,],
                    method = "gbm",
                    trControl = fitControl,
                    verbose = FALSE,
                    tuneGrid = gbmGrid)
# automatically contains the "best" model in the object Boston.boost



Boston.boost

summary(Boston.boost) #Summary gives a table of Variable Importance and a plot of Variable Importance


best(Boston.boost$results, maximize = FALSE, metric = "RMSE") # give is the index of the best model in gbmGrid

#Plot of Response variable with lstat variable
# plot(Boston.boost,i="lstat") 
#Inverse relation with lstat variable

# plot(Boston.boost,i="rm") 
#as the average number of rooms increases the the price increases

pred.Boston.boost = predict(Boston.boost, newdata = Boston[-ind_train, ] )

pred.error.boost = pred.Boston.boost - Boston[-ind_train, ]$medv
# apply(pred.error.boost, 2, var)
print( var( pred.error.boost) )



###  compare it with OLS
Boston.lm = lm(medv ~ ., data = Boston[ind_train,] )
pred.Boston.lm = predict(Boston.lm, newdata = Boston[-ind_train, ] )
pred.error.lm = pred.Boston.lm - Boston[-ind_train, ]$medv
print( var(pred.error.lm) )
