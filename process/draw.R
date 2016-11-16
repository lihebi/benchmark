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
y3=y1/(y1+y2)


##############################
## Some data analysis
##############################

size <- df$size
suc <- df$suc
fail <- df$fail
br <- suc / fail

## buildrate for segments with more than 20 node
suc20 <- sum(suc[size>20])
fail20 <- sum(fail[size>20])
br20 <- suc20 / (suc20 + fail20)


##############################
## Figure
##############################

jpeg('br-by-size.jpg', height=480, width=640)
## png(filename="test2.png", height=295, width=300, bg="white")
## plot(x,y3)
par(mar = c(5,5,2,5))
plot(x,y1,type="o",main="Build Rate By Size",xlab="AST Node count",ylab="count",col="blue")
lines(x,y2,type="o", col="red")
## with(d, plot(x, n, pch=16, axes=F, xlab=NA, ylab=NA, cex=1.2))
## legend("topleft",
##        legend=c(expression(-log[10](italic(p))), "N genes"),
##        lty=c(1,0), pch=c(NA, 16), col=c("red3", "black"))
## length(x)
## length(y3)
par(new=T)
plot(x,y3,type="o",col="black",xlab=NA,ylab=NA,cex=1.2,axes=F)
axis(side = 4)
mtext(side = 4, line=3, 'Build Rate')
## box()
legend("topleft",
       lty=c(1,1,1), pch=c(16,16,16),legend=c("suc","fail","buildrate"), col=c("blue", "red","black"));
## plot(x,y2,type="b",main="buildrate",xlab="AST Node count",ylab="succ/fail num")
## plot(x,y3,type="b",main="buildrate",xlab="AST Node count",ylab="succ/fail num")
dev.off()





csvfile <- "bench.csv"
df <- read.csv(csvfile)
names(df) <- c("proj", "suc", "fail")
df$total <- (df$suc+df$fail)
df$br <- round(df$suc / df$total, digits=3)
## dim(df)
df <- df[which(df$suc+df$fail>0),]
## dim(df)

suc <- df$suc
fail <- df$fail
br <- df$br
x <- c()
## TODO limit the count
for (limit in seq(0.1,1,by=0.1)) {
    x <- c(x,length(which(br < limit & br > limit-0.1)))
}

#################################
## Some statistics about the data
#################################

## number of projects have more than 50% buildrate
length(which(br>=0.5))
## the percentage
length(which(br>=0.5)) / length(br)


##############################
## figure
##############################

jpeg('br-by-proj.jpg')
hist(br,main="Build Rate by Proj",xlab="Build Rate",ylab="Porj Count")
dev.off()


## TODO add statistics
gooddf <- df[which(br>0.8 & suc > 1000),]
write.csv(gooddf, file="goodbench.csv")

## top build rate projects










##############################
## Testing code for plotting
##############################

# Declare the data frame and common aesthetics.
# The summary data frame ds is used to plot
# larger red points in a second geom_point() layer.
# If the data = argument is not specified, it uses the
# declared data frame from ggplot(); ditto for the aesthetics.

df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
# Compute sample mean and standard deviation in each group
ds <- plyr::ddply(df, "gp", plyr::summarise, mean = mean(y), sd = sd(y))

jpeg('testplot.jpg')
ggplot(df, aes(x = gp, y = y)) +
   geom_point() +
   geom_point(data = ds, aes(y = mean),
              colour = 'red', size = 3)
## ggplot(df)
## + geom_point(aes(x=x,y=y1))
## + geom_point(data = ds, aes(x = gp, y = mean),
##              colour = 'red', size = 3)
dev.off()



##############################
## Testing 2
##############################

## png(filename="test2.png", height=295, width=300, bg="white")
jpeg('test2.jpg')
set.seed(2015-04-13)
d = data.frame(x =seq(1,10),
           n = c(0,0,1,2,3,4,4,5,6,6),
           logp = signif(-log10(runif(10)), 2))
par(mar = c(5,5,2,5))
with(d, plot(x, logp, type="l", col="red3", 
             ## ylab=expression(-log[10](italic(p))),
             ## ylim=c(0,3)
             ))
par(new = T)
with(d, plot(x, n, pch=16, axes=F, xlab=NA, ylab=NA, cex=1.2))
axis(side = 4)
mtext(side = 4, line = 3, 'Number genes selected')
legend("topleft",
       legend=c(expression(-log[10](italic(p))), "N genes"),
       lty=c(1,0), pch=c(NA, 16), col=c("red3", "black"))
dev.off()



##############################
## all.csv
## size,loc,proc,branch,loop
##############################

## these are some data that requires parsing a new csv file
## avg AST,line,interprocedure,loops,branch


csvfile <- "all.csv"
df <- read.csv(csvfile)
names(df) <- c("size", "loc", "proc", "branch", "loop")

## avg AST size
## sum(suc * size) / sum(suc)
sum(df$size) / dim(df)[1]
## avg loc
sum(df$loc) / dim(df)[1]
## avg interprocedure
sum(df$proc) / dim(df)[1]
## avg loops
sum(df$loop) / dim(df)[1]
## avg branch
sum(df$branch) / dim(df)[1]


## for loc larger than 100, how many, what's the build rate
length(which(df$loc>25))
pred <- which(df$loc>25)
(df$suc)[pred] / (df$suc[pred] + df$fail[pred])

loc25df <- df[df$loc>25,]
## how many
dim(loc25df)[1]
## build rate
## loc25df$suc / (loc25df$suc + loc25df$fail)
