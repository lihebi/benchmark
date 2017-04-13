#!/bin/bash


if [ $1 == "unzip" ]; then
    # unzip archive folder to github-bench folder
    rm -r $HOME/data/github-bench/
    for name in $HOME/data/archive/github-benchmarks/*; do
        unzip -o $name -d $HOME/data/github-bench
    done
fi

if [ $1 == "copy-fast" ]; then
    # copy fast benchmark to fast/ folder
    while read -r line; do
        PREFIX="$HOME/data/github-bench/"
        FAST_PREFIX="$HOME/data/fast"
        # cp "$PREFIX/$line.zip" -d "$FAST_PREFIX"
        cp -r "$PREFIX/$line" $FAST_PREFIX
    done < fast-bench-shell.txt
fi


if [ $1 == "helium-cache" ]; then
    ct=0
    for name in $HOME/data/fast/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        helium --create-cache $name
    done
fi


if [ $1 == "create-sel" ]; then
    ct=0
    for name in $HOME/data/fast/*; do
        ct=$((ct+1))
        echo "NO. $ct: " $name
        helium --create-selection --sel-num 100 --sel-tok 1 $name
    done
fi


if [ $1 == "run-helium" ]; then
    ct=0
    for name in $HOME/data/fast/*; do
        ct=$((ct+1))
        # if (( $ct > 19 )) ; then
            echo "NO. $ct: " $name
            helium $name
        # fi
    done
fi



if [ $1 == "analyze" ]; then
    # cat log-helium-fast-sel-1-tok-10-perfile-0407-5.txt\
    #     | grep -e "NO\." -e "error:" -e "undefined reference"
    #  -e "Rerun"
    # -e "Success" -e "Failure"\

    awk '
/NO\./ {printf("%d,%d\n", suc, fail); suc=0;fail=0;}
# /error:/ {print}
# /undefined reference/ {print}
# /Rerun/ {rerun=$0}
# /Success/ {suc++;print "Success"}
# /Failure/ {fail++;print $0 "";}
/Success/ {suc++;}
/Failure/ {fail++;}
END {print "\n"}
' log-single-0411-7.txt
               
fi


if [ $1 == "analyze-error" ]; then
    awk '
/NO\./ {print}
/error:/ {if (err) {print; err=0;}}
/Success/ {err=1}
/Failure/ {err=1}
' $2
fi
