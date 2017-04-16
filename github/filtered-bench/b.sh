#!/bin/bash


# running experiment

# tar zcvf log-0415-exp-30-cache-2.tar.gz  --exclude=a.out --exclude=*.gcno cache/_home_hebi_data_unziped_EZLippi--WebBench/gen/94.sel/


for num in 1 2 5 10 20 30 40; do
    echo "NUM = $num"
    echo "Creating Sel .."
    ./a.sh create-sel $num >/dev/null
    echo "Runnig Helium .."
    rm -f log-0416-exp-$num.txt
    ./a.sh run-helium-part | tee -a log-0416-exp-$num.txt > /dev/null
    echo "Compressing result .."
    tar zcf log-0416-exp-$num.txt.tar.gz log-0416-exp-$num.txt
    echo "Compressing cache .."
    tar zcf log-0416-exp-$num.cache.tar.gz --exclude=a.out --exclude=*.gcno ~/.helium.d/cache
done
