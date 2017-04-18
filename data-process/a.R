## Process the csv data file to produce tables and graphs used in paper



## data = read.csv("log-0416/log-0416-exp-10.csv")


adjustData <- function() {
    for (num in c(1,2,5,10,20,30,40)) {
        file <- paste("log-0416/log-0416-exp-", num, ".csv", sep="")
        print (file)
        tmp <- read.csv(file);
        tmp["fakesel"] <- num;
        write.csv(tmp, paste(num, ".csv", sep=""), row.names=FALSE)
    }
}

## adjustData()

## combine csv into one file

combineData <- function() {
    filenames <- c()
    for (num in c(1,2,5,10,20,30,40)) {
        file <- paste(num, ".csv", sep="")
        filenames <- c(filenames, file)
    }
    alldata <- do.call("rbind", lapply(filenames, read.csv, header = TRUE))
    ## names(alldata[alldata$fakesel==10,])
    write.csv(alldata, "all.csv", row.names=FALSE)
}

## combineData()



##############################
## Refactor of get build rate
##############################

getavg <- function (col) {
    return (round(sum(col) / length(col), digits=2));
}

## return a list
## the list should contain all these data
getBuildRate <- function(df) {
    ret <- c()
    ## meta data
    for (colname in c("file","proc","IF","loop","IfNode","LoopNode","pIfNode","pLoopNode","psize","s","sall")) {
        ## print (getavg(data["file"][,]))
        ## print (round(sum(data$file) / length(data$file), digits=2))
        ret <- c(ret, getavg(df[colname][,]))
    }
    ## build rate
    suc <- length(df$suc[df$suc==1])
    fail <- length(df$suc[df$suc==0])
    total <- suc + fail
    buildrate <- round(suc / total, digits=2)
    ret <- c(ret, c(suc, fail, total, buildrate))
    names(ret) <- c("file", "proc","IF","LOOP","If","Loop", "pIf",
                    "pLoop", "psize", "s","sall", "suc", "fail",
                    "total", "buildrate")
    ## print(paste("1", length(names(ret))))
    ## print(paste("2", length(ret)))
    return (ret)
}

## getBuildRateExcept <- function(df, except) {
##     ## except should be a list of string factors
##     setdiff(df$bench, except)
##     sub <- df[!(df$bench %in% except)]
##     getBuildRate(sub)
## }
## tokenBR <- getBuildRateByToken(df)

getBuildRateByToken <- function(df) {
    ret <- c()
    ret <- data.frame()
    rownames <- c()
    for (num in c(1,2,5,10,20,30,40)) {
        ## tok <- c(tok, num)
        sub <- df[df$fakesel==num,]
        row <- getBuildRate(sub)
        ## print(paste("3", length(row)))
        rownames <- names(row)
        row <- c(num, row)
        ## print(paste("4", length(rownames)))
        ret <- rbind(ret, row)
    }
    names(ret) <- c("tok", rownames)
    ## names(ret) <- c("tok", "file", "proc","IF","LOOP","If","Loop",
    ##                 "pIf","pLoop", "psize", "s","sall", "suc", "fail",
    ##                 "total", "buildrate")
    return (ret)
}

getBuildRateByBench <- function(df) {
    benchCol <- c()
    ret <- data.frame()
    for (level in levels(df$bench)) {
        levelSub <- df[df$bench==level,]
        suc <- sum(levelSub$suc)
        total <- length(levelSub$suc)
        br <- round(suc / total, digits=2)
        benchCol <- c(benchCol, level)
        row <- c(suc, total, br)
        ret <- rbind(ret, row)
        ## print(level)
    }
    ret <- cbind(benchCol, ret)
    names(ret) <- c("bench", "suc", "total", "br")
    return (ret)
}

