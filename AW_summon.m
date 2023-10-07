%召唤行为
function [new_Sol]=AW_summon(model,count,dnear,stepa,stepb,stepc,d,m,n,lb,ub)
%X%X为各人工狼的位置，行为个数，列为编码长度；Y为各人工狼位置编码对应的目标函数值；n为人工探狼的数量；%dnear表示人工猛狼与发起召唤行为的人工探狼已经很近,距离判定因子;
%stepa为游走步长；stepb为奔袭步长；stepc为围攻步长；Xtoulang为头狼所在的位置，Ytoulang为头狼所感知到的猎物气味浓度，即为目标函数值；
new_Sol=[];
 for i=1:count
     Z=model{i};
     g=size(Z,1); %%Z种群中人工狼个数
     Z1=Z(:,1:d);
     Xtoulang=Z1(1,:);
     for j=2:g
     ju=computer_distance1(Z1(j,:),Xtoulang,d);
     if ju>dnear%人工猛狼还没有离发动召唤行为的人工探狼足够近的时候
         for k=1:d
         Z1(j,k)=Z1(j,k)+stepb*(Xtoulang(k)-Z1(j,k))/abs(Xtoulang(k)-Z1(j,k));%更新人工猛狼的位置
         end
         Z1(j,:)=simplebounds(Z1(j,:),lb,ub);
%          Y(i)=simulationfunction(X(i,:),fobj);%;%更新第i匹人工探狼的所感知到得猎物气味浓度
               t=compare1(Z1(j,:),Xtoulang,m);
         if t==1||t==3%若奔袭过程中发现所感知到得猎物气味浓度大于发起召唤行为的头狼所感知的猎物气味浓度
                    Xtoulang=Z1(j,:);%头狼被其取代,更新头狼位置,人工狼支配头狼
                    Z1(j,:)=Z1(1,:);
                    Z1(1,:)=Xtoulang;
         end
     elseif ju<=dnear%当人工孟浪离发动召唤的人工探狼较近时发动围攻行为%%写到这里了
          
         [x,y]=AW_beleaguer(Z1(j,:),stepc,Xtoulang,d,m,lb,ub);  %进入围攻行为
         Z1(j,:)=x;
     end
     end
 new_Sol=[Z1;new_Sol];
  for kk=1:numel(new_Sol)
            if isnan(new_Sol(kk))==1
                new_Sol(kk)=rand(1,1);
            end
        end
 end
end
