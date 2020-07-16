function [Y] = trim(X,d)

Y = X(d+1:end-d,d+1:end-d,:);

end