getCutBuildRate <- function(df) {
    breaks <- c(0, 0.3, 0.6, 0.9)
    benchBR <- getBuildRateByBench(df)
    ret <- data.frame()
    rownames <- c()
    for (b in breaks) {
        ## print(paste("cut break:", b))
        goodBenchNames <- benchBR$bench[benchBR$br>=b]
        ## write the names into file
        filename <- paste("goodbench-",b,".txt",sep="")
        write.csv(goodBenchNames, filename, row.names=FALSE, quote=FALSE)
        ## print(paste("goo bench:", length(goodBenchNames)))
        sub <- df[df$bench %in% goodBenchNames,]
        row <- getBuildRate(sub)
        rownames <- names(row)
        row <- c(b, length(goodBenchNames), row)
        ret <- rbind(ret, row)
    }
    names(ret) <- c("break", "ProjNum", rownames)
    return (ret)
}

## reason graph
## evalute it will not change cutBR
getReason <- function(cutBRLocal) {
    reasonDF1 <- read.csv("reason-0.csv")
    reasonDF2 <- read.csv("reason-0.3.csv")
    reasonDF3 <- read.csv("reason-0.6.csv")
    reasonDF4 <- read.csv("reason-0.9.csv")

    
    reasonCT <- c(dim(reasonDF1)[1],
                  dim(reasonDF2)[1],
                  dim(reasonDF3)[1],
                  dim(reasonDF4)[1])
    ## I'm using cutBR
    ## cutBR[c("break")]
    cutBRLocal <- cbind(cutBRLocal, reasonCT)
    return (cutBRLocal)
}

## read the data
df <- read.csv("all.csv")

tokenBR <- getBuildRateByToken(df)

benchBR <- getBuildRateByBench(df)

allBR <- getBuildRate(df)

cutBR <- getCutBuildRate(df)
cutBR <- getReason(cutBR)


tokenBROutput <- tokenBR[c("tok", "file", "proc", "pIf","pLoop",
                           "psize", "s", "sall", "suc", "fail",
                           "total", "buildrate")]
write.csv(tokenBROutput, "output-token-buildrate.csv", row.names=FALSE, quote=FALSE)
cutBROutput <- cutBR[c("break", "suc", "fail",
                       "total", "buildrate", "reasonCT")]
write.csv(cutBROutput, "output-cut-buildrate.csv", row.names=FALSE, quote=FALSE)





##############################
## Graph
##############################


## build rate graph
br <- benchBR$br
pdf("build-rate-graph.pdf")
dev.control(displaylist = "enable")
par(mfrow=c(2,2),oma=c(5,4,3,3),mar=c(4,3,1,1))
## plot(sort(benchBR$br))
## barplot(sort(benchBR$br))
## boxplot(br, xlab="br")
hist(br,main="")
pietable <- table(cut(br, breaks=c(-1,0.3,0.6,0.9,0.99,1)))
pie(pietable, col=gray(seq(0.4, 1.0, length = 6)),
    labels=paste(names(pietable), pietable)
    )
## Setting br!=1
hist(br[br!=1],main="")
## outlierThred <- boxplot.stats(benchBR$br)$stats[1]
boxstats <- boxplot(br[br!=1], xlab="br!=1")
## goodbr <- br[br>boxstats$stats[2]]
## badbr <- br[br<boxstats$stats[2]]
dev.off()





## construct the graph??
reasonDF1 <- read.csv("reason-0.csv")
reasonDF2 <- read.csv("reason-0.3.csv")
reasonDF3 <- read.csv("reason-0.6.csv")
reasonDF4 <- read.csv("reason-0.9.csv")

drawPie <- function(df, top=-1, title="") {
    if (top==-1) {
        pie(df$Num, labels=df$ID)
    } else {
        select <- c((dim(df)[1]-top+1):dim(df)[1])
        othersum <- sum(df$Num[-select])
        real <- df[select,]
        colors <- rep(rainbow(5),8)
        ## colors <- rep(gray(seq(0.4,1.0,length=8)), 8)
        # TODO color according to ID
        pie(c(real$Num, othersum), labels=c(real$ID, "other"),
            col=c(colors[real$ID], gray(0.5)),
            main=title)
    }
}

