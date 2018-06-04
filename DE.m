while k <=iter
    for i=1:NP    
       i1=ceil(NP*rand(1));
        while (i1==i)
             i1=ceil(NP*rand(1));
        end
        i2=ceil(NP*rand(1));
        while ((i2==i)||(i2==i1))
             i2=ceil(NP*rand(1));
        end
        i3=ceil(NP*rand(1));
        while ((i3==i)||(i3==i1)||(i3==i2))
             i3=ceil(NP*rand(1));
        end
        i4=ceil(NP*rand(1));
        while ((i4==i)||(i4==i1)||(i4==i2)||(i4==i3))
             i4=ceil(NP*rand(1));
        end
        i5=ceil(NP*rand(1));
        while ((i5==i)||(i5==i1)||(i5==i2)||(i5==i3)||(i5==i4))
             i5=ceil(NP*rand(1));
        end
           
        F=normrnd(0.5,0.3);    
     
        pp=rand(1);
        
        if pp>0&&pp<=0.25     
           V(i,:)= W(i1,:) + F.*(W(i2,:)-W(i3,:));
           sign=1;
        end 
        if pp>0.25&&pp<=0.5   
           V(i,:)= W(i,:) + F.*(W(max_index,:)-W(i,:))+ F.*(W(i1,:)-W(i2,:))+F.*(W(i3,:)-W(i4,:)); 
           sign=2;
        end 
        if pp>0.5&&pp<=0.75  
            V(i,:)=W(i1,:)+F.*(W(i2,:)-W(i3,:))+F.*(W(i4,:)-W(i5,:));  
            sign=3;
        end 
        if pp>0.75&&pp<=1  
            V(i,:)=W(i,:)+K.*(W(i1,:)-W(i,:))+F.*(W(i2,:)-W(i3,:)); 
            sign=4;
        end 
      
   
        for j=1:n
            if V(i,j)<lb||V(i,j)>ub
              V(i,j)=lb+(ub-lb)*rand;
            end 
       end  
          if sign==4  
           U(i,:)=V(i,:);   
          end 
     CR=normrnd(0.5,0.1);
          while CR<=0||CR>1            
          CR=normrnd(0.5,0.1);   
          end 
       
    
       if sign==1||sign==2||sign==3
        for j=1:n
            jrand=ceil(n*rand(1));  
            if((rand(1)<=CR)||(j==jrand))
                U(i,j)=V(i,j);
            end
        end
       end
  %%%call labview VI input=U, output=fit_   
    vi.SetControlValue('input',U(i,:))
    vi.Run
    fit_=vi.GetControlValue('fitness');  
  %%%call labview VI input=U, output=fit_ 
    %fit_=fit01(U(i,:));
  
        if fit_>=fit(i)     
           W_next(i,:) = U(i,:);   
           fit(i)=fit_;     
        end
      
        
   end 
   
   [max_fit, max_index]=max(fit);    %间接对fix序列进行排序，输出最高值。
   W=W_next; %更新种群，进入下一次演化过程
   U=W;
   
   Result=[Result,max_fit];   
    if mod(k,LP)==0                   
         k                
         max_fit   
         %save EMSDE.mat
    end
     
    k=k+1; 
end




