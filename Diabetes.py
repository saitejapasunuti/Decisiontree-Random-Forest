# -*- coding: utf-8 -*-
"""
Created on Thu Jul 30 22:57:01 2020

@author: saiteja pasunuti
"""

import pandas as pd

# list for column headers
names = ['preg', 'plas', 'pres', 'skin', 'test', 'mass', 'pedi', 'age', 'class']

df = pd.read_csv("D:/360digiTMG/unsupervised/mod19 Decisiontree&Random Forest/Diabetes/Diabetes.csv",names=names)

df=df.drop([0],axis=0)
print(df.shape)
#(768, 9)

# print head of data set
print(df.head())

X = df.drop('class', axis=1)
y = df['class']

#train and test splitting of the data
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=66)

# random forest model creation
from sklearn import model_selection
from sklearn.ensemble import RandomForestClassifier
rfc = RandomForestClassifier()
rfc.fit(X_train,y_train)

# predictions
rfc_predict = rfc.predict(X_test)

from sklearn.model_selection import cross_val_score
from sklearn.metrics import classification_report, confusion_matrix

rfc_cv_score = cross_val_score(rfc, X, y, cv=10, scoring='roc_auc')
print("=== Confusion Matrix ===")
print(confusion_matrix(y_test, rfc_predict))
print('\n')
#=== Confusion Matrix ===
#[[148  28]
# [ 32  46]]

print("=== Classification Report ===")
print(classification_report(y_test, rfc_predict))
print('\n')

print("=== All AUC Scores ===")
print(rfc_cv_score)
print('\n')

print("=== Mean AUC Score ===")
print("Mean AUC Score - Random Forest: ", rfc_cv_score.mean())
#Mean AUC Score - Random Forest:  0.7958561253561253