function  [PolarDem_0, PolarDem_45, PolarDem_90, PolarDem_135] = EARI(MPFA,eps,mask_P0,mask_P45,mask_P90,mask_P135)

PolarDem_90 = zeros(size(MPFA));
PolarDem_45 = zeros(size(MPFA));
PolarDem_135 = zeros(size(MPFA));
PolarDem_0 = zeros(size(MPFA));

%% Four-directional intensity estimation
% Four-directional intensity
Fn = [1/8,1/4,1/8;
     1/8,1/4,1/8;
     0,0,0];

Fs = [0,0,0;
     1/8,1/4,1/8;
     1/8,1/4,1/8];

Fw = Fn.'; Fe = Fs.';

Xn = imfilter(MPFA,Fn,'replicate');
Xe = imfilter(MPFA,Fe,'replicate');
Xw = imfilter(MPFA,Fw,'replicate');
Xs = imfilter(MPFA,Fs,'replicate');


%% Weight calculation
% Directional intensity difference
Hn = [-1/2, 1, -1/2;
    1/2, -1, 1/2;
    0, 0, 0];   

Hs = [0, 0, 0;
    1/2, -1, 1/2;
    -1/2, 1, -1/2];
   
Hw = Hn.'; He = Hs.';

In = imfilter(MPFA,Hn,'replicate');
Ie = imfilter(MPFA,He,'replicate');
Iw = imfilter(MPFA,Hw,'replicate');
Is = imfilter(MPFA,Hs,'replicate');

In = abs(In);
Ie = abs(Ie);
Iw = abs(Iw);
Is = abs(Is);

% Smoothing
Mn = [1/15, 1/15, 1/15, 1/15, 1/15;
    1/15, 1/15, 1/15, 1/15, 1/15;
    1/15, 1/15, 1/15, 1/15, 1/15;
    0, 0, 0, 0, 0;
    0, 0, 0, 0, 0];

Ms = [0, 0, 0, 0, 0;
    0, 0, 0, 0, 0;
    1/15, 1/15, 1/15, 1/15, 1/15;
    1/15, 1/15, 1/15, 1/15, 1/15;
    1/15, 1/15, 1/15, 1/15, 1/15];

Mw = Mn.'; Me = Ms.';

wn = imfilter(In,Mn,'replicate');
we = imfilter(Ie,Me,'replicate');
ww = imfilter(Iw,Mw,'replicate');
ws = imfilter(Is,Ms,'replicate');

% Weight
Wn = 1./(wn + eps);
We = 1./(we + eps);
Ww = 1./(ww + eps);
Ws = 1./(ws + eps);

% Weighted averaging (The edge-aware guide)
W = Wn + We + Ww + Ws; 
Guide = (Wn.*Xn + We.*Xe + Ww.*Xw + Ws.*Xs)./(W + eps);


%% Residual Interpolation using the edge-aware guide
for c = 1:size(MPFA,3)
    
    PolarDem_90(:,:,c) = residual_interpolation(Guide(:,:,c),mask_P90.*MPFA(:,:,c),mask_P90,eps);
    PolarDem_45(:,:,c) = residual_interpolation(Guide(:,:,c),mask_P45.*MPFA(:,:,c),mask_P45,eps);
    PolarDem_135(:,:,c) = residual_interpolation(Guide(:,:,c),mask_P135.*MPFA(:,:,c),mask_P135,eps);
    PolarDem_0(:,:,c) = residual_interpolation(Guide(:,:,c),mask_P0.*MPFA(:,:,c),mask_P0,eps);
    
end
