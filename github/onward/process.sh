#!/bin/bash


## remove [[2k staff
# sed -e '/\[2K/d' ./log-20170327-github-create-cache.txt > log-remove2k.txt


## get data
# awk '
# BEGIN {bench=""}
# /=====/ {bench=$2}

# /Inserting [[:digit:]]* snippets/ {snip=$2}
# /Inserted [[:digit:]]* call graph/ {cg=$2}
# /Total number of entry/ {entry=$5}
# /total dependence/ {dep=$3}

# /real/ {time=$2; print bench, snip, cg, entry, dep, time}

# ' log-remove2k.txt > perf.txt


## analyze data perf.txt

awk '
{print $6}
' perf.txt




# awk '/^\[/ {print $2}'
