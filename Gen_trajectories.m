function [Total_Trajectories_complete,Total_Trajectories,WeightsD] = Gen_trajectories(mu_1,Sigma_1,Nscenarios,N,T)
ltemp=length(mu_1);
Total_Trajectories=zeros(Nscenarios,T,ltemp);


for i1=1:Nscenarios
for i2=1:T
    
   sampletemp=mvnrnd(mu_1,Sigma_1);
   sampletemp=max(sampletemp,-1);
   Total_Trajectories(i1,i2,:)=sampletemp;
   
end
end
Total_Trajectories_complete=Total_Trajectories;
Total_Trajectories=reshape(Total_Trajectories,i1,[]);


[idx,C,ll,DD]= kmeans(Total_Trajectories,N,'MaxIter',1000);
[Mtemp,Ind]=min(DD);
Total_Trajectories=Total_Trajectories(Ind,:);
Total_Trajectories=reshape(Total_Trajectories,[N,T,ltemp]);

testV=ones(Nscenarios,1);
idx = sort(idx);
WeightsD=accumarray(idx,testV)/Nscenarios;



end