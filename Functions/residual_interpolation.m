function [output,dif] = residual_interpolation(guide, mosaic, mask, eps)
% parameters for guided upsampling
h = 5;
v = 5;

% Laplacian
F = [ 0, 0,-1, 0, 0;
      0, 0, 0, 0, 0;
     -1, 0, 4, 0,-1;
      0, 0, 0, 0, 0;
      0, 0,-1, 0, 0];
lap_input = imfilter(mosaic, F, 'replicate');
lap_guide = imfilter(guide.*mask, F, 'replicate');

% residual interpolation
[tentative,dif] = guidedfilter_MLRI_wei(guide, mosaic, mask, lap_guide, lap_input, mask, h, v, eps);
tentative = clip(tentative,0,1);
residual = mask.*(mosaic-tentative);
% Bilinear interpoaltion
H = [1/4, 1/2, 1/4;
     1/2,  1 , 1/2;
     1/4, 1/2, 1/4];
residual = imfilter(residual, H, 'replicate');
output = residual + tentative;

end
