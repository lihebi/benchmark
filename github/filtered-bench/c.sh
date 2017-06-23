#!/bin/bash


echo -n "Number of all segments (x2): "
cat log-console.txt | grep SourceManager | awk '{print $4,$8}' | wc -l
echo -n "Number of all segments with variable (x2): "
cat log-console.txt | grep SourceManager | awk '{if ($4>0 && $8>0) print $4,$8}' | wc -l

# connecting ID with
# sel-ID, path, IOData I,O


