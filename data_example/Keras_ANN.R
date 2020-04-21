###############################################
# Install Keras and Tensorflow
# this script is based on the R tutorial of Keres in RStudio


# install.packages("devtools")
# require(devtools)
# devtools::install_github("rstudio/tensorflow",force = TRUE)
# library(tensorflow)
# install_tensorflow()

# sess = tf$Session()
# hello <- tf$constant('Hello, TensorFlow!')
# sess$run(hello)



# devtools::install_github("rstudio/keras")
library(keras)
# install_keras()

# Keras is convenient for fitting neural network
# But compared to core Tensorflow, Keras is slower




################################################
# Download the data set and split the data

boston_housing <- dataset_boston_housing()
# this data has training x y and test x y

c(train_data, train_labels) %<-% boston_housing$train
# %<-% is a function in the packge `zeallot`
# 'label` is the dependent variable y

c(test_data, test_labels) %<-% boston_housing$test






library(tibble) # a package for data fame
column_names <- c('CRIM', 'ZN', 'INDUS', 'CHAS', 'NOX', 'RM', 'AGE',
                  'DIS', 'RAD', 'TAX', 'PTRATIO', 'B', 'LSTAT')
# give names to the feature dataset

train_df <- as_tibble(train_data)
colnames(train_df) <- column_names   # Make it a data frame

# Rescale data across variables and across training and test sets
train_data <- scale(train_data)


# Here we use means and standard deviations from training set to normalize test set
col_means_train <- attr(train_data, "scaled:center")
col_stddevs_train <- attr(train_data, "scaled:scale")
test_data <- scale(test_data, center = col_means_train, scale = col_stddevs_train)

# both the training and test data are scaled



###################################################
# Model Building
# From this point on, I have difficulty understanding given limited knowledge
# of statistical learning. I will refer to other useful links when needed.

build_model <- function() {

# This is a sequential model with 2 hidden dense layers, and 1 output layer
# Model types: Sequential -> linear layers; Functional -> other types
  # Details: https://tensorflow.rstudio.com/keras/articles/about_keras_models.html
# Layer types: see https://tensorflow.rstudio.com/keras/articles/about_keras_layers.html
  # For dense layer we are using, see https://keras.rstudio.com/reference/layer_dense.html


  # this is a sequential model that allows the user to add one layer after another
  model <- keras_model_sequential() %>%
    layer_dense(units = 64, activation = "relu",  # "relu" is "rectifier linear unit"
                input_shape = dim(train_data)[2]) %>%
    layer_dense(units = 64, activation = "relu") %>%
    layer_dense(units = 1)

  model %>% compile(
    loss = "mse",
    optimizer = optimizer_rmsprop(),
    metrics = list("mean_absolute_error")
  )

  model
}


# at this step, it is all about the model
# no data is feed yet

model <- build_model()
model %>% summary()   # # Show the summary of the model


# There are some pre trained models, but mainly for image classification
# See https://tensorflow.rstudio.com/keras/articles/applications.html
########################################
# Model fitting


# below sends the model to the training data
history <- model %>% fit(
  train_data,
  train_labels,
  epochs = 500,verbose = 0,
  validation_split = 0.2)
# verbose=0 -> Silent when fitting
# epochs = number of epochs to train the model (An epoch is one iteration over the entire input data)

# install.packages("ggplot2")
library(ggplot2)

# the underlying method is "plot.keras_training_history
plot(history, metrics = "mean_absolute_error", smooth = FALSE) +
  coord_cartesian(ylim = c(0, 5))

########################################
# Prediction and evaluation

test_predictions <- model %>% predict(test_data)
print( test_predictions )
# Predict test data

# the underlying function is  "evalaute.keras.engine.training.model"
test_evaluation= model %>% evaluate(test_data,test_labels)
print( test_evaluation )

# Get the loss and mean absolute error of the model on predicting test data
#########################################
