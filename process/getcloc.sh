while read -r line; do
    echo $line
    cp "/home/hebi/Documents/githubdata/data/9999/$line.zip" ~/tmp
done < bench.txt
