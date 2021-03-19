%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Main funtion
%     rgb_dem = demosaick(rgb, pattern, sigma)
% 
%      Input
%       - rgb		: full RGB image or mosaic data
%       - pattern	: mosaic pattern 
%                       default : 'grbg'
%                       others  : 'rggb','gbrg','bggr'	
%       - sigma		: standard deviation of gaussian filter(default : 1.4)
%                       * For IMAX image data set, 1 works well.
%                       * For Kodak image data set, 1e8 works well.
% 
%      Output 
%       - rgb_dem   : result image
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  rgb_dem = demosaick(rgb, pattern, sigma, eps)

rgb = rgb*255;

% mosaic and mask
[mosaic mask] = mosaic_bayer(rgb, pattern);

% green interpolation
green = green_interpolation(mosaic, mask, pattern, sigma,eps); 
green = clip(green,0,255);

% Red and Blue demosaicking
red = red_interpolation(green, mosaic, mask,eps);
blue = blue_interpolation(green, mosaic, mask,eps);
red = clip(red,0,255);
blue = clip(blue,0,255);

% result image
rgb_dem(:,:,1) = red/255;
rgb_dem(:,:,2) = green/255;
rgb_dem(:,:,3) = blue/255;

end
