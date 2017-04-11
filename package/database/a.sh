#!/bin/bash



# download core.files.tar.gz, xxx, xxx from arch mirror

# analyze the database files and generate a header.conf file


if [ $1 == "extract" ]; then
    tar zxvf core.files.tar.gz -C core.files/
    tar zxvf extra.files.tar.gz -C extra.files/
    tar zxvf community.files.tar.gz -C community.files/
    tar zxvf multilib.files.tar.gz -C multilib.files/
fi

# if usr/include/xxx.h
# xxx.h
# if usr/include/xxx-1.0/xxx.h
#INC /path/
# xxx.h
# if /usr/lib/libxxx.so
# -lxxx

function getsize() {
    sed -n -e '/CSIZE/ {n;p;q}' $1
}


# {
#     "package": "ruby",
#     "headers": ["ruby.h"],
#     "include": ["/usr/include/ruby-2.4.0", "/usr/include/ruby-2.4.0/x86_64-linux"],
#     "lib": ["-lruby"]
#     }

function parse() {
    for name in $1/*; do
        echo "$name" 1>&2
        echo "{"
        # echo $name
        # package name
        package=`echo ${name##*/} | sed -e 's/\(-[0-9\.]\{1,\}\)*//g'`
        echo "\"package\": \"$package\","
        # size
        size=`getsize $name/desc`
        echo "\"size\": \"$size\","
        # maybe analyze the size

        # include path
        echo -n "\"includes\": ["
        awk 'BEGIN {ORS=" "} /\.h$/ {print "\"/" $0 "\","} ' $name/files |\
            sed -e "s/, $//"
        echo "],"

        # flags
        echo -n "\"libs\": ["
        awk 'BEGIN {ORS=" "} /\.so$/ {print "\"/" $0 "\","} ' $name/files |\
            sed -e "s/, $//"
        echo "]"

        echo "},"
    done
}

if [ $1 == "analyze" ]; then
    for repo in core extra community multilib; do
        echo "parsing $repo ..."
        echo "[" > $repo.json 
        parse $repo.files | sed -e '$ s/,$//' >> $repo.json
        echo "]" >> $repo.json
    done
fi
