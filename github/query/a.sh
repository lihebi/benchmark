#!/bin/bash


# unzip the benchmarks

rm -r unziped
mkdir unziped

for name in data/*; do
    rm -r tmp
    mkdir tmp
    targetname=${name##*/}
    targetname=${targetname%%.zip}
    targetname=unziped/$targetname
    echo -n "unzip " $name " ..."
    unzip -q $name -d tmp
    echo "moving .."
    # there should be only one
    for tmp in tmp/*; do
        mv $tmp $targetname
    done
done

rm -r tmp
