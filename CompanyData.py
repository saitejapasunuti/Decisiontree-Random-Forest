# -*- coding: utf-8 -*-
"""
Created on Mon Jul 27 12:11:40 2020

@author: saiteja pasunuti
"""
############## DECISION TREE ################
import pandas as pd
#pandas is used for data manipulation
import numpy as np
#numpy is used for numerical data

data=pd.read_csv("D:/360digiTMG/unsupervised/mod19 Decisiontree&Random Forest/Company_Data.csv/Company_Data.csv")

data.head()
data.info()

data.Sales=data.Sales.astype('int64')
data.info()

data=pd.get_dummies(data,columns=None)
data.info()
colnames=list(data.columns)
type(data.columns)

predictors=colnames[1:15]

target=colnames[0]


#splitting the data into train and test datasets
from sklearn.model_selection import train_test_split
train,test=train_test_split(data,test_size=0.2)

from sklearn.tree import DecisionTreeClassifier as DT

model=DT(criterion="entropy")

model.fit(train[predictors],train[target])
data.info()

# Prediction on Train Data
preds = model.predict(train[predictors])
pd.crosstab(train[target],preds,rownames=['Actual'],colnames=['Predictions'])

np.mean(preds==train[target]) # Train Data Accuracy
# 1.0

# Prediction on Test Data
preds = model.predict(test[predictors])
pd.crosstab(test[target],preds,rownames=['Actual'],colnames=['Predictions'])

np.mean(preds==test[target]) # Test Data Accuracy 
# 0.15