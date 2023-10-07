function [new_Sol,model,count]=AW_scoutwolf(model,count,n,h,stepa,d,m,lb,ub,dnear,Tmax)
%X为各人工狼的位置，行为个数，列为编码长度；Y为各人工狼位置编码对应的目标函数值；stepa为游走步长；Tmax为人工探狼游走行为的最大次数；
%h为探狼前进的方向数；Xtoulang为头狼所在的位置，Ytoulang为头狼所感知到的猎物气味浓度，即为目标函数值；
T=1;%人工探狼游走行为的次数的初值
while T<Tmax
    new_Sol=[];
    for i=1:count
        Z=model{i} ;%%提出第i个cell里面的狼群数据
        g=size(Z,1);  %%第i个狼群数据的人工狼个数
        Z1=Z(:,1:d);
        Xtoulang=Z1(1,:);
%         if g>1
            for j=1:g%%人工狼第j头
                t=compare1(Z1(j,:),Xtoulang,m);
                if t==1 ||t==3  %若某匹人工探狼感知到的猎物气味浓度大于头狼所感知的
                    Xtoulang=Z1(j,:);%头狼被其取代,更新头狼位置,人工狼支配头狼
                    Z1(j,:)=Z1(1,:);
                    Z1(1,:)=Xtoulang;
                    %           Ytoulang=Y(i);%头狼被其取代,更新头狼感知的猎物气味浓度
                    continue;
                else
                    for p=1:h
                        Z1=Z(:,1:d);
                        xx(p,:)=Z1(j,:)+stepa*sin(2*pi*p/h);
                        xx(p,:)=simplebounds(xx(p,:),lb,ub);%确保更新后的位置也要在界限范围内，如果不在，强制等于上界或者下界
                        yy(p,:)=obj_funs(xx(p,:),m);
                    end
                    [PP] = select_direction(xx,yy, d, m);
                    shu=PP.R;
                if  isempty(shu)==0
                    rand_num=randsrc(1,1,shu);
                    Z1(j,:)=xx(rand_num,:);
                    if compare1(Z1(j,:),Xtoulang,m)==1||compare1(Z1(j,:),Xtoulang,m)==3
                        Xtoulang=Z1(j,:);%头狼被其取代,更新头狼位置,人工狼支配头狼
                        Z1(j,:)=Z1(1,:);
                        Z1(1,:)=Xtoulang;
                    end   
                end
                end   
        end
        new_Sol=[Z1;new_Sol];
        for kk=1:numel(new_Sol)
            if isnan(new_Sol(kk))==1
                new_Sol(kk)=rand(1,1);
            end
        end
    end
    [model,count]=all_soring(new_Sol,m,d,n);
    T=T+1;
end


