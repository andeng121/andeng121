function ju=computer_distance(X1,X2,d,m)
ju=0;

for i=1:d
    ju=ju+abs(X1(1,i)-X2(1,i));%采用manhattan距离
end
end