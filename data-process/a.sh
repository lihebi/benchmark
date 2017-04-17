#!/bin/bash

BENCH_DIR=$HOME/data/unziped

if [ $1 == "bench-info" ]; then
    # redirect stdout to bench-info.csv
    num=0
    echo "bench, size"
    for bench in $BENCH_DIR/*; do
        num=$((num+1))
        simplename=${bench##$BENCH_DIR/}
        echo $num >&2
        echo -n $simplename ", "
        cloc --include-lang='C,C/C++ Header' --sum-one $bench | awk '/SUM/ {print $5}'
    done
fi


# if [ $1 == "process-log" ]; then
#     echo "bench,sel,suc,fail,file,proc,if,loop,pif,ploop,psize,s,sall"
#     # $2 is the log file
#     awk -f process-log.awk $2
# fi


if [ $1 == "process-log" ]; then
    for name in log-0416/*.txt; do
        echo $name
        awk -f process-log.awk $name > ${name%%.txt}.csv
    done
fi
