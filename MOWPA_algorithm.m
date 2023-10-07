
%%%MOWPA-AG主程序
clc;
clear 
close all;
tic
for time=1:30
    disp(['times is  ' num2str(time)]);
    load('ZDT1.mat');
    % m=2;            % Number of objectives 目标函数的个数
    m=2;
%     Varmin=-3;
%     Varmax=3; 
    d=30;
    step=0.3;%%参数设置
    maxgen=300;
    Tmax=10;
    dnear=5;
    b=5;%%
    n=100 ;%n为人工狼总数
    R=floor(rand(1)*(n /(2*b)-n/b)+n/b);%随机淘汰[n/(2*b),n/b]匹较弱的人工狼
    tt=2;%步长差别因子
    f=10;%方向因子
    h=floor(rand(1)*(f-2*f)+2*f);%确定游走方向h的数目为（f,2*f）间的随机整数
    stepa=step/tt;%人工探狼的游走步长
    stepb=step;%人工猛狼的奔袭步长
    stepc=step/(2*tt);%人工狼的攻击步长
     RnD=zeros(n,2);  % Initilize the rank and distance matrix 初始化秩和距离矩阵，生成一个100行2列的元素值为0的矩阵
    %决策变量取值的上下界
    Lb=0*ones(1,d);   % Lower bounds/limits  生成一个1行30列的全0矩阵
    Ub=1*ones(1,d);   % Upper bounds/limits  生成一个1行30列的全1矩阵


    for i=1:n 
        Sol(i,1:d)=Lb+(Ub-Lb).*rand(1,d); %生成n只人工狼的初始位置，rand(1,d)返回一个1行d列的随机矩阵
        f(i,1:m) = obj_funs(Sol(i,:), m); %n只人工狼对应每一个目标函数的适应值
    end
    [model,count]=all_soring(Sol,m,d,n);%%自适应分组策略
    k=1;
    while k<maxgen
        [new_Sol,model,count]=AW_scoutwolf(model,count,n,h,stepa,d,m,Lb,Ub,dnear,Tmax);
        [new_Sol]=AW_summon(model,count,dnear,stepa,stepb,stepc,d,m,n,Lb,Ub);
        [model,count,new_Sol]=AW_quarryment(new_Sol,d,m,n,R,Lb,Ub);
        if mod(k,1)==0
            for i=1:n
                y(i,:)=obj_funs(new_Sol(i,:),m);
            end
            PlotCosts(y,m);
        end
        k=k+1;
    end
    for i=1:n
        new_Sol(i,:)=simplebounds(new_Sol(i,:),Lb,Ub); %s保存人工狼i更新后的位置
    end
    for i=1:n
        y(i,:)=obj_funs(new_Sol(i,:),m);
    end
    [sorted_x] = solutions_sorting([new_Sol y], m, d,n); %x保存解和适应值，m保存目标函数的个数，ndim保存决策向量的维数
     new_Sol=[]
    for i=1:n
       if sorted_x(i,d+m+1)==1
           new_Sol=[new_Sol;sorted_x(i,1:d)];
       end
    end
%     new_Sol=sorted_x(1:n-R,1:d);
     tt=size(new_Sol,1);
   
    for i=1:tt
        t(i,:)=obj_funs(new_Sol(i,:),m);
    end
    PlotCosts(t,m)
end
%%%%%%%%%%
