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
