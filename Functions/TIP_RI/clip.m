function [Y] = clip(X, lo, hi)

Y = X;
Y(X<lo) = lo;
Y(X>hi) = hi;

end
