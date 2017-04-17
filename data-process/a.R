## Process the csv data file to produce tables and graphs used in paper



data = read.csv("log-0416/log-0416-exp-10.csv")


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

## read the data
data <- read.csv("all.csv")

## distribution table
dist <- data.frame()
for (num in c(1,2,5,10,20,30,40)) {
    ## tok <- c(tok, num)
    sub <- data[data$fakesel==num,]
    ## do with sub
    ## compute build rate
    getavg <- function (col) {
        return (round(sum(col) / length(col), digits=2));
    }
    ## token
    tmp <- c(num)
    ## meta data
    for (colname in c("file","proc","IF","loop","IfNode","LoopNode","pIfNode","pLoopNode","psize","s","sall")) {
        ## print (getavg(data["file"][,]))
        ## print (round(sum(data$file) / length(data$file), digits=2))
        tmp <- c(tmp, getavg(sub[colname][,]))
    }
    ## build rate
    suc <- length(sub$suc[sub$suc==1])
    fail <- length(sub$suc[sub$suc==0])
    total <- suc + fail
    buildrate <- round(suc / total, digits=2)
    tmp <- c(tmp, c(suc, fail, total, buildrate))
    dist <- rbind(dist, tmp)
    ## file <- c(file, getavg(data$file))
    ## proc <- c(proc, getavg(data$proc))
    ## IF <- c(IF, getavg(data$IF))
}
names(dist) <- c("tok", "file", "proc","IF","LOOP","If","Loop","pIf","pLoop",
                 "psize", "s","sall", "suc", "fail", "total",
                 "buildrate")
print(dist)
## remove IF and loop column and output
brOutput <- dist[c("tok", "file", "proc", "pIf","pLoop", "psize", "s",
                   "sall", "suc", "fail", "total", "buildrate")]
write.csv(brOutput, "output-buildrate.csv", row.names=FALSE, quote=FALSE)



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
    return (ret)
}

getBuildRateByToken <- function(df) {
    ret <- c()
    ret <- data.frame(stringsAsFactors=FALSE)
    for (num in c(1,2,5,10,20,30,40)) {
        ## tok <- c(tok, num)
        sub <- df[df$fakesel==num,]
        row <- getBuildRate(sub)
        ret <- rbind(ret, row, stringsAsFactors=FALSE)
    }
    names(ret) <- c("file", "proc","IF","LOOP","If","Loop","pIf","pLoop",
                    "psize", "s","sall", "suc", "fail", "total",
                    "buildrate")
    return (ret)
}

getBuildRateByBench <- function(df) {
    ret <- data.frame()
    for (level in levels(df$bench)) {
        levelSub <- df[df$bench==level,]
        suc <- sum(levelSub$suc)
        total <- length(levelSub$suc)
        br <- round(suc / total, digits=2)
        row <- c(level, suc, total, br)
        ret <- rbind(ret, row, stringsAsFactors=FALSE)
        ## print(level)
    }
    names(ret) <- c("bench", "suc", "total", "br")
    return (ret)
}

##############################
## Bad Benchmarks
##############################

badBench <- data.frame()
## badBench <- rbind(c("hello", 99, 100, 0.99))
for (num in c(1,2,5,10,20,30,40)) {
    ## tok <- c(tok, num)
    sub <- data[data$fakesel==num,]
    for (level in levels(sub$bench)) {
        levelSub <- sub[sub$bench==level,]
        suc <- sum(levelSub$suc)
        total <- length(levelSub$suc)
        br <- round(suc / total, digits=2)
        tmp <- c(level, suc, total, br)
        badBench <- rbind(badBench, tmp, stringsAsFactors=FALSE)
        ## print(level)
    }
    break
}
names(badBench) <- c("bench", "suc", "total", "br")
print (badBench)
## print badBench

## Benchmark information

benchdata <- read.csv("bench-info.csv")
benchNum <- dim(benchdata)[1]
benchAvg <- round(sum(benchdata$size) / benchNum, digits=2)
benchDF <- data.frame()
benchDF <- rbind(benchDF, c(benchNum, benchAvg, max(benchdata$size), min(benchdata$size)))
names(benchDF) <- c("Bench Num", "Avg Size", "Max Size", "Min Size")
write.csv(benchDF, "output-bench-info.csv", row.names=FALSE, quote=FALSE)
