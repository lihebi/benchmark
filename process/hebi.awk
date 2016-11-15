#!/usr/bin/awk -f

BEGIN {
    bench=""
}


# for each benchmark, i want to collect their build rate first


# The first table I want is to collect the
# Y: buildrate
# X: size of program (AST)
# The Y axis will need: succnum, failnum

/^Benchmark Name/ {
    # output the previous benchmark
    if (length(bench)>0) {
        print bench
    }
    # if 
    bench=$3;
    print bench
}
/^Starting Helium on/ {poi_start=1;}
# /^Processing query with head node/ {query_start=1}
# /Input Variables/ {input_var++;}
/AST Node Number/ {nodenum=$4}
# /Segment Size/ {loc=$4}
# /Procedure Number/ {proc=$3}
# /Branch Number/ {branch=$3}
# /Loop Number/ {loop=$3}
/Compile/ {
    compile=$2
    # log down the data
    # print nodenum, $2
    if ($2 == "true") {
        print nodenum >> "true.txt"
    } else {
        print nodenum >> "false.txt"
    }
}



END {}
