################# DECISION TREE ##############################

#To Prepare a model on fraud data to check on the probability of Risky Vs Good. Risky patients -Taxable Income <= 30000

install.packages("C50")
install.packages("tree")
#For the demonstration of decision tree
install.packages("caret")
#The caret package (short for Classification And REgression Training) contains functions to streamline the model training process for complex regression and classification problems.
install.packages("gmodels")
install.packages("party")
install.packages("knitr")
install.packages("png")

library(party)
library(caret)
library(C50)
library(tree)
library(gmodels)
library(knitr)
library(png)

FraudCheck <- read.csv(file.choose())
View(FraudCheck)

# Splitting data into training and testing.
# splitting the data based on Sales

hist(FraudCheck$Taxable.Income)

Risky_Good = ifelse(FraudCheck$Taxable.Income<= 30000, "Risky", "Good")
FC = data.frame(FraudCheck,Risky_Good)


FC_train <- FC[1:300,]


FC_test <- FC[301:600,]



###Using Party Function 

png(file = "decision_tree.png")
opall_tree = ctree(Risky_Good ~ Undergrad + Marital.Status + City.Population + Work.Experience + Urban, data = FC)
summary(opall_tree)
# Length      Class       Mode 
#     1     BinaryTree    S4 

plot(opall_tree)
# From the above tree, It looks like the data has 20 % of Risky patients and 80 % good patients


# using the training Data 

png(file = "decision_tree.png")
op_tree = ctree(Risky_Good ~ Undergrad + Marital.Status + City.Population + Work.Experience + Urban, data = FC_train)

plot(op_tree)
summary(op_tree)
#    Length      Class       Mode 
#          1 BinaryTree         S4

pred_tree <- as.data.frame(predict(op_tree,newdata=FC_test))
pred_tree["final"] <- NULL
pred_test_df <- predict(op_tree,newdata=FC_test)


mean(pred_test_df==FC_test$Risky_Good) 
# 0.82=>accuracy=82%

CrossTable(FC_test$Risky_Good,pred_test_df)
confusionMatrix(FC_test$Risky_Good,pred_test_df)
#Confusion Matrix and Statistics

#Reference
#Prediction   Good    Risky
#     Good    246     0
#     Risky   54     0

#Accuracy : 0.82 

