function [PP] = select_direction(xx,yy, d, m)  %x中保存解和适应值，m保存目标函数的个数，d保存决策向量的维数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
npop=size(xx,1);    % Population size size(x,1)返回矩阵x的行数，即狼群的大小 
frontRank=1;       % Pareto frontRank (counter) initialization 初始化帕累托前沿秩计数器
Rcol=m+d+1;     % Store the ranks in the column Rcol=m+d+1 将每匹人工狼的等级存储在Rcol=m+d+1 的队列里
% Define the Parato Front as a class (PF) and initilization of xSol
% 将帕累托前沿等级定义为一个类，并初始化矩阵xSol
PP(frontRank).R=[];   xSol=[];
%% The main non-dominated sorting starts here             %%%%%%%%%%%%%%%%% 非支配排序主程序
for i = 1:npop 
    % Set the number (initially, 0) of solutions dominating this solution
    % 设置支配这个解的解的数目，初始设置为0
    xSol(i).n=0;%保存种群中所有支配i这匹人工狼的数目
    % Find all the solutions (that dominated by this solution)  
    xSol(i).q=[];%保存所有被i这匹人工狼支配的解
    % Sorting into 3 categories: better (minimization), equal & otherwise
    % 分为三类：最好（最小），相等或其他
    for j=1:npop
        % Definte 3 counters for 3 categories 定义三种策略的3个计数器
        ns_categ_1=0; ns_categ_2=0; ns_categ_3=0;
        for k=1:m  % for all m objectives 对于所有m目标
            % Update the counters for 3 different categories 更新三种分类策略的计数器
            if (yy(i,k) < yy(j,k))      % better/non-dominated，最好解，非支配解
                ns_categ_1=ns_categ_1+1;%保存被人工狼i支配的解的数目
            elseif (yy(i,k)==yy(j,k))   % equal 不存在支配关系
                ns_categ_2=ns_categ_2+1;%保存与人工狼i大小相同的解的数目
            else                                 % dominated 被支配的解
                ns_categ_3=ns_categ_3+1;%保存支配人工狼i的解的数目
            end
        end % end of k
        % Update the solutions in their class  更新PF类中的解决方案
        if ns_categ_1==0 && ns_categ_2 ~= m %ns_categ_1==0保证了人工狼i的两个目标值都不小于要比较的人工狼j的两个目标值，
                                            %ns_categ_2 ~= m保证了人工狼i的两个目标值与要比较的人工狼j的两个目标值不会完全相等，
                                            %简而言之，就是要比较的人工狼j有一个目标值是小于人工狼i的其中一个目标值的，而对于另外一个目标值，两者是相等的，
                                            %或者，要比较的人工狼j的两个目标值都是小于人工狼i的两个目标值的
                                            %一共两者情况，符合要比较的人工狼j支配人工狼i
            xSol(i).n=xSol(i).n+1;%保存种群中所有支配i这匹人工狼的数目
        elseif ns_categ_3 == 0 && ns_categ_2 ~= m
            xSol(i).q=[xSol(i).q j];%保存被i这个解支配的解在群体中的索引，也就是序号
        end
    end % end of j   
    %% Record/Udpate the Pareto Front 记录/更新帕累托前沿
    if xSol(i).n==0 %说明i这匹人工狼不受任何人工狼支配，放入非支配解档案中去,并且将i这匹人工狼的分类序号定义为1
       xx(i,Rcol)=1;   % Update the Rank #1 (i.e., the Pareto Front) 更新排名
       PP(frontRank).R = [PP(frontRank).R i];%保存非支配解的索引
    end
end % end of i=1:npop (The first round full rank-sorting process)  第一轮全等级的排序流程完成，找出所有的非支配解

end