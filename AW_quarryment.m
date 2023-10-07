%依据狼群的猎物分配规则抽象出的群体更新机制
function [model,count,X]=AW_quarryment(new_Sol,d,m,n,R,lb,ub)%群体更新机制
%X为各人工狼的置，行为个数，列为编码长度；Y为各人工狼位置编码对应的目标函数值；R为要淘汰或饿死的人工狼
for i=1:n
    yy(i,1:m) = obj_funs(new_Sol(i,:), m); 
end
x1=[];
new_Sol=[new_Sol yy];
[sorted_x,nSol]=solutions_sorting(new_Sol,m,d,n);
[Xtoulang]=getX(sorted_x,n,d,m);
Xtoulang=Xtoulang(1,1:d);
%%%
A=sortrows(sorted_x,-(d+m+3));
% for i=1:R
%     XX(i,:)=Xtoulang*(0.1*(-2*rand(1)+1)+1);
%     XX(i,:)=simplebounds(XX(i,1:d),lb,ub);%这里先设置R*m均匀分布的[-jiexian,jiexian]的随机数矩阵作为初始种群的位置状态矩阵(-2*rand(R,m)+1)产生R*m的数值分布于[-1,1]的矩阵
% end
for i=1:R
    XX(i,:)=A(i,1:d)*(0.1*(-2*rand(1)+1)+1);
    XX(i,:)=simplebounds(XX(i,1:d),lb,ub);%这里先设置R*m均匀分布的[-jiexian,jiexian]的随机数矩阵作为初始种群的位置状态矩阵(-2*rand(R,m)+1)产生R*m的数值分布于[-1,1]的矩阵
end
%%%%
% for i=1:n
%     if A(i,d+m+1)==1&&A(i,d+m+3)~=inf
%         Xtoulang=A(i,:);
%         return
%     else Xtoulang=sorted_x(1,1:d);
%     end
% end

% sorted_x=sortrows(sorted_x,35);
for i=1:n
    if sorted_x(i,d+m+1)~=1
        x1=[x1;sorted_x(i,:)];
    end
end
tt=size(x1,1);
if tt>R||tt==R
    X=sorted_x(:,1:d);
    for i=1:R
        %%
        %%X(n-i+1,:)=by_Sol(X(n-i+1,:),m,X,n-i+1,n,d);
        X(n-i+1,:)=XX(i,1:d);
        %%
    end
    for i=1:numel(X)
        if isnan(X(i))==1
            X(i)=rand(1,1);
        end
    end
else
    X=sorted_x(:,1:d);
    for i=1:tt
        %%
        %%X(n-i+1,:)=by_Sol(X(n-i+1,:),m,X,n-i+1,n,d);
        %%
        X(n-i+1,:)=XX(i,1:d);
    end
    A=sortrows(sorted_x(1:n-tt,:),-(d+m+3));
    for i =1:R-tt
        %%
       %% A(n-tt-i+1,1:d)=by_Sol(A(n-tt-i+1,1:d),m,A(:,1:d),n-tt-i+1,size(A,1),d);
       A(n-tt-i+1,1:d)=XX(tt+i,1:d);
       %%
    end
    X=[A(:,1:d);X(n-tt+1:n,:)];   
end
[model,count]=all_soring(X,m,d,n);
end