pdf("reason-graph.pdf")
dev.control(displaylist = "enable")
par(mfrow=c(2,2),oma=c(0,0,0,0),mar=c(0,0,1,1))
## mtext("Main title", line=2, font=2, cex=1.2)
drawPie(reasonDF1, 5, "br>=0")
drawPie(reasonDF2, 5, "br>=0.3")
## drawPie(reasonDF3, 4, "br>=0.6")
drawPie(reasonDF4, 4, "br>=0.9")
## legend(10,10, "hello legend")
## legend.pie(10, 10, leg.txt, pch = "sSvV", col = c(1, 3), cex = 0.8)
plot.new()
legend("center", c("1:   use of undeclared identifier",
                   "2:   linker command failed",
                   "3:   unknown type name",
                   "4:   no member named",
                   "5:   expected ;",
                   "6:   expected identifier",
                   "7:   field has incomplete type",
                   "8:   redefinition of",
                   "9:   conflicting types for",
                   "10: type name requires a specifier or qualifier",
                   "11: variable has incomplete type",
                   "12: typedef redefinition with different types",
                   "13: duplicate member",
                   "14: expected identifier or",
                   "15: incomplete definition of type",
                   "16: expected expression",
                   "17: array has incomplete element type",
                   "18: expression is not assignable",
                   "19: too few arguments to function call, expected 3, have 2",
                   "20: returning type does not match"
                   ), cex=0.8)
dev.off()

pie(reasonDF2$Num, labels=reasonDF2$ID)


pdf("tmp.pdf")
dev.control(displaylist = "enable")
## Run the example in '?matplot' or the following:
## leg.txt <- c("Setosa     Petals", "Setosa     Sepals",
##              "Versicolor Petals", "Versicolor Sepals")
## y.leg <- c(4.5, 3, 2.1, 1.4, .7)
## cexv  <- c(1.2, 1, 4/5, 2/3, 1/2)
## matplot(c(1, 8), c(0, 4.5), type = "n", xlab = "Length", ylab = "Width",
##         main = "Petal and Sepal Dimensions in Iris Blossoms")
## for (i in seq(cexv)) {
##     text  (1, y.leg[i] - 0.1, paste("cex=", formatC(cexv[i])), cex = 0.8, adj = 0)
##     legend(3, y.leg[i], leg.txt, pch = "sSvV", col = c(1, 3), cex = cexv[i])
## }
## text  (1, 3, paste("cex=8"), cex = 0.8, adj = 0)
## legend(3, 3, leg.txt, pch = "sSvV", col = c(1, 3), cex = 0.8)
op <- par(
  oma=c(0,0,3,0),# Room for the title and legend
  mfrow=c(2,2)
)
for(i in 1:4) {
  plot( cumsum(rnorm(100)), type="l", lwd=3,
  col=c("navy","orange")[ 1+i%%2 ], 
  las=1, ylab="Value",
  main=paste("Random data", i) )
}
par(op) # Leave the last plot
mtext("Main title", line=2, font=2, cex=1.2)
op <- par(usr=c(0,1,0,1), # Reset the coordinates
          xpd=NA)         # Allow plotting outside the plot region
legend(-.1,1.15, # Find suitable coordinates by trial and error
  c("one", "two"), lty=1, lwd=3, col=c("navy", "orange"), box.col=NA)
dev.off()




##############################
## Bad Benchmarks
##############################


##############################
## Benchmark information
##############################

benchdata <- read.csv("bench-info.csv")
benchNum <- dim(benchdata)[1]
benchAvg <- round(sum(benchdata$size) / benchNum, digits=2)
benchDF <- data.frame()
benchDF <- rbind(benchDF, c(benchNum, benchAvg, max(benchdata$size), min(benchdata$size)))
names(benchDF) <- c("Bench Num", "Avg Size", "Max Size", "Min Size")
write.csv(benchDF, "output-bench-info.csv", row.names=FALSE, quote=FALSE)




##############################
## Testing
##############################


testDF <- data.frame()
for (num in c(1:10)) {
    testDF <- rbind(testDF, c(num, num+1))
}
print(testDF)
