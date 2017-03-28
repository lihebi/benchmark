#!/usr/bin/Rscript

csv = read.csv("cache-time.csv")
## pdf("out.pdf")
## plot(csv)
## dev.off()

sink("fast-bench.txt")
print (csv$bench[csv$time < 1])
sink()
