close all
clear all
clc

% the German matrix: bases of SU(2)
F(:,:,1)=[0 1;1 0]; %F(:,:,k)��Xk
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

%============================���Ʊ�������ز�������=========================
Nu=200;
tf=10;

h=tf/Nu;
t=0:h:tf;
N=length(t); %N=201

%=========================DE�㷨����ز�������==============================

n = 200; %����ά����ѡȡ2��������,ÿ��������200ά
NP = 50; %��Ⱥ��ģ

Result = []; % ��¼���
rand('seed',sum(100*clock));  %ָ����ֵ��������ͬ���������

%=========================��ʼ������========================================
ub=10;lb=-10;%��������������ֵ
for i=1:NP
    for j=1:n
    W(i,j)=lb+(ub-lb)*rand;
    end
end

V=zeros(NP,n);
U = W; %ͬʱ��������м�����ĳ�ʼ��
W_next=W;

%�����ص�����£�
%����ÿһ���ݻ����̣�W������ǵ�ǰ������ɵ���Ⱥ��V��������в�������ʱ���壬
%U�ǽ�������в�������ʱ���壬U��ʼ����W��Ȼ�����V�ı��죬���ʵ���ʽ�����Ŵ���U��
%����Ҳ�ǽ���ı�Ҫ��Ҳ����˵ǰ�����Ĳ��֣�������ȫ���Ŵ���ȥ��
%W_next�Ǳ���˴��ݻ��õ����¸��壬�����и�������ݻ��󣬽���ͳһ���¼�W=W_next;

%==============�������Ӧ�Ⱥ���=============================================
%���ݻ��Ĺ�����ֻ��Ҫ��Ӧ���£�������Ҫÿһ����Ⱥ�ݻ���Ϻ��ٴ�����

fit=zeros(1,NP);
for i=1:NP,
    fit(i) = fit_de2(W(i,:),LH0,LD,LH1,x0,xf,f0,h,N); % �״�����
end
[max_fit, max_index]=max(fit);           %��Ӧ�������ҵ���õ�


%=======����ǰ�Ĳ�������====================================================
k =1;
iter = 20000;%��������
LP=100;     %�������������������ʾ
sign=0;         %��Ǳ���������࣬������Ҫ
F=0;CR=0;K=0.5; %��ʼ��һЩ����

EMSDE;  %���ú��ĳ��򣬿�ʼ�ݻ�����

%==========================��������=========================================

%�����õ�W��max_index,:����������Ҫ�ҵ�������������



