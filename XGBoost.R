
#Loading the Required Library
library(xgboost)
library(caret)








#Loading the data file
house_price <- data.frame(read.csv("houseprice.csv", header=T, na.strings=c("","NA")))







#CALCULATE THE NUMBER OF NA's
count_na <-sapply(house_price, function(c) sum(length(which(is.na(c)))))
count_na <- data.frame(count_na)
#Number of NA
count_na 







#CONVERTING CATEGORICAL ATTRIBUTES TO FACTORS
house_price$waterfront=as.factor(house_price$waterfront)
house_price$view=as.factor(house_price$view)
house_price$condition=as.factor(house_price$condition)
house_price$bathrooms=as.factor(house_price$bathrooms)
house_price$bedrooms=as.factor(house_price$bedrooms)
house_price$floors=as.factor(house_price$floors)
house_price$grade=as.factor(house_price$grade)








#REMOVING THE ROWS WITH NA
house_price <- na.omit(house_price)






#CHECKING AGAIN FOR ANY MISSING VALUE
summary(house_price)









#REMOVING UNNECESSARY COLUMNS
house_price <- house_price[,-c(1:2)] 
house_price<-house_price[,-c(15)]
summary(house_price)








#TO NOT HAVE REPEATED SEQUENCE
set.seed(123)







#DIVIDING DATASET INTO TRAINING & TESTING
partition = createDataPartition(house_price$price, p = .70, list = F)
train = house_price[partition, ]
test = house_price[-partition, ]






#TRAINING DATA
xTrain = data.matrix(train[, -1])
yTrain = train[,1]






#TESTING DATA
xTest = data.matrix(test[, -1])
yTest = test[, 1]


#Defining the training and Testing Matrix
XGB_train = xgb.DMatrix(data = xTrain, label = yTrain)
XGB_test = xgb.DMatrix(data = xTest, label = yTest)








#TRAINING THE MODEL

XGB_Algo = xgboost(data = XGB_train, max.depth = 10000, nrounds = 1000)
print(xgbc)






#PREDICTING THE PRICE OF THE HOUSE
yPred = predict(XGB_Algo, XGB_test)










#CALCULATION MEAN SQUARE ERROR
mean_square_error = mean((yTest - yPred)^2)






#CALCULATING MEAN ABSOLUTE ERROE
mean_absolute_error = caret::MAE(yTest, yPred)





#CALCULATING ROOT MEAN SQUARE ERRO
root_mean_square_error = caret::RMSE(yTest, yPred)




#PRINTING THE EVALUATION METHOD RESULT
cat("Mean Square Error is: ", mean_square_error, "Mean Absolute Error is: ", mean_absolute_error,
    "Root Mean Square Error is: ", root_mean_square_error )



#CALCULATING THE ACCURACY ON THE TEST DATA
table_1=data.frame(actual=yTest, predicted=yPred)



#MEAN ABSOLUTE PERCENTAGE ERROR
mean_absolute_percentage_error_test=mean(abs(table_1$actual-table_1$predicted)/table_1$actual)
mean_absolute_percentage_error_test
accuracy=1-mean_absolute_percentage_error_test
accuracy #ACCURACY ACHIEVED BY THE MODEL



#PLOTTING THE OUTPUT
x = 1:length(yTest)
plot(x, yTest, col = "red", type = "l")
lines(x, yPred, col = "blue", type = "l")
legend("topright",  legend = c("Original House Price", "Predicted House Price"), 
       fill = c("red", "blue"))

summary(y_pred)
