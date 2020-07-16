function green =  green_interpolation(mosaic,mask,pattern,sigma,eps)
% mask
imask = (mask == 0);

% raw CFA data
rawq = sum(mosaic, 3);

%%% Calculate Horizontal and Vertical Color Differences %%%
% mask
maskGr = zeros(size(rawq));
maskGb = zeros(size(rawq));
if strcmp(pattern,'grbg')
    maskGr(1:2:size(rawq,1), 1:2:size(rawq,2)) = 1;
    maskGb(2:2:size(rawq,1), 2:2:size(rawq,2)) = 1;
elseif strcmp(pattern,'rggb')
    maskGr(1:2:size(rawq,1), 2:2:size(rawq,2)) = 1;
    maskGb(2:2:size(rawq,1), 1:2:size(rawq,2)) = 1;
elseif strcmp(pattern,'gbrg')
    maskGb(1:2:size(rawq,1), 1:2:size(rawq,2)) = 1;
    maskGr(2:2:size(rawq,1), 2:2:size(rawq,2)) = 1;
elseif strcmp(pattern,'bggr')
    maskGb(1:2:size(rawq,1), 2:2:size(rawq,2)) = 1;
    maskGr(2:2:size(rawq,1), 1:2:size(rawq,2)) = 1;
end

% guide image
Kh = [1/2,0,1/2];
Kv = Kh';
rawh = imfilter(rawq,Kh,'replicate');
rawv = imfilter(rawq,Kv,'replicate');
Guidegh = mosaic(:,:,2) + rawh .* mask(:,:,1) + rawh .* mask(:,:,3);
Guiderh = mosaic(:,:,1) + rawh .* maskGr;
Guidebh = mosaic(:,:,3) + rawh .* maskGb;
Guidegv = mosaic(:,:,2) + rawv .* mask(:,:,1) + rawv .* mask(:,:,3);
Guiderv = mosaic(:,:,1) + rawv .* maskGb;
Guidebv = mosaic(:,:,3) + rawv .* maskGr;

% tentative image
h=3;
v=3;
F = [-1,0,2,0,-1];
% horizontal
difR = imfilter(mosaic(:,:,1),F,'replicate');
difGr = imfilter(Guidegh.*mask(:,:,1),F,'replicate');
tentativeRh = guidedfilter_MLRI_wei(Guidegh, mosaic(:,:,1), mask(:,:,1), difGr, difR, mask(:,:,1), h, v, eps);

difGr = imfilter(mosaic(:,:,2).*maskGr,F,'replicate');
difR = imfilter(Guiderh.*maskGr,F,'replicate');
tentativeGrh = guidedfilter_MLRI_wei(Guiderh, mosaic(:,:,2).*maskGr, maskGr, difR, difGr, maskGr, h, v, eps);

difB = imfilter(mosaic(:,:,3),F,'replicate');
difGb = imfilter(Guidegh.*mask(:,:,3),F,'replicate');
tentativeBh = guidedfilter_MLRI_wei(Guidegh, mosaic(:,:,3), mask(:,:,3), difGb, difB, mask(:,:,3), h, v, eps);

difGb = imfilter(mosaic(:,:,2).*maskGb,F,'replicate');
difB = imfilter(Guidebh.*maskGb,F,'replicate');
tentativeGbh = guidedfilter_MLRI_wei(Guidebh, mosaic(:,:,2).*maskGb, maskGb, difB, difGb, maskGb, h, v, eps);
% vertical
F = F';
difR = imfilter(mosaic(:,:,1),F,'replicate');
difGr = imfilter(Guidegv.*mask(:,:,1),F,'replicate');
tentativeRv = guidedfilter_MLRI_wei(Guidegv, mosaic(:,:,1), mask(:,:,1), difGr, difR, mask(:,:,1), v, h, eps);

difGr = imfilter(mosaic(:,:,2).*maskGb,F,'replicate');
difR = imfilter(Guiderv.*maskGb,F,'replicate');
tentativeGrv = guidedfilter_MLRI_wei(Guiderv, mosaic(:,:,2).*maskGb, maskGb, difR, difGr, maskGb, v, h, eps);

difB = imfilter(mosaic(:,:,3),F,'replicate');
difGb = imfilter(Guidegv.*mask(:,:,3),F,'replicate');
tentativeBv = guidedfilter_MLRI_wei(Guidegv, mosaic(:,:,3), mask(:,:,3), difGb, difB, mask(:,:,3), v, h, eps);

difGb = imfilter(mosaic(:,:,2).*maskGr,F,'replicate');
difB = imfilter(Guidebv.*maskGr,F,'replicate');
tentativeGbv = guidedfilter_MLRI_wei(Guidebv, mosaic(:,:,2).*maskGr, maskGr, difB, difGb, maskGr, v, h, eps);
% clip 
tentativeGrh = clip(tentativeGrh,0,255);
tentativeGrv = clip(tentativeGrv,0,255);
tentativeGbh = clip(tentativeGbh,0,255);
tentativeGbv = clip(tentativeGbv,0,255);
tentativeRh = clip(tentativeRh,0,255);
tentativeRv = clip(tentativeRv,0,255);
tentativeBh = clip(tentativeBh,0,255);
tentativeBv = clip(tentativeBv,0,255);

