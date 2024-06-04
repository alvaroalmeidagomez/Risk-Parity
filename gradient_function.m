function [grad] = gradient_function(net_0,Q,theta_0,rsize)

t=0.1;
nstemp=size(theta_0);
nassets=nstemp(2);
T=nstemp(1);
grad=zeros(size(theta_0));
normD=0;

for k=1:rsize                             %First for 
    theta_temp=zeros(size(theta_0));
    for i=1:T
      vtemp=mvnrnd(theta_0(i,:), t*eye(nassets));
      theta_temp(i,:)=retraction(vtemp);
    end
    input=reshape(theta_temp,[],1);
    Qtemp=net_0(input);
 
  


    dis=theta_temp-theta_0;
    expter=exp(-power(norm(dis,"fro"),2)/(2*t));
    grad=grad+(Qtemp-Q)*(dis)*expter;
    normD=normD+expter;

end

grad=grad/(t*normD);


end