#Installing the required Libraries
install.packages('e1071', dependencies=TRUE)





#Loading Required Libraries
library(randomForest)
library(caret)
library(corrplot)




#Getting working directory
getwd()





#Reading the CSV file
casualty_data <- read.csv("C:/Users/krishna/Documents/Cas1.csv",header=TRUE)





#CREATING A DATAFRAME
casualtyfile <- data.frame(casualty_data) 
str(casualtyfile)





#REMOVING UNWANTED COLUMN
casualtyfile <- casualtyfile[,-c(1)] 
str(casualtyfile)








#REMOVING ROWS WHICH HAS -1 BECAUSE -1 MEANS NO VALUE OR VALUE WHOSE MEANING IS UNDEFINED
casualtyfile=subset(casualtyfile,casualtyfile$Casualty_IMD_Decile!=-1)
casualtyfile= subset(casualtyfile, casualtyfile $ Age_of_Casualty!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Age_Band_of_Casualty!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Pedestrian_Location!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Pedestrian_Movement!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Car_Passenger!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Bus_or_Coach_Passenger!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Pedestrian_Road_Maintenance_Worker!= -1)
casualtyfile= subset(casualtyfile, casualtyfile $ Casualty_Home_Area_Type!= -1)
head(casualtyfile)
dim(casualtyfile) 






#CHECKING FOR NULL VALUES
colSums(is.na(casualtyfile)) 


correlation_data=data.frame(casualtyfile[,1:15])
corr=cor(correlation_data)
par(mfrow=c(1, 1))
corrplot(corr,method="color")



#DETERMING CORRELATION BETWEEN INDEPENDENT AND DEPENDENT VARIABLES
cor(casualtyfile$Casualty_Reference, casualtyfile$Casualty_Severity) 
cor(casualtyfile$Vehicle_Reference,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Casualty_Class,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Sex_of_Casualty,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Age_of_Casualty,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Age_Band_of_Casualty,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Pedestrian_Location,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Pedestrian_Movement,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Car_Passenger,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Bus_or_Coach_Passenger,casualtyfile$Casualty_Severity)
cor(casualtyfile$Pedestrian_Road_Maintenance_Worker,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Casualty_Type,casualtyfile$Casualty_Severity) 
cor(casualtyfile$Casualty_Home_Area_Type,casualtyfile$Casualty_Severity)
cor(casualtyfile$Casualty_IMD_Decile,casualtyfile$Casualty_Severity) 










#Converting categorical variables into factors
casualtyfile$Casualty_Severity= as.factor(casualtyfile$Casualty_Severity)
casualtyfile$Vehicle_Reference=as.factor(casualtyfile$Vehicle_Reference)
casualtyfile$Casualty_Reference=as.factor(casualtyfile$Casualty_Class)
casualtyfile$Casualty_Class=as.factor(casualtyfile$Casualty_Class)
casualtyfile$Sex_of_Casualty=as.factor(casualtyfile$Sex_of_Casualty)
casualtyfile$Age_Band_of_Casualty=as.factor(casualtyfile$Age_Band_of_Casualty)
casualtyfile$Pedestrian_Location=as.factor(casualtyfile$Pedestrian_Location)
casualtyfile$Pedestrian_Movement=as.factor(casualtyfile$Pedestrian_Movement)
casualtyfile$Car_Passenger=as.factor(casualtyfile$Car_Passenger)
casualtyfile$Bus_or_Coach_Passenger=as.factor(casualtyfile$Bus_or_Coach_Passenger)
casualtyfile$Pedestrian_Road_Maintenance_Worker=as.factor(casualtyfile$Pedestrian_Road_Maintenance_Worker)
casualtyfile$Casualty_Type=as.factor(casualtyfile$Casualty_Type)
casualtyfile$Casualty_Home_Area_Type=as.factor(casualtyfile$Casualty_Home_Area_Type)
casualtyfile$Casualty_IMD_Decile=as.factor(casualtyfile$Casualty_IMD_Decile)







head(casualtyfile)
str(casualtyfile)
summary(casualtyfile)
table(casualtyfile$Casualty_Severity)




set.seed(123)

#Dividing the dataset
index <- sample(2,nrow(casualtyfile), replace=TRUE, prob=c(0.7,0.3))




#Training dataset
traindata <- casualtyfile[index==1,]





#Testing dataset
testdata <- casualtyfile[index==2,]




#Applying Random Forest Algorithm
set.seed(222)
rforest<-randomForest(Casualty_Severity~.,data = traindata)
print(rforest)
attributes(rforest)




#Prediction & Confusion Matrix -train data
train_predict<-predict(rforest,traindata)
confusion<-confusionMatrix(train_predict,traindata$Casualty_Severity)
confusion






#Prediction &Confusion Matrix -test data
p2 <- predict(rforest,testdata)
confusionMatrix(p2,testdata$Casualty_Severity)




#tune mtray
tune<-tuneRF(traindata[,-8],traindata[,8],
          stepFactor = 0.5,
          plot = TRUE,
          ntreeTry=100,
          trace=TRUE,
          improve=0.05)




rf2<-randomForest(Casualty_Severity~.,data = traindata, mtry=2,ntree=100)

#Prediction & Confusion Matrix -train data
p1<-predict(rf2,traindata)
t<-confusionMatrix(p1,traindata$Casualty_Severity)
t






#Prediction &Confusion Matrix -test data
p2 <- predict(rf2,testdata)
confusionMatrix(p2,testdata$Casualty_Severity)






#No. of nodes for the trees
hist(treesize(rforest),
     main="No. of nodes for the trees",
     col='lightblue')


#Variable Importance
varImpPlot(rforest,
           sort=T,
           n.var=10,
           main="Top 10 -Variable Importance")
importance(rforest)
varUsed(rforest)


#Partial Dependence Plot
partialPlot(rforest,traindata, Casualty_IMD_Decile, "2")


#Extract Single Tree
getTree(rforest,1,labelVar = TRUE)



