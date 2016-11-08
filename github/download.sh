#!/bin/bash


# download the repos one by one

# if [ ! -d 'data' ]; then
#     mkdir data
# fi

# run this script in a folder, may be "data", and all output will be in "current folder"
# the argument is the repo.txt file

while IFS='' read -r line || [[ -n "$line" ]]; do
    # echo "Text read from file: $line"
    echo "Downloading $line .."
    wget $line
done < "$1"
