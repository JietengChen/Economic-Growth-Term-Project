function [result] = three_sector_model(parameter,country_input,tech) 
%%%%%%%%% Function Input & Output %%%%%%%%%%%%%%%%%%%%
%%%% By Jieteng Chen 2020 WISE

%%%% Input:
%%%% parameter=[alpha beta gamma]; the exopenous parameters
%%%% %couuntry_input=[K N L P]; The total endowment of production material
%%%% tech=[A1 A2 A3]; Technology Productivity level.

%%%% output:
%%%% The output in three sector, the capital next period , utility and wage.
%%%% result=[Y1 Y2 Y3 K_next U wage];

%%%% Function: given parameter, endowment and technology, find the
%%%% equilibrium allocation that satisfies the market equibrium condition
%%%% and return the output. 


K=country_input(1);
N=country_input(2);
L=country_input(3);
P=country_input(4);

A1=tech(1);
A2=tech(2);
A3=tech(3);

% Given N L and K, find the equilibrium allocations of 
% capital, labor and land in agricultural, industrial and service sectors,
options = optimoptions('fmincon');
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'MaxFunEvals', 10000);
options = optimoptions(options,'MaxIter', 10000);
options = optimoptions(options,'Algorithm', 'sqp');

     % Below,we provide initial allocations of capital and labor in two sectors,  
     K20=K*0.5;
     N10=N*0.4; 
     N20=N*0.3;
     
     ini=[K20 N10 N20];
   
     A=[]; % It is not useful here
     B=[];% It is not useful here
     Aeq=[];% It is not useful here
     Beq=[];% It is not useful here
     lower=[0.1*K 0.1*N 0.1*N]; %   minimal allocations 
     upper=[K N 0.8*N]; % maximal allocations
     [allocation_got,fval,exitflag]=fmincon(@get_allocation,ini,A,B,Aeq,Beq,lower,upper,@constrain_allocated,options); 
     %exitflag
     %fval
     K2=allocation_got(1);
     N1=allocation_got(2);
     N2=allocation_got(3);
     %('N on Agri:%u\n', N1/N); 
     %fprintf('K on Indu:%u\n', K2/K); 
     %fprintf('N on Indu:%u\n', N2/N); 
     %fprintf('K on Service:%u\n', (K-K2)/K); 
     %fprintf('N on Service:%u\n', (N-N1-N2)/N); 
     
     input=[K N L P K2 N1 N2];
     variables_returned=return_variables(parameter, input,tech);
     Y1=variables_returned(1);
     Y2=variables_returned(2);
     Y3=variables_returned(3);
     wage=variables_returned(5);
     rK=variables_returned(7);
     rho=0.0373;
     K_next=N*wage/(2+rho)+0.4*K;
     c1=(1+rho)/(4+2*rho)*wage;
     c2=c1;
     U=log(c1)+log(c1/P)+1/(1+rho)*(log(c2)+log(c2/P));
     result=[Y1 Y2 Y3 K_next U wage];
     %fprintf('wage:%d\n', wage); 
     %fprintf("rK:%d\n",rK);
     %fprintf("rL:%d\n",rL);
     %fprintf("Y1:%d\n",Y1);
     %fprintf("Y2:%d\n",Y2);
     %fprintf("Y3:%d\n",Y3);
  

  % define the objective function   
    function allocation_got=get_allocation(ini)
     allocation_got=2; 
    end
% Enfore market equilibrium
    function [C,Ceq]=constrain_allocated(ini) 
        %ini=[K20 N10 N20];
     K2=ini(1);
     N1=ini(2);
     N2=ini(3);
     input=[K N L P K2 N1 N2];
     variables_returned=return_variables(parameter, input,tech);
     %variables_returned=[Y1 Y2 Y3 w1 w2 w3 rK2 rK3];
     w1=variables_returned(4);
     w2=variables_returned(5);
     w3=variables_returned(6);
     rK2=variables_returned(7);  
     rK3=variables_returned(8);
     C=[];  % It is not useful here
     Ceq=[w1-w2 w2-w3 rK2-rK3]; 
    end
end

