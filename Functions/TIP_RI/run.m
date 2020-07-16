%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IEEE Trans. on Image Processing 2016                                          % 
% Beyond Color Difference: Residual interpolation for color image demosaicking  %
% D. Kiku, Y. Monno, M. Tanaka and M. Okutomi                                   %                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SCIELab parameter
addpath 'scielab1-1-1'
sampPerDeg = 23;
load displaySPD;
load SmithPokornyCones;
rgb2lms = cones'* displaySPD;
load displayGamma;
rgbWhite = [1 1 1];
whitepoint = rgbWhite * rgb2lms';

% SumPSNR, sumCPSNR, sumSCIELab
sumpsnr=0;
sumcpsnr=0;
sumSCIELab=0;

% Read image
rgb = imread( '1.tif' );

% Cast to double
rgb = double(rgb);

% Mosaic pattern
% G R ..
% B G ..
% : :   
pattern = 'grbg';

% Demosaicking
sigma = 1;
eps = 1e-32;
rgb2 = demosaick(rgb, pattern, sigma, eps);
rgb2 =clip(rgb2,0,255);

% Save image
imwrite(uint8(rgb2), 'Pro.tiff');

% Calculate PSNR and CPSNR
psnr  = impsnr(rgb, rgb2, 255, 10);
cpsnr = imcpsnr(rgb, rgb2, 255, 10);

% Calculate SCIELab
% Crip image
[h w c] = size(rgb);
rgb = imcrop(rgb,[11,11,w-21,h-21]);
rgb2  = imcrop(rgb2 ,[11,11,w-21,h-21]);
% We fuond a minor error for the cripping area for the SCIELab evaluation.
% Please correct as below to remove border 10 pixels.
% rgb = imcrop(rgb,[11,11,w-10,h-10]);
% rgb2 = imcrop(rgb2,[11,11,w-10,h-10]);
r = rgb(:,:,1)/256;
g = rgb(:,:,2)/256;
b = rgb(:,:,3)/256;
r2 = rgb2(:,:,1)/256;
g2 = rgb2(:,:,2)/256;
b2 = rgb2(:,:,3)/256;
% Convert the RGB data to LMS
img = [r g b];
imgRGB = dac2rgb(img,gammaTable);
imgLMS = changeColorSpace(imgRGB,rgb2lms);
img2 = [r2 g2 b2];
imgRGB2 = dac2rgb(img2,gammaTable);
imgLMS2 = changeColorSpace(imgRGB2,rgb2lms);
% Run the scielab function.
imageformat = 'lms';
errorImage  = scielab(sampPerDeg, imgLMS, imgLMS2 , whitepoint, imageformat);
% Calculate SCIELab
SCIELab = mean(mean(errorImage));

% Print PSNR and SCIELab
fprintf('PSNR\n');
fprintf('Red: %g\n', psnr(1));
fprintf('Green: %g\n', psnr(2));
fprintf('Blue: %g\n', psnr(3));
fprintf('CPSNR: %g\n', cpsnr);
fprintf('SCIELab: %g\n', SCIELab);

