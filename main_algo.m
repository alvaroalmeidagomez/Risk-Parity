%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  Risk parity  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Using RL  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% By Alvaro %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Almeida Gomez %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% https://alvaroalmeidagomez.github.io/ %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%% Cleaning the work space %%%
clear all 
clc
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

weeknumber=206; %%Number of the week in the  Return_DB.csv file to solve the optimization problem

%% Read historical data
format long        
Return_Data= readtable('Return_DB.csv');  %%Reading tables from .CSV (excel) files
Return_Data=table2array(Return_Data);        %%converting tables to array
weeks=Return_Data(:,1);   %%Vector with information of the weeks
dimtemp=size(Return_Data);     %%The size() function is dimension  of the array
nassets=dimtemp(2)-2;     %%number of assets 
nweeks=dimtemp(1);         %%number of weeks in the historical data
Return_Data=Return_Data(:,2:end);  %%Historical returns



%% computing the parameters for the transition probabilities from the previous historical returns
mu_1=mean(Return_Data(weeknumber-60:weeknumber,:));  %% Computing the mean of the previous 60- Months
Sigma_1=cov(Return_Data(weeknumber-60:weeknumber,:)); %% Computing the covariance of the previous 60- Months


[ sol_1,sol_2,sol_3,sol_4,Trajectories,WeightsD ] = generator( mu_1,Sigma_1,nassets); % Solving the risk parity problem

%%sol_1 is the optimal policy along all the iterations
%%sol_2 is the value function computed along all the iteration
%%sol_3 is the gradient norm computed along all the iterations
%% sol_4 is the risk contribution along all the iterations
%% Trajectories are the sample points of the return distribution along the several episodes after applying the cluster methodology
%% WeightsD is the probability of the realization of each trajectory 

save DataB.mat  %%% Saving data as DataB.mat