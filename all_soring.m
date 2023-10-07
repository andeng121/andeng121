function [model,count]=all_soring(Sol,m,d,n)
for i=1:n
    f(i,:)=obj_funs(Sol(i,:),m);
end
x=[Sol f];
[Sorted,nSol]=solutions_sorting(x, m,d,n);%Sorted矩阵的列数为（ndim+m+2）
[model,count]=cell_soring(Sorted,nSol,n,d,m);%%model为所有人工狼的经过排序后的结果，model1为包含适应度值以及等级编号聚集距离的结
end