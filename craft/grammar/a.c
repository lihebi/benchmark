struct A {
  int a;
  int b;
};

int foo(int a, int b) {
  int c=8,d;
  int e;
  A aa;
  while (a<c) {
    a=b;
    if (b>0) {
      d=c+e;
    } else if (b < 10) {
      e+=c+b;
      a=8;
    }
    a++;
  }
  for (int i=0;i<c;i++) {
    a+=i;
  }
}
