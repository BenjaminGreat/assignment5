title: "Assignment 5 - Decision Trees"
author: "Charles Lang"
date: "November 9, 2016"
output: html_document
---
  For this assignment we will be using data from the Assistments Intelligent Tutoring system. This system gives students hints based on how they perform on math problems. 

#Install & call libraries
```{r}
install.packages("party", "rpart")

library(rpart)
library(party)
```

#Upload Data
```{r}
D1 <-"Users/Ben/Documents/Assignment55.Rproj/intelligent_tutor.csv"


D1 <- read.table("intelligent_tutor.csv", sep = ",", header = TRUE)
```

##Classification Tree
First we will build a classification tree to predict which students ask a teacher for help, which start a new session, or which give up, based on whether or not the student completed a session (D1$complete) and whether or not they asked for hints (D1$hint.y). 
```{r}

RS <- sample( DF$2D, 100, replace = 500)

DF$holdout <- match(RS, DF$10)

c.tree <- rpart(action ~ hint.y + complete, method="class", data=D1) #Notice the standard R notion for a formula X ~ Y

#Look at the error of this tree
printcp(c.tree)

#Plot the tree
post(c.tree, file = "tree.ps", title = "Session Completion Action: 1 - Ask teacher, 2 - Start new session, 3 - Give up")

```
#Regression Tree

We want to see if we can build a decision tree to help teachers decide which students to follow up with, based on students' performance in Assistments. We will create three groups ("teacher should intervene", "teacher should monitor student progress" and "no action") based on students' previous use of the system and how many hints they use. To do this we will be building a decision tree using the "party" package. The party package builds decision trees based on a set of statistical stopping rules.

#Take a look at our outcome variable "score"
```{r}
hist(D1$score)
```

#Create a categorical outcome variable based on student score to advise the teacher using an "ifelse" statement
```{r}
D1$advice <- ifelse(D1$score <=0.4, "intervene", ifelse(D1$score > 0.4 & D1$score <=0.8, "monitor", "no action"))
```

#Build a decision tree that predicts "advice" based on how many problems students have answered before, the percentage of those problems they got correct and how many hints they required
```{r}
score_ctree <- ctree(factor(advice) ~ prior_prob_count + prior_percent_correct + hints, D1)
```

#Plot tree
```{r}
plot(score_ctree)
```

Please interpret the tree, which two behaviors do you think the teacher should most closely pay attemtion to?

##I'm not sure. Maybe complete action. 



#Test Tree
Upload the data "intelligent_tutor_new.csv" and use the predict function (D2$prediction <- predict(score_ctree, D2)) to predict the assignments of the new data set. What is the error rate on your predictions of the new data? 
