% imcpsnr evaluates the cpsnr between images
%
% cpsnr = imcpsnr(X, Y, peak, b)
%
% Output parameters:
%  cpsnr: cpsnr between images X and Y
%
% Input parameters:
%  X: image whose dimensions should be same to that of Y
%  Y: image whose dimensions should be same to that of X
%  peak (optional): peak value (default: 255)
%  b (optional): border size to be neglected for evaluation
%
% Example:
%  X = imreadind('X.png');
%  Y = imreadind('Y.png');
%  cpsnr = imcpsnr(X, Y);
%  fprintf('%g\n', cpsnr);
%
% Version: 20120601
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous tools for image processing                 %
%                                                          %
% Copyright (C) 2012 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cpsnr = imcpsnr(X, Y, peak, b)

if( nargin < 3 )
 peak = 255;
end

if( nargin < 4 )
 b = 0;
end

if( b > 0 )
 X = X(b:size(X,1)-b, b:size(X,2)-b,:);
 Y = Y(b:size(Y,1)-b, b:size(Y,2)-b,:);
end

dif = (X - Y);
dif = dif .* dif;
mse = sum( dif(:) ) / numel(dif) + 1e-32;
cpsnr = 10 * log10( peak*peak / mse );

end
