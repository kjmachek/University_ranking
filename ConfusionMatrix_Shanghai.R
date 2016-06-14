split=0.80
Shanghai_trainIndex <- createDataPartition(Bin_Shanghai$Ranking_Bin, p=split, list=FALSE)
Shanghai_data_train <- Bin_Shanghai[Shanghai_trainIndex,]
Shanghai_data_test <- Bin_Shanghai[-Shanghai_trainIndex,]
confusionMatrix(Shanghai_data_train$Ranking_Bin,predict(svm_model_Shanghai_after_tune,Shanghai_data_train))