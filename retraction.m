function [v] = retraction(v)
v=abs(v);
if(sum(v)==0)
    v=ones(size(v));
end
v=v/sum(v);
end