#!/bin/bash

# for name in *.zip; do
#     fold=${name%.zip}
#     echo $fold
#     unzip $name -d $fold
#     # rm -rf $fold
#     # cloc $fold | awk '/^C\>/ {print $5}'
# done


for name in *; do
    if [ -d $name ]; then
        echo -n $name ","
        cloc $name | awk 'BEGIN{loc=0;}; /^C\>/ {loc+=$5;}; END {print loc}'
    fi
done
