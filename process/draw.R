#!/usr/bin/Rscript

library(ggplot2)
## data:
## | size | true | false |

csvfile <- "data.csv"
df <- read.csv(csvfile)

names(df) <- c("size", "suc", "fail")
x=df$size
y1=df$suc
y2=df$fail
y3=df$sub/(df$suc+df$fail)

jpeg('buildrate.jpg')
plot(x,y1,type="b",main="buildrate",xlab="AST Node count",ylab="succ/fail num")
## plot(x,y2,type="b",main="buildrate",xlab="AST Node count",ylab="succ/fail num")
## plot(x,y3,type="b",main="buildrate",xlab="AST Node count",ylab="succ/fail num")
dev.off()


df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
# Compute sample mean and standard deviation in each group
ds <- plyr::ddply(df, "gp", plyr::summarise, mean = mean(y), sd = sd(y))

# Declare the data frame and common aesthetics.
# The summary data frame ds is used to plot
# larger red points in a second geom_point() layer.
# If the data = argument is not specified, it uses the
# declared data frame from ggplot(); ditto for the aesthetics.

jpeg('buildrate.jpg')
ggplot(df, aes(x = gp, y = y)) +
   geom_point() +
   geom_point(data = ds, aes(y = mean),
              colour = 'red', size = 3)
## ggplot(df)
## + geom_point(aes(x=x,y=y1))
## + geom_point(data = ds, aes(x = gp, y = mean),
##              colour = 'red', size = 3)
dev.off()
