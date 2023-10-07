%人工狼的围攻行为AW_beleaguer（）
function  [x,y]=AW_beleaguer(x,stepc,Xtoulang,d,m,lb,ub)
%x为各人工狼的位置，行为1,列为编码长度；y为各人工狼位置编码对应的背包内物品总价值；stepc为围攻步长；Xtoulang为头狼所在的位置，Ytoulang为头狼所感知到的猎物气
%味浓度，即为目标函数值；
   aa=x;%记录刚开始的值
   y=obj_funs(x,m);
   a=y;
      k=1;%设定k的初值
    for j=1:d
        r=-2*rand(1)+1;%r为[-1,1]之间的随机数
         x(j)=x(j)+r*stepc*abs(Xtoulang(j)-x(j));%更新参与围攻的人工狼的位置
    end
     x=simplebounds(x,lb,ub); %s保存萤火虫i更新后的位置

y=obj_funs(x,m);
%加保持策略防止优秀人工狼被破坏
tt=compare1(aa,x,m);
     if tt==1||tt==3%如果随机stepc运动后还不如不运动，则还原X（i,:）,Y(i)
%          if tt==1
            x=aa;
            y=a;
     end  
     for i=1:numel(x)
            if isnan(x(i))==1
                x(i)=rand(1,1);
            end
        end   
 

     
end