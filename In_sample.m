
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%In- Sample  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Evaluation %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% https://alvaroalmeidagomez.github.io/ %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
close all
clc

load DataB.mat

nIter=length(sol_1);
Vplot2=zeros(1,nIter);
Vplot3=zeros(1,nIter);
malha=1:nIter;
Pall=[];
RC=[];



for i=1:nIter
    Vplot2(i)=sol_2{i};
    Vplot3(i)=sol_3{i};
    vtemp=sol_1{i};
    Pall(i,:)=vtemp(1,:);
    atemp=sol_4{i};
    atemp=1+atemp;
    RC(i,:)=atemp/sum(atemp);
end



figure
plot(malha,Vplot2)
xlabel('Iteration')
ylabel('Value Function')
title("Value Function")

figure
plot(malha,Vplot3)
xlabel('Iteration')
ylabel('Norm')
title("Gradient Norm")

figure
ba=bar(Pall,'stacked','FaceColor','flat');
hold on
%%Lines%%%
ylim([0 1])

xlabel('Month')
ylabel('Weights')
legend('Asset 1','Asset 2','Asset 3','Asset 4','Asset 5','Asset 6','Asset 7','Location','bestoutside')
title("Portfolio weights using RL")


figure
ba=bar(RC,'stacked','FaceColor','flat');
hold on
ylim([0 1])
xlabel('Iteration')
ylabel('Weights')
legend('Asset 1','Asset 2','Asset 3','Asset 4','Asset 5','Asset 6','Asset 7','Location','bestoutside')
title("Risk Contribution")

