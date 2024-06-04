function [ sol_1,sol_2,sol_3,sol_4,Trajectories,WeightsD ] = generator( mu_1,Sigma_1,nassets)


%%Input Parameters
beta=1;
alfa=0.95;
T=12; %% Number of stages
Nscenarios=100000; %Number of scenarios
N=500; %Number of Clusters
M=200; %Number of Iterations
rsize=50; %Number of cloud points to calculate gradient
Sinitial=2000; %Number of sample points to Initialize the NN Q.
Nneuros=30; %Number of neurons of the Neural Network in each hidden layer
eta=0.1;      %%Learning rate regarding the gradient iteration based on the formula x_{n+1}=x_{n}+eta*gradient
lr=2;        %% Scaling factor of Gradient Descent
subIter=20;   %% Number of iterations to updated the Scaling factor.
tolerance_var=power(10,-30);  %%Tolerance for the stopping criteria. In this case the stopping criteria is determined when the norm of the gradient is less than the tolerance



%%%%%%%%%%Generation of Return Trajectories%%%%%%%%%%%%%

[Trajectories_original,Trajectories,WeightsD] = Gen_trajectories(mu_1,Sigma_1,Nscenarios,N,T); %%Generating the return trajectories by using the Cluster methodology

%%%%%%%%%%%%%%End Generation of Trajectories%%%%%%%%%%%%


%% step 1: Initialize the database DB (space for storing data)
input={};    %%Input data to train the neural network
output={};    %%Output data to train the neural network
theta_0=[];    %% Optimal policy
optimal_decision={}; %%List which stores the optimal parameter along of the iterations
Val_funct={};    %Value Function
Norm_Grad={};    %Gradient norm 
RC_historical={}; %%Risk Contribution iteration


%Step 2: Set up Parameter
%%The neural neural network has as input a matrix with T rows
%The t-row is the optimal policy at time t



%step 4: First training to initialize the Neural Network

%%%%%%%%%Organizing data%%%%%%%%%


for k=1:Sinitial                             %First for to train the NN.
    theta_temp=zeros(size(theta_0));
    for i=1:T
      vtemp=rand(1,nassets);
      theta_temp(i,:)=retraction(vtemp);
    end
    [Q,rc]=functionQ(theta_temp,T,nassets,beta,alfa,Trajectories,WeightsD); %computing the action- value-function Q
    input{end+1}=reshape(theta_temp,[],1);
    output{end+1}=Q;
end
    

 input=cell2mat(input);
 output=cell2mat(output);

 [Q,I] = max(output);
 Q=output(I(1));
 theta_0=reshape(input(:,I(1)),T,[]);
 
 %%%%%%%Definition of the neural network%%%%%%%
   
 net_0 = fitnet([Nneuros,Nneuros]);       %%Defining a 2-Layer NN with Nneuros in each Layer
 net_0.numinputs=1;                       %Number inputs
 net_0.inputConnect = [1 ; 0   ;0   ]; %%Define the conection between layers and inputs a_{i,j} =1 means that i layer is conected to the j input.

 %%%%%%%Neural network training%%%%%%%
 net_0.trainParam.showWindow = 0;        %Hiding Training screen
 net_0 = train(net_0,input,output);      %Updating(Re-Training) the neural network.




for k=1:M  %Iterations to train the optimal policy

 clc
 vtemp_print=100* k/M;
 ppri=['Algorithm progress ',num2str(vtemp_print), '  %']; %%Print Algorithm progress
 disp(ppri)



%%%%%%%%%%%%%Computing the Gradient%%%%%%%%%%%%%

 grad=gradient_function(net_0,Q,theta_0,rsize); %% Gradient Computation

%%%%%%%%%%%%%Updating the parameter theta_0%%%%%%%%%%%%%

theta_0=theta_0+eta*grad; %%% Gradient Updated

%%%%%%%%%%%%%Normalization%%%%%%%%%%%%%
%%%%%%%%%%%%%We do this normalization to guarantee that the policy %%%%%%%%%%%%%
%%%%%%%%%%%%%is positive in all the coordinates and also that the sum is
%%%%%%%%%%%%%equal to 1%%%%%%%%%%%%%

    for i=1:T
      theta_0(i,:)=retraction(theta_0(i,:)); %% Normalization
    end


%%%%%%%%%%%%% Updating NN %%%%%%%%%%%%%


[Q,rc]=functionQ(theta_0,T,nassets,beta,alfa,Trajectories,WeightsD); %% Updating the Neural Network




input(:,end+1)=reshape(theta_0,[],1);
output(end+1)=Q;
input_temp=reshape(theta_0,[],1);
output_temp=(net_0(input_temp)+Q)/2;
net_0.trainParam.showWindow = 0;        %Hiding Training screen
net_0 = train(net_0,input_temp,output_temp);      %Updating(Re-Training) the neural network.


if(mod(k,subIter)==0)              %% Verifying if the learning rate should be updated!
    eta=eta/lr;
    [Q,I] = max(output);
    Q=output(I(1));
    theta_0=reshape(input(:,I(1)),T,[]);
end


%%%%%%%%%%%%%%%%Optimal_Value_Function%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% And Gradient Norm    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Val_funct{end+1}=Q; 
Norm_Grad{end+1}=norm(grad,"fro");
optimal_decision{end+1}=theta_0;
RC_historical{end+1}=rc;

%%%%%%%%%%%%%%%%%%%%End Opt Val Function%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
%%%%%  stopping criteria %%%%%
        if(norm(grad,"fro")<tolerance_var)
           disp('End by Stopping critera')
            break
        end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  end

sol_1=optimal_decision;
sol_2=Val_funct;
sol_3=Norm_Grad;
sol_4=RC_historical;


end