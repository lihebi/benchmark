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

## build rate table


data <- read.csv("all.csv")


tokCol <- c()
sucCol <- c()
failCol <- c()
brCol <- c()

for (num in c(1,2,5,10,20,30,40)) {
    tokCol <- c(tokCol, num)
    sub <- data[data$fakesel==num,]
    ## do with sub
    ## compute build rate
    sucCol <- c(sucCol, length(sub$suc[sub$suc==1]))
    failCol <- c(failCol, length(sub$suc[sub$suc==0]))
}

totalCol <- sucCol + failCol
brCol <- round(sucCol / totalCol, digits=2)

print (brCol)

br <- data.frame(tokCol, sucCol, failCol, totalCol, brCol)
names(br) <- c("tok", "suc", "fail", "total", "buildrate")

print(br)

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
    ## tok, suc
    for (colname in c("file","proc","IF","loop","IfNode","LoopNode","pIfNode","pLoopNode","psize","s","sall")) {
        ## print (getavg(data["file"][,]))
        ## print (round(sum(data$file) / length(data$file), digits=2))
        tmp <- c(tmp, getavg(sub[colname][,]))
    }
    dist <- rbind(dist, tmp)
    ## file <- c(file, getavg(data$file))
    ## proc <- c(proc, getavg(data$proc))
    ## IF <- c(IF, getavg(data$IF))
}

names(dist) <- c("tok", "suc", "fail", "total", "buildrate", "file","proc","IF","loop","IfNode","LoopNode","pIfNode","pLoopNode","psize","s","sall")

cbind(br, dist)

print(dist)

## output metrics

