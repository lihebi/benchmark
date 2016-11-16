#!/usr/bin/awk -f

BEGIN {
    bench=""
    # clear these files
    print "" > "true.txt"
    print "" > "false.txt"
    print "" > "bench.csv"
    print "size,loc,proc,branch,loop" > "all.csv"
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
        # calculate suc/fail for this proj
        print bench "," benchsuc "," benchfail >> "bench.csv"
    }
    benchsuc=0
    benchfail=0
    # if 
    bench=$3;
    print bench
}
/^Starting Helium on/ {poi_start=1;}
# /^Processing query with head node/ {query_start=1}
# /Input Variables/ {input_var++;}
/AST Node Number/ {nodenum=$4}
/Segment Size/ {loc=$4}
/Procedure Number/ {proc=$3}
/Branch Number/ {branch=$3}
/Loop Number/ {loop=$3}
/Compile/ {
    compile=$2
    # log down the data
    # print nodenum, $2
    if ($2 == "true") {
        benchsuc++
        print nodenum >> "true.txt"
        print nodenum "," loc "," proc "," branch "," loop >> "all.csv"
    } else {
        print nodenum >> "false.txt"
        benchfail++
    }
}



END {}
