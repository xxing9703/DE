dim=50;
A=500;
lb=-A*ones(1,dim);
ub=A*ones(1,dim);
x=A*(rand(1,dim)*2-1);

popu=30;
gene=1000;

myfun=@(x)LV_fit01(x,vi);
%myfun=@(x)fit02(x);

opts = gaoptimset(@ga);
opts = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotstopping});
opts = gaoptimset(opts,'Generations',gene,'StallGenLimit', 200,'TimeLimit', 10*3600);
opts = gaoptimset(opts,'PopulationSize',popu);

[x fval]= ga(myfun,dim,[],[],[],[],lb,ub,[],[],opts);
fval
