#!/usr/bin/awk -f

BEGIN {
}
/Processing query/ {
    # output the data for this query
    # get the new statement
    gen_time_all+=gen_time
    testing_time_all+=testing_time
    stmt_cov_all+=stmt_cov
    branch_cov_all+=branch_cov
    ct++;
}

/AST Node Number/ {astnode=$4}
/Segment Size/ {loc=$4}
/Procedure Number/ {proc=$3}
/Branch Number/ {branch=$3}
/Loop Number/ {loop=$3}
/Compile/ {compile=$2}
/Number of input/ {var=$5}
/Number of test/ {test=$4}
# /Transfer functions/ {
#     trans_ct=0
# }
# /.* = .*/ {trans_ct++}
/Total reach poi/ {reachpoi=$3}
/Total fail poi/ {failpoi=$4}

/Test Generation Time/ {gen_time=$4}
/Testing-Time/ {testing_time=$2}
/Stmt Coverage/ {gsub("%","",$3); stmt_cov=$3}
/Branch Coverage/ {gsub("%","",$3); branch_cov=$3}

END{
    print gen_time_all/ct
    print testing_time_all/ct
    print stmt_cov_all/ct
    print branch_cov_all/ct
}
