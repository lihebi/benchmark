#!/bin/awk -f

BEGIN {
    print "bench,sel,suc,file,proc,IF,loop,IfNode, LoopNode, pIfNode, pLoopNode ,psize,s,sall";
}

/HEBI: RUNNING/ {
    bench=$3
}

/Rerun this by/ {}

/\[main\] Selected/ {sel=$3}

/Dump Dist for Sel:/ {dist=0}
/\[DumpDist\] File/ {if (dist==0) file=$3}
/\[DumpDist\] Proc/ {if (dist==0) proc=$3}
/\[DumpDist\] If/ {if (dist==0) IF=$3}
/\[DumpDist\] Loop/ {if (dist==0) loop=$3}

# useless
/Dump Dist for Sel Token:/ {dist=1}

/Dump Dist for Patch:/ {dist=2}

/\[DumpDist\] IfNode/ {
    if (dist==2)
        pIfNode=$3;
    else if (dist==0)
        IfNode=$3;
}
/\[DumpDist\] LoopNode/ {
    if (dist==2)
        pLoopNode=$3;
    else if (dist==0)
        LoopNode=$3;
}

/Dump Dist for Patch Token:/ {dist=3}
/\[DumpDist\] Size/ {if (dist==3) psize=$3}

/\[SourceManager\] queried/ {s=$3}
/Snippets used in main.h:/ {sall=$2}

/Success/ {
    suc=1
    OFS=","
    print bench,sel,suc,file,proc,IF,loop,IfNode, LoopNode, pIfNode, pLoopNode ,psize,s,sall;
}
/Failure/ {
    suc=0
    OFS=","
    print bench,sel,suc,file,proc,IF,loop,IfNode, LoopNode, pIfNode, pLoopNode ,psize,s,sall;
}
