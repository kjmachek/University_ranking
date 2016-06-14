# load the libraries
#install.packages('klaR')
#install.packages("caret)
#install.packages("e1071)
library("caret")
library(klaR)
library(e1071)
# load the Bin_Times dataset

###DATA SPLIT
# define an 80%/20% train/test split of the dataset
split=0.80
Times_trainIndex <- createDataPartition(Bin_Times$Ranking_Bin, p=split, list=FALSE)
Times_data_train <- Bin_Times[Times_trainIndex,]
Times_data_test <- Bin_Times[-Times_trainIndex,]
# train a naive bayes model
Times_model <- naiveBayes(as.factor(Ranking_Bin)~., data=Times_data_train)
# make predictions
Times_x_test <- Times_data_test[,1:10]
Times_y_test <- Times_data_test[,11]
Times_predictions <- predict(Times_model, Times_x_test)
# summarize results
confusionMatrix(Times_predictions, Times_y_test)

###BOOTSTRAP
# define training control
Times_train_control <- trainControl(method="boot", number=100)
# train the model
Times_model <- train(as.factor(Ranking_Bin)~., data=Bin_Times, trControl=Times_train_control, method="nb")
# summarize results
print(Times_model)

###K-FOLD CROSS VALIDATION
# define training control
Times_train_control <- trainControl(method="cv", number=10)
# fix the parameters of the algorithm
Times_grid <- expand.grid(.fL=c(0), .usekernel=c(FALSE), .adjust=c(0))
# train the model
Times_model <- train(as.factor(Ranking_Bin)~., data=Bin_Times, trControl=Times_train_control, method="nb", tuneGrid=Times_grid)
# summarize results
print(Times_model)

###REPEATED K-FOLD CROSS VALIDATION
# define training control
Times_train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
Times_model <- train(as.factor(Ranking_Bin)~., data=Bin_Times, trControl=Times_train_control, method="nb")
# summarize results
print(Times_model)

###LEAVE OUT ONE CROSS VALIDATION
# define training control
Times_train_control <- trainControl(method="LOOCV")
# train the model
Times_model <- train(as.factor(Ranking_Bin)~., data=Bin_Times, trControl=Times_train_control, method="nb")
# summarize results
print(Times_model)
