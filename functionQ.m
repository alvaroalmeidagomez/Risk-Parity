function [f,r] = functionQ(theta_0,T,nassets,beta,alfa,Trajectories,WeightsD)

Nscenarios=length(WeightsD);


X=ones(Nscenarios,T,nassets);
Y=ones(Nscenarios,T+1);
W=ones(Nscenarios,T+1);



for i1=1:Nscenarios
for i2=1:T
 
    
   sampletemp=Trajectories(i1,i2,:);
   sampletemp=reshape(sampletemp,1,[]);

   sampletemp=max(sampletemp,-1);
   X(i1,i2,:)=theta_0(i2,:).*(1+sampletemp(2:end));
   Y(i1,i2+1)=Y(i1,i2,:)*(1+sampletemp(1));
   W(i1,i2+1)=W(i1,i2)*(sum(X(i1,i2,:)));
   
end

end

C1=W(:,end);
C2=Y(:,end);




[icvarq2,f12]=icvar_function( C2-1, WeightsD, beta,alfa );
r= rc_function(W-1,X,beta,alfa,WeightsD,nassets,theta_0);
parityC=sum(r)*(1/nassets)*ones(nassets,1);

f1=power(r-parityC,2);



f=min(sum(r)-f12,0)-sum(f1); %%%Objective function to be maximized



end