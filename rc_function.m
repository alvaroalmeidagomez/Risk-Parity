function [r] = rc_function(W,X,beta,alfa,weights,nassets,theta_0)




[ valatrisk,cvarval ] = cvar_function( W(:,end), weights,alfa );
r=zeros(nassets,1);

for itemp=1:nassets



rtemp=(W(:,end-1).*(X(:,end,itemp)))./theta_0(1,itemp);
rtemp=rtemp-1;




if(valatrisk < beta+1)


    vtemp=(valatrisk>=W(:,end)).*rtemp.*weights;
    r(itemp,1)=theta_0(1,itemp)*sum(vtemp);

else
      
    vtemp=(beta>=W(:,end)).*rtemp.*weights;
    r(itemp,1)=theta_0(1,itemp)*sum(vtemp);
end


end





end