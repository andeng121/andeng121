function [Xtoulang]=getX(sorted_x,n,d,m)
A=sortrows(sorted_x,-(d+m+3));
for i=1:n
    if A(i,d+m+1)==1&&A(i,d+m+3)~=inf
        Xtoulang=A(i,:);
        return
    else Xtoulang=sorted_x(1,1:d);
    end
end
