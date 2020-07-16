function blue = blue_interpolation(green, mosaic, mask,eps)
% parameters for guided upsampling
h = 5;
v = 5;

% Laplacian
F = [ 0, 0,-1, 0, 0;
      0, 0, 0, 0, 0;
     -1, 0, 4, 0,-1;
      0, 0, 0, 0, 0;
      0, 0,-1, 0, 0];
lap_blue = imfilter(mosaic(:,:,3), F, 'replicate');
lap_green = imfilter(green.*mask(:,:,3), F, 'replicate');

% B interpolation
tentativeB = guidedfilter_MLRI_wei(green, mosaic(:,:,3), mask(:,:,3), lap_green, lap_blue, mask(:,:,3), h, v, eps);
tentativeB = clip(tentativeB,0,255);
residualB = mask(:,:,3).*(mosaic(:,:,3)-tentativeB);
% Bilinear interpolation
H = [1/4, 1/2, 1/4;
     1/2,  1 , 1/2;
     1/4, 1/2, 1/4];
residualB = imfilter(residualB, H, 'replicate');
blue = residualB + tentativeB;

end
