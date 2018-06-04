function j0= fit_de2ws( u,LH0,LD,LH1,x0,xf,f0,h,N)
%此函数是适应度函数，用以求出每个控制um对应的j0值

E1=zeros(1,N);
for i=1:N-1
    E1(i)=u(i);%=========不加波包===========
end

j0=0;
X=repmat(zeros(3,1),[1 1,N]);     %save the states at all time points
X(:,:,1)=x0;
for i=1:N-1          
      k1=h*((LH0+LD+(E1(i)*LH1))*X(:,:,i)+f0);
      k2=h*((LH0+LD+(E1(i)*LH1))*(X(:,:,i)+0.5*k1)+f0);
      k3=h*((LH0+LD+(E1(i)*LH1))*(X(:,:,i)+0.5*k2)+f0);
      k4=h*((LH0+LD+(E1(i)*LH1))*(X(:,:,i)+k3)+f0);
      X(:,:,i+1)=X(:,:,i)+1/6*(k1+2*k2+2*k3+k4);
end
        xT=X(:,:,N);
        j0=j0+1-1/4*(xf-xT)'*(xf-xT);
end

