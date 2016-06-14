# load the libraries
library("caret")
install.packages('klaR')
library(klaR)
# load the Bin_World dataset

###DATA SPLIT
# define an 80%/20% train/test split of the dataset
split=0.80
World_trainIndex <- createDataPartition(Bin_World$Ranking_Bin, p=split, list=FALSE)
World_data_train <- Bin_World[World_trainIndex,]
World_data_test <- Bin_World[-World_trainIndex,]
# train a naive bayes model
World_model <- naiveBayes(as.factor(Ranking_Bin)~., data=World_data_train)
# make predictions
World_x_test <- World_data_test[,1:10]
World_y_test <- World_data_test[,11]
World_predictions <- predict(World_model, World_x_test)
# summarize results
confusionMatrix(World_predictions, World_y_test)

###BOOTSTRAP
# define training control
World_train_control <- trainControl(method="boot", number=100)
# train the model
World_model <- train(as.factor(Ranking_Bin)~., data=Bin_World, trControl=World_train_control, method="nb")
# summarize results
print(World_model)

###K-FOLD CROSS VALIDATION
# define training control
World_train_control <- trainControl(method="cv", number=10)
# fix the parameters of the algorithm
World_grid <- expand.grid(.fL=c(0), .usekernel=c(FALSE), .adjust=c(0))
# train the model
World_model <- train(as.factor(Ranking_Bin)~., data=Bin_World, trControl=World_train_control, method="nb", tuneGrid=World_grid)
# summarize results
print(World_model)

###REPEATED K-FOLD CROSS VALIDATION
# define training control
World_train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
World_model <- train(as.factor(Ranking_Bin)~., data=Bin_World, trControl=World_train_control, method="nb")
# summarize results
print(World_model)

###LEAVE OUT ONE CROSS VALIDATION
# define training control
World_train_control <- trainControl(method="LOOCV")
# train the model
World_model <- train(as.factor(Ranking_Bin)~., data=Bin_World, trControl=World_train_control, method="nb")
# summarize results
print(World_model)
