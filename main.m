close all
clear all
clc

% the German matrix: bases of SU(2)
F(:,:,1)=[0 1;1 0]; %F(:,:,k)是Xk
F(:,:,2)=[0 -j;j 0];
F(:,:,3)=[1 0;0 -1];

%caculate the cofficient of bases. (7)
 f=repmat(zeros(3),[1,1,3]);
 g=repmat(zeros(3),[1,1,3]);
for k=1:3;
    Fk=F(:,:,k);
    for l=1:3;
        Fl=F(:,:,l);
        for r=1:3;
            Fr=F(:,:,r);
            f(l,r,k)=-j*0.25*trace((Fl*Fr-Fr*Fl)*Fk);
            g(l,r,k)=0.25*trace((Fl*Fr+Fr*Fl)*Fk);
        end
    end
end

%Parameters of 2 level system
theta =2*pi*rand(1);
H0=[-1/2 0;0 1/2];
H1=cos(theta)*F(:,:,1)+sin(theta)*F(:,:,2);%dipole matrix

L(:,:,1)=[0 0;0.1 0];
L(:,:,2)=[0 0.2;0 0];
L(:,:,3)=[0.2 0;0 0];

%%%% H0  to LH0 in vec_representation.
LH0=zeros(3);
for l=1:3;
    for  r=1:3;
        for k=1:3;
            LH0(l,r)=LH0(l,r)+f(l,r,k)*trace(F(:,:,k)*H0);
        end
    end
end

%%% H1 to LH1
LH1=zeros(3);
for l=1:3;
    for  r=1:3;
        for k=1:3;
            LH1(l,r)=LH1(l,r)+f(l,r,k)*trace(F(:,:,k)*H1);
        end
    end
end
f0=zeros(3,1);
for k=1:3;
    for i=1:3;
        f0(k)=f0(k)+0.5*trace((L(:,:,i)*L(:,:,i)'-L(:,:,i)'*L(:,:,i))*F(:,:,k));
    end
end

% Lindblad operator D[\rho] is transformed to LD.
Ld=0;
for k=1:3;
    Ld=Ld-0.5*trace(L(:,:,k)'*L(:,:,k));
end
LD=zeros(3);
for l=1:3;
    for r=1:3;
        if l==r;
            LD(l,r)=Ld;
        end
        for k=1:3;
            for i=1:3;
                LD(l,r)=LD(l,r)-0.5*g(l,r,k)*trace(F(:,:,k)*L(:,:,i)'*L(:,:,i))+0.5*trace(L(:,:,i)*F(:,:,r)*L(:,:,i)'*F(:,:,l));
            end
        end
    end
end

%density matrix
rho0=[1 0;0 0];%=======initial state (1 0)
rhof=[0 0;0 1];%=======target state (0 1)

%the vector representation of initial and target states
x0=zeros(3,1);
xf=zeros(3,1);
for k=1:3;
    x0(k)=trace(F(:,:,k)*rho0);
    xf(k)=trace(F(:,:,k)*rhof);
end

%============================控制变量的相关参数设置=========================
Nu=200;
tf=10;

h=tf/Nu;
t=0:h:tf;
N=length(t); %N=201

%=========================DE算法的相关参数设置==============================

n = 200; %问题维数，选取2个控制量,每个控制量200维
NP = 50; %种群规模

Result = []; % 记录结果
rand('seed',sum(100*clock));  %指定初值，产生不同的随机序列

%=========================初始化向量========================================
ub=10;lb=-10;%控制量的上下限值
for i=1:NP
    for j=1:n
    W(i,j)=lb+(ub-lb)*rand;
    end
end

V=zeros(NP,n);
U = W; %同时完成其他中间变量的初始化
W_next=W;

%这里重点解释下，
%对于每一次演化过程，W代表的是当前个体组成的种群，V变异过程中产生的临时个体，
%U是交叉过程中产生的临时个体，U初始等于W，然后根据V的变异，概率的形式部分遗传到U中
%（这也是交叉的必要，也就是说前面变异的部分，并不是全部遗传下去）
%W_next是保存此次演化得到的新个体，待所有个体完成演化后，进行统一更新即W=W_next;

%==============先求解适应度函数=============================================
%在演化的过程中只需要对应更新，而不需要每一次种群演化完毕后再次评价

fit=zeros(1,NP);
for i=1:NP,
    fit(i) = fit_de2(W(i,:),LH0,LD,LH1,x0,xf,f0,h,N); % 首次评价
end
[max_fit, max_index]=max(fit);           %适应度排序，找到最好的


%=======迭代前的参数设置====================================================
k =1;
iter = 20000;%迭代次数
LP=100;     %间隔迭代次数，便于显示
sign=0;         %标记变异策略种类，后面需要
F=0;CR=0;K=0.5; %初始化一些参数

EMSDE;  %调用核心程序，开始演化过程

%==========================迭代结束=========================================

%最后求得的W（max_index,:）就是我们要找的最优向量个体



