############################## diabetes ######################
library(corrplot)
library(caret)

#load dataset
data <- read.csv(file.choose())
View(diabetes)
head(diabetes)


data$Class.variable <- as.numeric(as.factor(data$Class.variable))
#yes=>2 no=>1
head(data$Class.variable)

str(data)

#We use "sapply"" to check the number of missing values in each columns.
sapply(data,function(x) sum(is.na(x)))

corrplot(cor(data[, -9]), type = "lower", method = "number")

# Training The Model
set.seed(123)
install.packages("randomForest")

library(randomForest)

# Training The Model
set.seed(12345)
ratio = sample(1:nrow(data), size = 0.20*nrow(data))
test.data = data[ratio,] #Test dataset 20% of total
train.data = data[-ratio,] #Train dataset 80% of total

#random forest
set.seed(1234567)
rf.model <- randomForest(Class.variable~., data = train.data, importance=TRUE)
print(rf.model)

# Tune only mtry parameter using tuneRF()
set.seed(1234567)      
res <- tuneRF(x = subset(train.data, select = -Class.variable),
              y = train.data$Class.variable,
              ntreeTry = 500,
              plot = TRUE, tunecontrol = tune.control(cross = 5))

res[res[, 2] == min(res[, 2]), 1]

set.seed(1234567)
rf.model <- randomForest(Class.variable~., data = train.data, importance = TRUE, mtry = 2)
rf.model










