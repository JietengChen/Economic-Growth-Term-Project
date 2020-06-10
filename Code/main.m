%%%% This is the main estimation function. I use it to estimate the
%%%% exogenous parameters and simulate the growth path of model

clear all;
clc;
options = optimoptions('fmincon');
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'MaxFunEvals', 1000);
options = optimoptions(options,'MaxIter', 1000);
 
param_ini =[0.3057    0.1475    0.5699];
tech=[0.0975 0.275 0.1895];
warning('off')
%Ceq =0.0089    0.0058    0.0053
lower = [0.01 0.01 0.01];
upper = [0.99 0.99 0.99];
[param_estimated,favl,exitflag]=fmincon(@(param_ini)estimation(param_ini,tech),param_ini,[],[],[],[],lower,upper,@(param_ini)constraints(param_ini,tech),options); 

param_estimated 
parameter=param_estimated ;
tech0=tech;
n=0.0090;
g=0.062;
N0=10; 
K0=5; 
L=6;
P=2;
T=30;
K(1)=K0;
N(1)=N0; 

A10=tech0(1);
A20=tech0(2);
A30=tech0(3);
A1(1)=A10;
A2(1)=A20;
A3(1)=A30;
U(1)=0;
wage(1)=0;
 for t=1:1:T   
     country_input=[K(t) N(t) L P];
     tech=[A1(t) A2(t) A3(t)];
     three_sector= three_sector_model(parameter,country_input,tech);
     Y1(t)=three_sector(1);
     Y2(t)=three_sector(2);
     Y3(t)=three_sector(3);
     GDP(t)=Y1(t)+Y2(t)+Y3(t);
     K(t+1)=three_sector(4);
     U(t)=three_sector(5);
     wage(t)=three_sector(6);
     N(t+1)=N(t)*(1+n);  
     A1(t+1)=A1(t)*(1+g);
     A2(t+1)=A2(t)*(1+g);
     A3(t+1)=A3(t)*(1+g); 
 end
 
 time=1994:1:2023;
 figure(1);
 plot( time,Y1,'Color',[0 0.4 0.54],"LineWidth",1.3);
 hold on
 plot( time,Y2,'Color',[0.69 0.13 0.13],"LineWidth",1.3);
 hold on
 plot( time,Y3,'Color',[0.47 0.54 0.54],"LineWidth",1.3);
 hold on
 legend("Agricultural Sector","Industrial Sector","Service Sector ")
 title("GDP of Three Production Sectors without Shock (before 2020)");
 xlabel("Year")
 ylabel("Output");
 xlim([1998 2019]);
 ylim([0.3 8.5]);
 
figure(2);
plot(time,U,'Color',[0.69 0.18 0.37] ,"LineWidth",1);
title("Utility")
xlabel("Year");
ylabel("Utility");
 xlim([1998 2019]);

 figure(3);
plot(time,wage,'Color',[0.85 0.80 0.80],"LineWidth",1.5);
title("Wage")
xlabel("Year");
ylabel("Wage");
 xlim([1998 2019]);


function para_estimated=estimation(param_ini,tech)
     para_estimated=1;
end
function [C, Ceq] = constraints(param_ini,tech)
%%%% the average percentage of output of three sectors produced by model
   stats_by_model=solve_model(param_ini,tech);
%%%% the average percentage of output of three sectors in real data.
   stats_by_data=[0.127 0.431 0.44];
   C = [];  
   Ceq=[stats_by_model-stats_by_data];
end

