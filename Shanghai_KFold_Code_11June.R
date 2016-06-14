# load the libraries
#install.packages('klaR')
#install.packages("caret)
#install.packages("e1071)
library("caret")
library(klaR)
library(e1071)
# load the Bin_Shanghai dataset

###DATA SPLIT
# define an 80%/20% train/test split of the dataset
split=0.80
Shanghai_trainIndex <- createDataPartition(Bin_Shanghai$Ranking_Bin, p=split, list=FALSE)
Shanghai_data_train <- Bin_Shanghai[Shanghai_trainIndex,]
Shanghai_data_test <- Bin_Shanghai[-Shanghai_trainIndex,]
# train a naive bayes model
Shanghai_model <- naiveBayes(as.factor(Ranking_Bin)~., data=Shanghai_data_train)
# make predictions
Shanghai_x_test <- Shanghai_data_test[,1:10]
Shanghai_y_test <- Shanghai_data_test[,11]
Shanghai_predictions <- predict(Shanghai_model, Shanghai_x_test)
# summarize results
confusionMatrix(Shanghai_predictions, Shanghai_y_test)

###BOOTSTRAP
# define training control
Shanghai_train_control <- trainControl(method="boot", number=100)
# train the model
Shanghai_model <- train(as.factor(Ranking_Bin)~., data=Bin_Shanghai, trControl=Shanghai_train_control, method="nb")
# summarize results
print(Shanghai_model)

###K-FOLD CROSS VALIDATION
# define training control
Shanghai_train_control <- trainControl(method="cv", number=10)
# fix the parameters of the algorithm
Shanghai_grid <- expand.grid(.fL=c(0), .usekernel=c(FALSE), .adjust=c(0))
# train the model
Shanghai_model <- train(as.factor(Ranking_Bin)~., data=Bin_Shanghai, trControl=Shanghai_train_control, method="nb", tuneGrid=Shanghai_grid)
# summarize results
print(Shanghai_model)

###REPEATED K-FOLD CROSS VALIDATION
# define training control
Shanghai_train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
Shanghai_model <- train(as.factor(Ranking_Bin)~., data=Bin_Shanghai, trControl=Shanghai_train_control, method="nb")
# summarize results
print(Shanghai_model)

###LEAVE OUT ONE CROSS VALIDATION
# define training control
Shanghai_train_control <- trainControl(method="LOOCV")
# train the model
Shanghai_model <- train(as.factor(Ranking_Bin)~., data=Bin_Shanghai, trControl=Shanghai_train_control, method="nb")
# summarize results
print(Shanghai_model)
