split=0.80
World_trainIndex <- createDataPartition(Bin_World$Ranking_Bin, p=split, list=FALSE)
World_data_train <- Bin_World[World_trainIndex,]
World_data_test <- Bin_World[-World_trainIndex,]
confusionMatrix(World_data_train$Ranking_Bin,predict(svm_model_World_after_tune,World_data_train))