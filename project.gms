sets
p index for period /p1*p2/
a index for age/a1*a2/
t index for truck/t1*t2/
s index for shovel/s1,s2/
d index for dumpsite/d1*d3/
parameters
C(t) capacity of truck type t/t1 180,t2 280/
CL(t) cost of truck type t when loaded per Kilometer/t1 1.8,t2 2.5/
CUL(t) cost of truck type t when unloaded per Kilometer/t1 1,t2 1.5/
SP(t) speed of truck type t/t1 28,t2 28/
AT(p) available working time in period p/p1 12,p2 12/;
table AW(s,p) available waste at shovel s in period p
         p1      p2
s1       12500   12500
s2       10500   10500;

table PR(d,p) production requirement of the dumpsite d in period p
         p1      p2
d1       7000    7000
d2       7000    7000
d3       7000    7000;
table DC(t,a,p) discounted cost value for truck type t age bin a in period p
         p1      p2
t1.a1    200     300
t1.a2    300     250
t2.a1    350     250
t2.a2    240     200;


table LSS(t,s) loading speed for truck type t in shovel s
         s1      s2
t1       1848    1848
t2       1848    1848;

table LSD(t,d) loading speed for truck type t in dumpsite d
         d1      d2      d3
t1       3078    3078    3078
t2       3078    3078    3078;
table F(s,d) distance from shovel s to dumpsite d
         d1      d2      d3
s1       2       3       5
s2       1       2       4;
table CP(t,a) amount of catbon produced by truck type t age bin a per hour
         a1      a2
t1       1       1.8
t2       1     1.8;

variables
Z
integer variable X(t,a,s,d,p)
integer variable Y(t,a,s,d,p)
;
equations
objectiveFunction
co3(s,p)
co4(d,p)
co5(s,p,a,t)
co6(d,p,a,t)
co7(p)
co8(p);
objectiveFunction .. Z=e= sum((p,a,t,s,d), X(t,a,s,d,p)*CL(t)*F(s,d))+sum((p,a,t,s,d),Y(t,a,s,d,p)*CUL(t)*F(s,d))+sum((p,a,t,s,d),(X(t,a,s,d,p)+Y(t,a,s,d,p))*DC(t,a,p)*F(s,d));
co3(s,p)          .. sum((t,a,d),C(t)*X(t,a,s,d,p)) =l= AW(s,p);
co4(d,p)          .. sum((t,a,s),C(t)*X(t,a,s,d,p)) =g= PR(d,p);
co5(s,p,a,t)      .. sum((d),X(t,a,s,d,p)) =e= sum((d),Y(t,a,s,d,p));
co6(d,p,a,t)      .. sum((s),X(t,a,s,d,p)) =e= sum((s),Y(t,a,s,d,p));
co7(p)            .. sum((t,a,s,d),X(t,a,s,d,p)*(C(t)/LSS(t,s))) =l= AT(p);
co8(p)            .. sum((t,a,s,d),Y(t,a,s,d,p)*(C(t)/LSD(t,d))) =l= AT(p);

model project2 /all/;
solve project2 using mip minimizing Z;
display Z.l,X.l,Y.l ;



