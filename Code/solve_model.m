function [result] = solve_model(parameter,tech0)
%%%%%%%%% Function Input & Output %%%%%%%%%%%%%%%%%%%%
%%%% By Jieteng Chen 2020 WISE

%%%% Input:
%%%% parameter=[alpha beta gamma]; the exopenous parameters
%%%% tech=[A1 A2 A3]; Initial Technology Productivity level.

%%%% output:
%%%% average percentages of output of three sectors
%%%% result=[Agri_ave Indu_ave Serv_ave];

%%%% Function: given parameter and initial technology, find the
%%%% average percentages of output of three sectors in a given period. Then
%%%% we can use these percentages to match the real data.




n=0.0090; % average growth rate of population in China, 1978-2018
g=0.047;
N0=10; % population of China in 1978
K0=5; %  r=7.94%    in 1978
L=6;
P=2;

alpha=parameter(1);
beta=parameter(2);
gamma=parameter(3);
parameter=[alpha beta gamma]; 
T=26;
K(1)=K0;
N(1)=N0; 

A10=tech0(1);
A20=tech0(2);
A30=tech0(3);
A1(1)=A10;
A2(1)=A20;
A3(1)=A30;
tech=tech0;
 for t=1:1:T   
     country_input=[K(t) N(t) L P];
     three_sector= three_sector_model(parameter,country_input,tech);
     Y1(t)=three_sector(1);
     Y2(t)=three_sector(2);
     Y3(t)=three_sector(3);
     GDP(t)=Y1(t)+Y2(t)+Y3(t);
     
     K(t+1)=three_sector(4);
     N(t+1)=N(t)*(1+n);  
     A1(t+1)=A1(t)*(1+g);
     A2(t+1)=A2(t)*(1+g);
     A3(t+1)=A3(t)*(1+g);
     tech=[A1(t+1) A2(t+1) A3(t+1)];
     Y1_contribution(t)=Y1(t)/GDP(t);
     Y2_contribution(t)=Y2(t)/GDP(t);
     Y3_contribution(t)=Y3(t)/GDP(t);
       
 end
  Agri_ave=mean(Y1_contribution(5:26));
 Indu_ave=mean(Y2_contribution(5:26));
 Serv_ave=mean(Y3_contribution(5:26));
 
 result=[Agri_ave Indu_ave Serv_ave];
end

