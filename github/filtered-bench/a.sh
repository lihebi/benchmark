#!/bin/bash

BENCH=$HOME/data/unziped

# first, let me run helium to see how these benchmarks goes

if [ $1 == "create-cache" ]; then
    ct=0
    for name in $BENCH/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        helium --create-cache $name
    done
fi

# error list



if [ $1 == "create-sel" ]; then
    ct=0
    for name in $BENCH/*; do
        ct=$((ct+1))
        # if (( $ct > 1 )); then
        #     break
        # fi
        echo "NO. $ct: " $name
        helium --create-sel --sel-num 100 --sel-tok $2 $name
    done
fi


if [ $1 == "backup-sel" ]; then
    ct=0
    rm -r selback
    mkdir selback
    for name in $BENCH/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        # name of selection
        heliumhome=$HOME/.helium.d
        bench_cache_name=${name//\//_}
        seldir=$heliumhome/cache/$bench_cache_name/sel
        todir=selback/$bench_cache_name/
        mkdir $todir
        cp -r $seldir $todir
    done
fi

if [ $1 == "restore-sel" ]; then
    # $2 should be the folder
    for name in $2/*; do
        # name should be the benchname
        benchname=${name##*/}
        heliumhome=$HOME/.helium.d
        seldir=$heliumhome/cache/$benchname/sel
        rm -r $seldir
        cp -r $name $seldir
    done
fi

if [ $1 == "run-helium" ]; then
    ct=0
    for name in $BENCH/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        helium $name
    done
fi


if [ $1 == "run-helium-part" ]; then
    ct=0
    for name in $BENCH/*; do
        ct=$((ct+1))
        # if (( $ct > 1 )); then
        #     break
        # fi
        # currently total 216 proj
        echo "NO. $ct: " $name
        echo "NO. $ct: " $name >&2
        ratio=1
        rand=`shuf -i 1-$ratio -n 1`
        simplename=${name#$BENCH/}
        if [ $rand == 1 ]; then
            echo "HEBI: RUNNING $simplename"
            { time helium $name; } 2>&1
        fi
    done
fi

if [ $1 == "run-helium-part-rest" ]; then
    ct=0
    for name in $BENCH/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        simplename=${name#$BENCH/}
        cat good-bench.txt bad-bench.txt | grep $simplename >/dev/null
        # cat bad-bench.txt | grep $simplename >/dev/null
        if [ $? != 0 ]; then
            # havent' run
            ratio=2
            rand=`shuf -i 1-$ratio -n 1`
            if [ $rand == 1 ]; then
                echo "HEBI: RUNNING $simplename"
                helium $name
            fi
        fi
    done
fi

if [ $1 == "run-helium-list" ]; then
    ct=0
    for name in $BENCH/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        simplename=${name#$BENCH/}
        # echo $simplename
        cat $2 | grep $simplename >/dev/null
        # cat bad-bench.txt | grep $simplename >/dev/null
        if [ $? == 0 ]; then
            ratio=1
            rand=`shuf -i 1-$ratio -n 1`
            if [ $rand == 1 ]; then
                echo "HEBI: RUNNING $simplename"
                helium $name
            fi
        fi
    done
fi



if [ $1 == "analyze" ]; then
    # $2 should be the log file
    awk '
/NO\./ {print}
/HEBI: RUNNING/ {print}
/error:/ {if (err) {print; err=0;}}
/Success/ {err=1}
/Failure/ {err=1}
' $2
fi



if [ $1 == "analyze2" ]; then
    cat $2 | grep 'error:' | sed -e "s#'.*##" | sed -e "s/^.*error//" | sort | uniq -c | sort -n
fi

# if [ $1 == "print-bad-bench" ]; then
#     awk '
# /NO\./ {if (err>0) print(name, err); err=0;name=$0}
# /error:/ {err+=1;}
# END {if (err>0) print(name, err);}
# ' $2
# fi


if [ $1 == "print-bad-bench" ]; then
    awk '
/NO\./ {if (err>0) print(name, err); err=0;name=$3}
/error:/ {err+=1;}
END {if (err>0) print(name, err);}
' $2
fi

if [ $1 == "print-good-bench" ]; then
    awk '
/NO\./ {if (err==0) print(name, err); err=0;name=$0}
/error:/ {err+=1;}
END {if (err==0) print(name, err);}
' $2
fi
