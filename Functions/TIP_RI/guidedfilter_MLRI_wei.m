function [q,dif2] = guidedfilter_MLRI_wei(G, R, mask, I, p, M, h, v, eps)

% Image size
[hei, wid] = size(I); 
% The number of the sammpled pixels in each local patch
N = boxfilter(M, h, v);
N(find(N == 0)) = 1;
% The size of each local patch; N=(2r+1)^2 except for boundary pixels.
N2 = boxfilter(ones(hei, wid), h, v);

mean_Ip = boxfilter(I.*p.*M, h, v) ./ N;
mean_II = boxfilter(I.*I.*M, h, v) ./ N;

% Eqn. (5) in the paper;
a = mean_Ip ./ (mean_II + eps);

% Eqn. (6) in the paper;
N3 = boxfilter(mask, h, v);
N3(find(N3 == 0)) = 1;
mean_G = boxfilter(G.*mask, h, v) ./ N3;
mean_R = boxfilter(R.*mask, h, v) ./ N3;
b = mean_R - a .* mean_G;

% weighted average 
dif2 = boxfilter(G.*G.*mask,h,v).*a.*a+b.*b.*N3+boxfilter(R.*R.*mask,h,v)+2*a.*b.*boxfilter(G.*mask,h,v)-2*b.*boxfilter(R.*mask,h,v)-2*a.*boxfilter(R.*G.*mask,h,v);
dif2 = dif2 ./ N3;
dif = dif2.^1;
dif(find(dif<0.01)) = 0.01;
dif = 1./dif;
wdif = boxfilter(dif,h,v);
wdif(find(wdif<0.01)) = 0.01;
mean_a = boxfilter(a.*dif,h,v) ./ wdif;
mean_b = boxfilter(b.*dif,h,v) ./ wdif;

% Eqn. (8) in the paper;
q = mean_a .* G + mean_b;

end

