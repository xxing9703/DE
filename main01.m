clear
n = 50;
NP = 30;
Result = [];
U=zeros(NP,n);
V=zeros(NP,n);
W_next=zeros(NP,n);


A=500;
lb=-A;
ub=A;
%x=A*(rand(1,dim)*2-1);


for i=1:NP
    for j=1:n
    W(i,j)=lb+(ub-lb)*rand;
    end
end

fit=zeros(1,NP);
for i=1:NP,
    fit(i) = fit01(W(i,:)); 
end
[max_fit, max_index]=max(fit);           



k =1;
iter = 1000;
LP=10;     

F=0;CR=0;K=0.5; 
e=actxserver('LabVIEW.Application');
vipath='C:\Users\xxing\Documents\MATLAB\Daoyi_DE\fit02.vi';
vi=invoke(e,'GetVIReference',vipath);

DE