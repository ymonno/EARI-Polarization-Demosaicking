%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   mosaic funtion
% 
%    Input
%     - rgb :  full RGB image
%     - pattern : mosaic pattern
%           pattern = 'grbg'
%            G R ..
%            B G ..
%            : : 
%           pattern = 'rggb'
%            R G ..
%            G B ..
%            : :    
%           pattern = 'gbrg'
%            G B ..
%            R G ..
%            : : 
%           pattern = 'bggr'
%            B G ..
%            G R ..
%            : :    
% 
%    Output
%     - mosaic :  mosaiced image
%     - mask   :  binaly mask (3D data : height*width*RGB)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mosaic mask] = mosaic_bayer(rgb, pattern)

num = zeros(size(pattern));
p = find((pattern == 'r') + (pattern == 'R'));
num(p) = 1;
p = find((pattern == 'g') + (pattern == 'G'));
num(p) = 2;
p = find((pattern == 'b') + (pattern == 'B'));
num(p) = 3;

mosaic = zeros(size(rgb, 1),size(rgb, 2), 3);
mask = zeros(size(rgb, 1), size(rgb, 2), 3);

rows1 = 1:2:size(rgb, 1);
rows2 = 2:2:size(rgb, 1);
cols1 = 1:2:size(rgb, 2);
cols2 = 2:2:size(rgb, 2);

mask(rows1, cols1, num(1)) = 1;
mask(rows1, cols2, num(2)) = 1;
mask(rows2, cols1, num(3)) = 1;
mask(rows2, cols2, num(4)) = 1;

mosaic(:,:,1) = rgb(:,:,1) .* mask(:,:,1);
mosaic(:,:,2) = rgb(:,:,2) .* mask(:,:,2);
mosaic(:,:,3) = rgb(:,:,3) .* mask(:,:,3);

end
