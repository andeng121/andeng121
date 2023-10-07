
function [sorted_x,nSol] = solutions_sorting(x, m, ndim,n)  %x保存解和适应值，m保存目标函数的个数，ndim保存决策向量的维数
npop=size(x,1);    
frontRank=1;       
Rcol=ndim+m+1;     
PF(frontRank).R=[];   xSol=[];
%% The main non-dominated sorting starts here             %%%%%%%%%%%%%%%%% 非支配排序主程序
for i = 1:npop 
    xSol(i).n=0;
    xSol(i).q=[];
    for j=1:npop
        ns_categ_1=0; ns_categ_2=0; ns_categ_3=0;
        for k=1:m
            if (x(i,ndim+k) < x(j,ndim+k))    
                ns_categ_1=ns_categ_1+1;
            elseif (x(i,ndim+k)==x(j,ndim+k)),
                ns_categ_2=ns_categ_2+1;
            else                                 
                ns_categ_3=ns_categ_3+1;
            end
        end 
        if ns_categ_1==0 && ns_categ_2 ~= m 
            xSol(i).n=xSol(i).n+1;
        elseif ns_categ_3 == 0 && ns_categ_2 ~= m
            xSol(i).q=[xSol(i).q j];
        end
    end % end of j   
 
    %% Record/Udpate the Pareto Front 记录/更新帕累托前沿
    if xSol(i).n==0 
        x(i,Rcol)=1;   
        PF(frontRank).R = [PF(frontRank).R i];
    end
end 
nSol=[];
for i=1:npop
    nSol(i).n=xSol(i).q;
end
while ~isempty(PF(frontRank).R)
    nonPF=[];   
    N=length(PF(frontRank).R);
for i=1 :N
   Sol_tmp_q=xSol(PF(frontRank).R(i)).q; 
   if ~isempty(xSol(Sol_tmp_q))
       for j = 1:length(Sol_tmp_q)
          Sol_tmp_qj=xSol(PF(frontRank).R(i)).q(j);   
          xSol(Sol_tmp_qj).n=xSol(Sol_tmp_qj).n-1;
          if xSol(Sol_tmp_qj).n==0
             x(Sol_tmp_qj, Rcol)=frontRank + 1;
             nonPF = [nonPF Sol_tmp_qj];
          end
       end 
   end
end  
   frontRank=frontRank+1;
   PF(frontRank).R=nonPF;
end 
a = zeros(n,1);
for i =1 :n
    a(i,1) = i;
end
x=[x a];
% Now carry out the sorting of ranks and then update 根据秩进行排序，并更新
[~,frontRanks_Index]=sort(x(:, Rcol));
Sorted_frontRank=x(frontRanks_Index,:); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evaluate the crowding distances for each solution for each frontRank   %计算每个分类层次上每个解的聚集距离
% That is, all the non-domonated solutions on the Pareto Front.
% %%%%%%%%%%也就是说，所有的非支配的解都在帕累托前沿上
Qi=0;      % Initialize a counter  初始化一个计数器
for frontRank=1:(length(PF)-1) %(length(PF)-1)为所有解分类等级的数量
    % Define/initialize a generalized distance matrix  定义/初始化一个广义距离矩阵
    dc = [];    past_Q=Qi+1;
    for i=1:length(PF(frontRank).R)%length(PF(frontRank).R)为每个等级的解的数量
        dc(i,:)=Sorted_frontRank(Qi+i,:);%保存按照秩排序的解
    end
    Qi=Qi+i;
    % Solutions are sorted according to their fitness/objective values
    % 按照秩排序后，再按照适应值/目标函数值进行排序
    fobj_sorted=[];
    for i=1:m, 
        [~, f_Rank]=sort(dc(:,ndim+i));%[~, f_Rank]中保存在秩排序的基础上再进行适应值排序的种群的解，sort(dc(:,ndim+i))
        fobj_sorted=dc(f_Rank,:);
        % Find the max and min of the fobj values   寻找边界解，针对边界之外的点计算聚集距离
        fobj_max=fobj_sorted(length(f_Rank), ndim+i); %排序解中目标函数值最大的解
        fobj_min=fobj_sorted(1, ndim+i);              %排序解中目标函数值最小的解
        % Calculate the range of the fobj  计算适应值的浮动范围
        f_range=fobj_max-fobj_min; 
        % If the solution is at the end/edge, set its distance as infinity  如果解在末端/边，将其距离设为无穷大
        % 边界解的聚集距离设置为无穷大，给边界点一个最大值以确保每次均能入选下一代
        dc(f_Rank(length(f_Rank)), Rcol+i+1)=Inf;
        dc(f_Rank(1), Rcol+i+1) = Inf;
        for j=2:length(f_Rank)-1 %确定一个解的两个邻居解的适应值
            fobj1=fobj_sorted(j-1,ndim + i);  
            fobj2=fobj_sorted(j+1,ndim + i); 
            % Check the range or special cases 检查范围或特殊情况
            if (f_range==0)
                dc(f_Rank(j), Rcol+i+1)=Inf;%因为最大值和最小值已经重置为无穷大了，如果f_range=原最大值-原最小值=0时，除最大，最小之外所有都被重置为无穷大，所有就是第Rcol+i列所有值都重置为无穷大了
            else 
            % Scale the range for distance normalization  缩放距离标准化的范围   
            dc(f_Rank(j),Rcol+i+1)=(fobj2-fobj1)/f_range;%聚集距离（又称拥挤度）
            end
         end % end of j   得到除了最大、最小值的其他解的聚集距离
    end % end of i
    
    % Calculate and update the crowding distances on the Pareto Front计算并更新帕累托前沿上的聚集距离
    dist = []; dist(:,1)=zeros(length(PF(frontRank).R),1);
    for i=1:m, 
        dist(:,1)=dist(:,1)+dc(:, Rcol+i+1);%dist(:,1)表示取dist矩阵的第一列
    end  % 将得到的两列聚集距离（即聚集距离）相加成一列
    % Store the crowding distrance (dc) in the column of Rcol+1=ndim+m+2  将聚集距离（dc）保存在Rcol+1=ndim+m+2的队列中
    dc(:, Rcol+2)=dist; 
    dc=dc(:,1:Rcol+2);%得到34列的矩阵，2列目标值，一列分类序号，一列聚集距离（由两列聚集距离相加而成）
    % Update for the output 输出的更新
    xy(past_Q:Qi,:)=dc;  
end  % end of all ranks search/update  所有级别搜索/更新结束
sorted_x=xy();    % Output the sorted solutions   输出排序后的解
                  %输出的矩阵维度为ndim+m+2:解的位置+目标函数值+秩+聚集距离
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of non-dominated sorting %%%%%%%%%%%%%%