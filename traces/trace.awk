#!/usr/bin/awk -f

BEGIN {
}
/Processing query/ {
    # output the data for this query
    # get the new statement
    
}

/AST Node Number/ {astnode=$4}
/Segment Size/ {loc=$4}
/Procedure Number/ {proc=$3}
/Branch Number/ {branch=$3}
/Loop Number/ {loop=$3}
/Compile/ {compile=$2}
/Number of input/ {var=$5}
/Number of test/ {test=$4}
/Transfer functions/ {
    trans_ct=0
}
/.* = .*/ {trans_ct++}
/Total reach poi/ {reachpoi=$3}
/Total fail poi/ {failpoi=$4}

END{}
