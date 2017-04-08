#!/bin/bash


# download

if [ $1 == "download" ]; then
    for dist in core extra community multilib; do
        url="http://mirror.clarkson.edu/archlinux/$dist/os/x86_64/"
        wget $url -O arch-$dist.html
    done
fi

if [ $1 == "process" ]; then
    for name in arch-*.html; do
        awk 'match($0, /href="(.*)">.*<\/a>/, a) && !/sig/ {print a[1],"\t", $5}' $name | sort -k 2 -n > $name.txt
    done
fi

if [ $1 == "get-small" ]; then
    for name in arch-*.html.txt; do
        awk '{if ($2<10000000) print $1}' $name > small.txt
    done
fi

# remove sig line, and sort by last field
# for name in arch-*.txt; do
#     cat $name | awk '!/sig/' | sort -k 4 -n  > sorted-$name
# done
