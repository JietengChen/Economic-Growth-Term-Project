function variables_returned= return_variables(parameter,input,tech)
%%%%%%%%% Function Input & Output %%%%%%%%%%%%%%%%%%%%
%%%% By Jieteng Chen 2020 WISE

%%%% Input:
%%%% parameter=[alpha beta gamma]; the exopenous parameters
%%%% input=[K N L P K2 N1 N2]; The allocation of production material
%%%% tech=[A1 A2 A3]; Technology Productivity level.

%%%% output:
%%%% The output in three sector, and the corresponding wage and capital rental rate
%%%% variables_returned=[Y1 Y2 Y3 w1 w2 w3 rK2 rK3]; 



alpha=parameter(1);
beta=parameter(2);
gamma=parameter(3);
K=input(1);
N=input(2);
L=input(3);
K2=input(5);
K3=K-K2; 
N1=input(6);
N2=input(7);
N3=N-N1-N2; 
P=input(4);
A1=tech(1);
A2=tech(2);
A3=tech(3);

% Agricultural sector
Y1=power(A1*N1,1-alpha)*power(L,alpha);  
w1=(1-alpha)*power(A1,1-alpha)*power(N1,-alpha)*power(L,alpha); 
% Industrial sector 
Y2=power(A2*N2,1-beta)*power(K2,beta);
w2=(1-beta)*power(A2,1-beta)*power(N2,-beta)*power(K2,beta); 
rK2=beta*power(A2*N2,1-beta)*power(K2,beta-1);
% Service Sector
Y3=power(A3*N3,1-gamma)*power(K3,gamma);
w3=P*(1-gamma)*power(A3,1-gamma)*power(N3,-gamma)*power(K3,gamma);
rK3=P*gamma*power(A3*N3,1-gamma)*power(K3,gamma-1);
variables_returned=[Y1 Y2 Y3 w1 w2 w3 rK2 rK3]; 

end

