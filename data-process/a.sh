#!/bin/bash

BENCH_DIR=$HOME/data/unziped



## should be run by ./a.sh bench-info > bench-info.csv
## should not run in emacs because emacs does not support stderr and stdout
if [ $1 == "bench-info" ]; then
    # redirect stdout to bench-info.csv
    num=0
    echo "bench, size"
    for bench in $BENCH_DIR/*; do
        num=$((num+1))
        simplename=${bench##$BENCH_DIR/}
        echo $num >&2
        echo -n $simplename ", "
        size=`cloc --include-lang='C,C/C++ Header' --sum-one $bench | awk '/SUM/ {print $5}'`
        if [ -z $size ]; then
            echo $bench " got empty cloc result. Using 0" >&2
            size="0"
        fi
        echo $size
    done
fi

# echo "testing"
# size=`cloc --include-lang='C,C/C++ Header' --sum-one ~/data/unziped/polachok--py-phash | awk '/SUM/ {print $5}'`
# echo $size
# if [ -z $size ]; then
#     echo "empty"
# fi




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

if [ $1 == "analyze-error" ]; then
    # $2 should be the log file
    awk '
/NO\./ {print}
/HEBI: RUNNING/ {print}
/[[:digit:]]: error:/ {if (err) {print; err=0;}}
/Success/ {err=1}
/Failure/ {err=1}
' $2
fi

if [ $1 == "sort-error" ]; then
    cat $2 | grep 'error:' | sed -e "s#'.*##" | sed -e "s/^.*error//" | sort | uniq -c | sort -n
fi

if [ $1 == "analyze-combine-error" ]; then
    rm -r error.txt
    for name in log-0416/*.txt; do
        echo $name
        ./a.sh analyze-error $name >> error.txt
    done
fi

if [ $1 == "reason-error" ]; then
    # $2 should be the error file
    # $3 should be the good benchmark file
    ./a.py error.txt goodbench-0.txt > error-0.txt
    ./a.py error.txt goodbench-0.3.txt > error-0.3.txt
    ./a.py error.txt goodbench-0.6.txt > error-0.6.txt
    ./a.py error.txt goodbench-0.9.txt > error-0.9.txt

    ./a.sh sort-error error-0.txt > reason-0.txt
    ./a.sh sort-error error-0.3.txt > reason-0.3.txt
    ./a.sh sort-error error-0.6.txt > reason-0.6.txt
    ./a.sh sort-error error-0.9.txt > reason-0.9.txt
fi
