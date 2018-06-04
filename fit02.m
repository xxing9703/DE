function y=fit02(x)
D=length(x);

for i=1:D
  tp(i)=x(i)*sin(sqrt(abs(x(i))));
end

y=418.9829*D-sum(tp);

end

