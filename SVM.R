#Installing the required Libraries
install.packages('e1071', dependencies=TRUE)





#Loading Required Libraries
library(ggplot2)
library(e1071)
library(caret)




#Getting working directory
getwd()





#Reading the CSV file
casualty_data <- read.csv("Casuality.csv",header=TRUE)





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








str(casualtyfile)
summary(casualtyfile)
table(casualtyfile$Casualty_Severity)












#Total number of rows
count<- nrow(casualtyfile)
count

#To generate random rows
set.seed(121)

#CREATING DATA PARTITION
partition <-sample(1:count,count*0.7,replace=FALSE)



#TRAINING DATA
traindata<-casualtyfile[partition,]


#TESTING DATA
testdata<-casualtyfile[-partition,]



#TRAINING MODEL THROUGH DIFFERENT KERNALS
trainradial<-svm(Casualty_Severity~.,data=traindata)
trainlinear<-svm(Casualty_Severity~.,data=traindata,kernal="linear")
trainpolynomial<-svm(Casualty_Severity~.,data=traindata,kernal="polynomial")
trainsigmoidal<-svm(Casualty_Severity~.,data=traindata,kernal="sigmoid")
summary(trainradial)
summary(trainlinear)
summary(trainpolynomial)
summary(trainsigmoidal)


#obj<-tune.svm(Casualty_Severity~.,data=traindata,gamma=seq(0.01,10,by=0.01,cost=1:100))
obj<-tune.svm(Casualty_Severity~.,data=traindata,gamma=seq(0.01,10,by=0.5))
summary(obj)




#FINE TUNING THE MODEL
#fitnewradial<-svm(Casualty_Severity~.,data = traindata,gamma=0.01,cost=30)
trainnewradial<-svm(Casualty_Severity~.,data = traindata,gamma=0.01,cost=31,cross=(20))
summary(trainnewradial)


#DOING THE PREDICTION
prednewradial<-predict(trainnewradial,testdata)
predictradial<-predict(trainradial,testdata)
predictlinear<-predict(trainpolynomial,testdata)
predictpolynomial<-predict(trainlinear,testdata)
predictsigmoidal<-predict(trainsigmoidal,testdata)
table(prednewradial,testdata$Casualty_Severity)




#DETERMING THE ACCURACY OF THE MODEL
confusionMatrix(prednewradial,testdata$Casualty_Severity)
confusionMatrix(predictsigmoidal,testdata$Casualty_Severity)
confusionMatrix(predictlinear,testdata$Casualty_Severity)
confusionMatrix(predictpolynomial,testdata$Casualty_Severity)

