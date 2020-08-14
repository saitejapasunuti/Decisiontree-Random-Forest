install.packages("C50")
install.packages("tree")
library("tree")
install.packages("party")
library(party)
install.packages("gmodels")
library("gmodels")

install.packages("caret")
library("caret")

#load the data
companydata <- read.csv(file.choose())
View(companydata)

hist(companydata$Sales)

high=ifelse(companydata$Sales<10,"No","Yes")
CD=data.frame(companydata,high)

#split the data into test and train data
cd_train <- CD[1:200,]
cd_test <- CD[201:400,]

colnames(companydata)

#using party function
op_tree =ctree(high~CompPrice+Income+Advertising+Population+Price+ShelveLoc+Age+Education+Urban+US,data=cd_train)
summary(op_tree)
# Length      Class       Mode 
#   1     BinaryTree       S4 

plot(op_tree)

# On looking into the Above tree, i see that if the Location of the Shelv is good,
# then there is a probability of 60% chance that the customer will buy.
# With ShelveLoc having a Bad or Medium and Price <= 87, the probability of High sales 
# could be 60%.
# If ShelveLoc is Bad or Medium, With Price >= 87 and Advertising less then <= 7 then there
# is a zero percent chance of high sales.
# If ShelveLoc is Bad or Medium, With Price >= 87 and Advertising less then > 7 then there
# is a 20 % percent chance of high sales.

pred_tree <- as.data.frame(predict(op_tree,newdata=cd_test))
pred_tree["final"] <- NULL
pred_test_df <- predict(op_tree,newdata=cd_test)

mean(pred_test_df==CD$high)#accuracy
#accuracy 0.6875=>68%

CrossTable(cd_test$high,pred_test_df)

confusionMatrix(cd_test$high,pred_test_df)
#Confusion Matrix and Statistics

#Reference
#Prediction  No Yes
#No  131  31
#Yes  10  28

#Accuracy : 0.795           
#95% CI : (0.7323, 0.8487)
#No Information Rate : 0.705           
#P-Value [Acc > NIR] : 0.002590        

#Kappa : 0.4503          

#Mcnemar's Test P-Value : 0.001787        
"""                                         
            Sensitivity : 0.9291          
            Specificity : 0.4746          
         Pos Pred Value : 0.8086          
         Neg Pred Value : 0.7368          
             Prevalence : 0.7050          
         Detection Rate : 0.6550          
   Detection Prevalence : 0.8100          
      Balanced Accuracy : 0.7018          
                                          
       'Positive' Class : No
       
"""
###using tree function
cd_tree_org <- tree(high~.-Sales,data=CD)
summary(cd_tree_org)

#Number of terminal nodes:  21 
#Residual mean deviance:  0.297 = 112.6 / 379 
#Misclassification error rate: 0.0725 = 29 / 400

plot(cd_tree_org)
text(cd_tree_org,pretty=0)


##using the training data

#use the tree function
cd_tree <- tree(high~.-Sales,data=cd_train)
summary(cd_tree)
#Number of terminal nodes:  12 
#Residual mean deviance:  0.2927 = 55.02 / 188 
#Misclassification error rate: 0.08 = 16 / 200 

plot(cd_tree)
text(cd_tree,pretty = 0)

### Evaluate the Model

# Predicting the test data using the model
pred_tree <- as.data.frame(predict(cd_tree,newdata=cd_test))
pred_tree["final"] <- NULL
pred_test_df <- predict(cd_tree,newdata=cd_test)


pred_tree$final <- colnames(pred_test_df)[apply(pred_test_df,1,which.max)]

pred_tree$final <- as.factor(pred_tree$final)
summary(pred_tree$final)

#No Yes 
#172  28

summary(cd_test$high)
#No Yes 
#162  38

mean(pred_tree$final==CD$high) 
# Accuracy = 77.25

CrossTable(cd_test$high,pred_tree$final)

confusionMatrix(cd_test$high,pred_tree$final)
"""Confusion Matrix and Statistics

          Reference
Prediction  No Yes
       No  153   9
       Yes  19  19
                                          
               Accuracy : 0.86            
                 95% CI : (0.8041, 0.9049)
    No Information Rate : 0.86            
    P-Value [Acc > NIR] : 0.55018         
                                          
                  Kappa : 0.4942          
                                          
 Mcnemar's Test P-Value : 0.08897         
                                          
            Sensitivity : 0.8895          
            Specificity : 0.6786          
         Pos Pred Value : 0.9444          
         Neg Pred Value : 0.5000          
             Prevalence : 0.8600          
         Detection Rate : 0.7650          
   Detection Prevalence : 0.8100          
      Balanced Accuracy : 0.7841          
                                          
       'Positive' Class : No 
       
"""
