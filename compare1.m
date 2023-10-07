function [result]=compare1(x1,x2,m)%%该函数用于外部档案中的比较，比较支配关系
if m==2
    jishu1=0;%%x1支配x2输出1，否则输出2,不相关输出3
    jishu2=0;
    jishu3=0;
    result=0;
    y1=obj_funs(x1,m);
    y2=obj_funs(x2,m);
    for i=1:m%%对于m个目标
        if y1(i)<y2(i)
            jishu1=jishu1+1;
            
        elseif y1(i)==y2(i)
            jishu2= jishu2+1;
            
        else
            jishu3=jishu3+1;
            
        end
    end
    if      jishu1==2 || (jishu1==1&&jishu2==1)
        result=1;       %%a支配b
    elseif  jishu3==2|| (jishu2==1&&jishu3==1)
        result=2;%%b支配a
    elseif (jishu1==1&&jishu3==1)||jishu2==2
        %     if a(d+5)>b(d+5)
        %         result=1
        % else
        result=3;
    end;%%ab不相关
elseif m==3
    jishu1=0;
    jishu2=0;
    jishu3=0;
    y1=obj_funs(x1,m);
    y2=obj_funs(x2,m);
    for i=1:m%%对于m个目标
        if y1(i)>y2(i)
            jishu1=jishu1+1;
            
        elseif y1(i)==y2(i)
            jishu2=jishu2+1;
            
        else
            jishu3=jishu3+1;     
        end
    end
    if   jishu1+jishu2==3 &&jishu1~=0
        result = 2;
    elseif jishu2+jishu3==3&&jishu3~=0
        result = 1;
    else result=3;
        
        
end
end

