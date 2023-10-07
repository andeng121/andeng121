function s=simplebounds(s,lb,ub) %s保存人工狼i更新后的位置
  ns_tmp=s;%边界处理
  % Apply the lower bound
  I=ns_tmp<lb;
  ns_tmp(I)=lb(I); 
  % Apply the upper bounds 
  J=ns_tmp>ub;
  ns_tmp(J)=ub(J);
  % Update this new move 
  s=ns_tmp;