% residual
residualGrh = ( mosaic(:,:,2) - tentativeGrh ) .* maskGr;
residualGbh = ( mosaic(:,:,2) - tentativeGbh ) .* maskGb;
residualRh = ( mosaic(:,:,1) - tentativeRh ) .* mask(:,:,1);
residualBh = ( mosaic(:,:,3) - tentativeBh ) .* mask(:,:,3);
residualGrv = ( mosaic(:,:,2) - tentativeGrv ) .* maskGb;
residualGbv = ( mosaic(:,:,2) - tentativeGbv ) .* maskGr;
residualRv = ( mosaic(:,:,1) - tentativeRv ) .* mask(:,:,1);
residualBv = ( mosaic(:,:,3) - tentativeBv ) .* mask(:,:,3);

% residual linear interpolation
Kh = [1/2,0,1/2];
residualGrh = imfilter(residualGrh,Kh,'replicate');
residualGbh = imfilter(residualGbh,Kh,'replicate');
residualRh = imfilter(residualRh,Kh,'replicate');
residualBh = imfilter(residualBh,Kh,'replicate');
Kv = Kh';
residualGrv = imfilter(residualGrv,Kv,'replicate');
residualGbv = imfilter(residualGbv,Kv,'replicate');
residualRv = imfilter(residualRv,Kv,'replicate');
residualBv = imfilter(residualBv,Kv,'replicate');

% add tentative image
Grh = ( tentativeGrh + residualGrh ) .* mask(:,:,1);
Gbh = ( tentativeGbh + residualGbh ) .* mask(:,:,3);
Rh = ( tentativeRh + residualRh ) .* maskGr;
Bh = ( tentativeBh + residualBh ) .* maskGb;
Grv = ( tentativeGrv + residualGrv ) .* mask(:,:,1);
Gbv = ( tentativeGbv + residualGbv ) .* mask(:,:,3);
Rv = ( tentativeRv + residualRv ) .* maskGb;
Bv = ( tentativeBv + residualBv ) .* maskGr;
% clip
Grh = clip(Grh,0,255);
Grv = clip(Grv,0,255);
Gbh = clip(Gbh,0,255);
Gbv = clip(Gbv,0,255);
Rh = clip(Rh,0,255);
Rv = clip(Rv,0,255);
Bh = clip(Bh,0,255);
Bv = clip(Bv,0,255);

% vertical and horizontal color difference 
difh = mosaic(:,:,2) + Grh + Gbh - mosaic(:,:,1) - mosaic(:,:,3) - Rh -Bh;
difv = mosaic(:,:,2) + Grv + Gbv - mosaic(:,:,1) - mosaic(:,:,3) - Rv -Bv;

%%% Combine Vertical and Horizontal Color Differences %%%
% color difference gradient
Kh = [1,0,-1];
Kv = Kh';
difh2 = abs(imfilter(difh,Kh,'replicate'));
difv2 = abs(imfilter(difv,Kv,'replicate'));

% directional weight
K = ones(3,3);
wh = imfilter(difh2,K,'replicate');
wv = imfilter(difv2,K,'replicate'); 
Kw = [1,0,0]; 
Ke = [0,0,1];
Ks = Ke'; 
Kn = Kw';
Ww = imfilter(wh,Kw,'replicate');
We = imfilter(wh,Ke,'replicate');
Wn = imfilter(wv,Kn,'replicate');
Ws = imfilter(wv,Ks,'replicate');
Ww = 1./(power(Ww,2) + 1E-2);
We = 1./(power(We,2) + 1E-2);
Ws = 1./(power(Ws,2) + 1E-2);
Wn = 1./(power(Wn,2) + 1E-2);

% combine directional color difference
h = fspecial('gaussian', [1,9], sigma);
Ke = [0,0,0,0,1,1,1,1,1] .* h; 
Kw = [1,1,1,1,1,0,0,0,0] .* h;
Ke = Ke / sum(Ke,2);
Kw = Kw / sum(Kw,2);
Ks = Ke'; 
Kn = Kw';
difn = imfilter(difv,Kn,'replicate');
difs = imfilter(difv,Ks,'replicate');
difw = imfilter(difh,Kw,'replicate');
dife = imfilter(difh,Ke,'replicate');
Wt = Ww+We+Wn+Ws;
dif = (Wn.*difn + Ws.*difs + Ww.*difw + We.*dife) ./ Wt;
green = dif + rawq;
green = green .* imask(:,:,2) + rawq .* mask(:,:,2);

end
