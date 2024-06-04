function [ x,sol ] = icvar_function( D, weights, beta ,alfa )

l=length(D);
o=(1/(1-alfa))*transpose(weights);
o=[1 -o];

A_2=-eye(l);
A_1=ones(l,1);
A=[A_1 A_2];
b=D;

lb=[-Inf zeros(1,l)];
ub=[beta Inf*ones(1,l)];

options = optimoptions('linprog','Display','none');
x = linprog(-o,A,b,[],[],lb,ub,options);

sol=dot(o,x);
x=x(1);

end