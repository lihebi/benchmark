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
        # FIXME zlib:1.2.11
        # FIXME ncurses+20170128
        # FIXME openssl 1.0.2.k-1
        # FIXME libedit_3.1
        # FIXME sudop2
        # FIXME wireless_toolspre9
        # FIXME anjuta+1+g2bd433c
        # FIXME atkmm+1+gf30b47f
        # FIXME autoconf2.13
        # FIXME bind-toolsP3
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

# function testname() {
#     for name in $1/*; do
#         echo ${name##*/} | sed -e 's/\([-:+][0-9\.]\{1,\}\)*//g'
#         echo -e "\t" $name
#     done
# }

# if [ $1 == "hebi" ]; then
#     for repo in core extra community multilib; do
#         testname $repo.files
#     done
# fi

if [ $1 == "analyze" ]; then
    for repo in core extra community multilib; do
        echo "parsing $repo ..."
        echo "[" > $repo.json 
        parse $repo.files | sed -e '$ s/,$//' >> $repo.json
        echo "]" >> $repo.json
    done
fi


if [ $1 == "index" ]; then
    echo "======= core" > package-index.txt
    cat core.txt >> package-index.txt
    echo "======= extra" >> package-index.txt
    cat extra.txt >> package-index.txt
    echo "======= community" >> package-index.txt
    cat community.txt >> package-index.txt
    echo "======= multilib" >> package-index.txt
    cat multilib.txt >> package-index.txt

    sed -i -n -e '/\"package/p; /=====/p' package-index.txt
fi
