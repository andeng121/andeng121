%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function f=ZDT1(x)

    d=length(x);

    f1=x(1);
    
    g=1+9/(d-1)*sum(x(2:end));
    
    h=1-sqrt(f1./g);
    
    f2=g*h;
     
    f=[f1
      f2];

end