#!/bin/bash


for i in $(seq 40); do
    truect=$(cat true.txt | grep -e "\b$i\b" | wc -l)
    falsect=$(cat false.txt | grep -e "\b$i\b" | wc -l)
    echo "$i,$truect,$falsect" >> data.csv
done
