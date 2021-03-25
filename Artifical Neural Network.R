
#Importing necessary libraries
library(keras)
library(dplyr)
library(magrittr)
library(neuralnet)
library(tensorflow)





#Reading the data file
student_marks <- data.frame(read.csv("marks.csv", header=T, na.strings=c("","NA")))

#Checking the structure to see all attributes are numeric
str(student_marks)


#Checking Correlation between the variables
correlation_data=data.frame(student_marks[,1:16])
corr=cor(correlation_data)
par(mfrow=c(1, 1))
corrplot(corr,method="color")


#CALCULATING TOTAL NUMBER OF NA
count_na <-sapply(student_marks, function(c) sum(length(which(is.na(c)))))
count_na <- data.frame(count_na)




#TOTAL NUMBER OF NA
count_na 


#OMITTING THE NULL VALUES
student_marks <- na.omit(student_marks)



#Neural N/W Model
net <- neuralnet(score ~ gender+num_of_prev_attempts+studied_credits+disability+
                   date_registration+sum_click+date_submitted+weight+module_presentation_length+
                   A.Level.or.Equivalent+Lower.Than.A.Level+HE.Qualification+Post.Graduate.Qualification+
                   No.Formal.quals+final_result,
               data = student_marks,
               hidden = c(10,5), #10 neurons in first hiddden layer and five neurons in second hidden layer
               linear.output = F,
               lifesign = 'full',
               rep=2)


plot(net,
     col.hidden = 'darkblue',
     col.hidden.synapse = 'darkblue',
     show.weights = F,
     information = F,
     fill = 'lightblue')



#Converting the data into a matrix
student_marks <- as.matrix(student_marks)
dimnames(student_marks) <- NULL


#For random value Generation
set.seed(1234)



#Dividing the dataset into Training &Testing
partition <- sample(2, nrow(student_marks), replace = T, prob = c(.7, .3))

#TRAINING SET
train_independent <- student_marks[partition==1,1:15]
dependent_training <- student_marks[partition==1, 16]

#TESTING SET
test_independent <- student_marks[partition==2, 1:15]
dependent_test <- student_marks[partition==2, 16]




#Normalizing the independent variables by subtracting each value by mean and dividing by standard devidation
mean <- colMeans(train_independent)
standard_deviation <- apply(train_independent,2,sd)
train_independent <- scale(train_independent, center = mean, scale = standard_deviation)
test_independent <- scale(test_independent, center = mean, scale = standard_deviation)


#Creating the model
neural <- keras_model_sequential()
neural %>%
  layer_dense(units=5,activation = 'relu',input_shape = c(15)) %>% #Rectified Unit Activation Function
  layer_dense(units=1) #Output Layer has only 1 neuron



#COMPILING THE MODEL
neural %>% compile(loss = 'mse',
                  optimizer = 'rmsprop',
                  metrics = 'mae')




# Fitting the Model
neuralmodel <- neural %>%
  fit(train_independent,
      dependent_training,
      epochs = 100,
      batch_size = 32,
      validation_split = 0.2)


#Evaluating the Performance of the model
# Evaluate
neural %>% evaluate(test_independent, dependent_test)
#Prediction
prediction <- neural %>% predict(test_independent)

#Mean Squared Error
mean((dependent_test-prediction)^2)






#Improving the performance of the model

neural <- keras_model_sequential()
neural %>%
  layer_dense(units=100,activation = 'relu',input_shape = c(15)) %>%
  layer_dropout(rate=0.4)%>%
  layer_dense(units=50,activation = 'relu') %>%
  layer_dropout(rate=0.3)%>%
  layer_dense(units=20,activation = 'relu') %>%
  layer_dropout(rate=0.2)%>%
  layer_dense(units=1)

summary(neural)

neural %>% compile(loss = 'mse',
                   optimizer = 'rmsprop',
                   metrics = 'mae')




# Fitting the Model
neuralmodel <- neural %>%
  fit(train_independent,
      dependent_training,
      epochs = 100,
      batch_size = 32,
      validation_split = 0.2)


#Evaluating the Performance of the model
# Evaluate
neural %>% evaluate(test_independent, dependent_test)
prediction <- neural %>% predict(test_independent)
mse<-mean((dependent_test-prediction)^2)
MSE #Mean Squared Error
plot(dependent_test, prediction)





