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
        row <- c(b, row)
        ret <- rbind(ret, row)
    }
    names(ret) <- c("break", rownames)
    return (ret)
}


## read the data
df <- read.csv("all.csv")

tokenBR <- getBuildRateByToken(df)

benchBR <- getBuildRateByBench(df)

allBR <- getBuildRate(df)

cutBR <- getCutBuildRate(df)


tokenBROutput <- tokenBR[c("tok", "file", "proc", "pIf","pLoop",
                         "psize", "s", "sall", "suc", "fail", "total",
                         "buildrate")]
write.csv(tokenBROutput, "output-token-buildrate.csv", row.names=FALSE, quote=FALSE)
cutBROutput <- cutBR[c("break", "file", "proc", "suc", "fail", "total", "buildrate")]
write.csv(cutBROutput, "output-cut-buildrate.csv", row.names=FALSE, quote=FALSE)



##############################
## Graph
##############################


## build rate graph
br <- benchBR$br
pdf("build-rate-graph.pdf")
dev.control(displaylist = "enable")
par(mfrow=c(2,2))
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


## reason graph
## first, lets prepare the reason data
## write the good benchmark name into file
## use analyze script to extract the first error
## sort

##############################
## Bad Benchmarks
##############################

## now get the build rate
benchBR$bench[benchBR$br>0.6]



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
