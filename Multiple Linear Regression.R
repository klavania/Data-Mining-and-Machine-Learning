#INSTALLING THE REQUIRED PACKAGES
install.packages('tidyverse', dependencies=TRUE)
install.packages('corrplot', dependencies=TRUE)
install.packages('gridExtra', dependencies=TRUE)
install.packages('GGally', dependencies=TRUE)


#LOADING THE REQUIRED LIBRARY
library(tidyverse)
library(corrplot)
library(ggplot2)
library(lubridate)
library(gridExtra)
library(caTools)
library(GGally)



#READING THE DATA FILE
house_price <- data.frame(read.csv("houseprice.csv", header=T, na.strings=c("","NA")))


#REMOVING UNNECESSARY COLUMNS
house_price <- house_price[,-c(1:2)] 
house_price<-house_price[,-c(15)]





#CHECKING THE DATA
head(house_price,2)
str(house_price)





#CALCULATING TOTAL NUMBER OF NA
count_na <-sapply(house_price, function(c) sum(length(which(is.na(c)))))
count_na <- data.frame(count_na)




#TOTAL NUMBER OF NA
count_na 


#CORRELATION PLOT
correlation_data=data.frame(house_price[,1:18])
corr=cor(correlation_data)
par(mfrow=c(1, 1))
corrplot(corr,method="color")



#RANDOM GENERATED NUMBERS
set.seed(123) 



#PARTITIONING THE DATASET
partition = sample.split(house_price,SplitRatio = 0.7) 




#TRAINING DATA
train=subset(house_price,partition ==TRUE)



#TESTING DATA
test=subset(house_price, partition==FALSE)




#GGPlot to determine the correlation between the variables
ggpairs(train)






#CALCULATING THE OUTLIERS
outlier=boxplot(train$price,plot=FALSE)$out
with_outlier=train[which(train$price %in% outlier),]
train_without_outlier= train[-which(train$price %in% outlier),]



str(house_price)



#TRAINING THE MODEL

model=lm(data=train,price~bedrooms+bathrooms+sqft_living+sqft_lot+floors+waterfront+
           view+condition+grade+sqft_above+sqft_basement+yr_built+
           yr_renovated+lat+long+sqft_living15+sqft_lot15)
summary(model)

#REMOVED NON-SIGNIFICANT ATTRIBUTES
model1=lm(data=train,price~bedrooms+bathrooms+sqft_living+sqft_lot+floors+
           view+condition+grade+sqft_above+yr_built+
           yr_renovated+lat+long+sqft_living15+sqft_lot15)
summary(model1)


#REMOVED NON-SIGNIFICANT ATTRIBUTES
model2=lm(data=train,price~bedrooms+bathrooms+sqft_living+sqft_lot+floors+
            condition+grade+sqft_above+yr_built+
            yr_renovated+lat+long+sqft_living15+sqft_lot15)
summary(model2)


#CALCULATING COOK'S DISTANCE
cooks_distance <- cooks.distance(model2)
mean(cooks_distance)



#FINDING INFLUENTIAL VALUES IN THE DATA
influential_points <- as.numeric(names(cooks_distance)[(cooks_distance > 4*mean(cooks_distance, na.rm=T))])
head(train[influential_points, ])

#INFLUENTIAL DATA PONTS
influential_data=train[influential_points, ]
influencial_outliers=inner_join(with_outlier,influential_data)
influential=train[influential_data, ]


#TRAINING THE MODEL AGAIN WITHOUT OUTLIERS 
model2=lm(data=train_without_outlier,price~bedrooms+bathrooms+sqft_living+sqft_lot+floors+
            condition+grade+sqft_above+yr_built+
            yr_renovated+lat+long+sqft_living15+sqft_lot15)
summary(model2)



#ACCURACY ON TRAINING DATA
predi=model2$fitted.values

table=data.frame(actual=train_without_outlier$price, predicted=predi)
table
mean_absolute_percentage_error=mean(abs(table$actual-table$predicted)/table$actual)
accuracy=1-mean_absolute_percentage_error
accuracy 




#PREDICTING THE HOUSE PRICE

prediction_test=predict(newdata=test,model2)



#CALCULATING THE ACCURACY ON THE TEST DATA
table_1=data.frame(actual=test$price, predicted=prediction_test)

#MEAN ABSOLUTE PERCENTAGE ERROR
mean_absolute_percentage_error_test=mean(abs(table_1$actual-table_1$predicted)/table_1$actual)
mean_absolute_percentage_error_test
accuracy=1-mean_absolute_percentage_error_test
accuracy #ACCURACY ACHIEVED BY THE MODEL


#CALCULATION MEAN SQUARE ERROR
mean_square_error = mean((table_1$actual - table_1$predicted)^2)






#CALCULATING MEAN ABSOLUTE ERROE
mean_absolute_error = caret::MAE(table_1$actual, table_1$predicted)





#CALCULATING ROOT MEAN SQUARE ERROR
root_mean_square_error = caret::RMSE(table_1$actual, table_1$predicted)






#PRINTING THE EVALUATION METHOD RESULT
cat("Mean Square Error is: ", mean_square_error, "Mean Absolute Error is: ", mean_absolute_error,
    "Root Mean Square Error is: ", root_mean_square_error )




