clear;

%% method selection
method = 1; %EARI(IGRI1)
% method = 2; %IGRI2

%% Settings
addpath(genpath('Functions'));
if method == 1
    filename = sprintf('EARI');
elseif method == 2
    filename = sprintf('IGRI2');
end

% Result folder
if exist('Results_monochrome') == 0
    mkdir('Results_monochrome')
end

% Load data (using the green-channel images of our color-polarization
% dataset as ground-truth monochrome polarization images)
data = sprintf('Input/apple');
load(data)

I_90 = RGB_90(:,:,2);
I_45 = RGB_45(:,:,2);
I_135 = RGB_135(:,:,2);
I_0 = RGB_0(:,:,2);

% Image size
s1 = 768;
s2 = 1024;

%% Make mosaic mask
% Mask for 2x2 regular pattern
mask = [];
for i = 1:2
    for j = 1:2
        temp_mask = zeros(s1,s2);
        temp_mask(i:2:end,j:2:end) = 1;
        mask = cat(3,mask,temp_mask);
    end
end

mask_P90 = mask(:,:,1);
mask_P45 = mask(:,:,2);
mask_P135 = mask(:,:,3);
mask_P0 = mask(:,:,4);


%% Calculate Stokes parameters(original)
A = [1,1,0,0;
    1,0,1,0;
    1,-1,0,0;
    1,0,-1,0];
[S0, S1, S2, DoP, AoP] = Process_images_stokes(I_0,I_45,I_90,I_135,A);

% Save original images
imwrite(I_90,sprintf('Results_monochrome/90.png'));
imwrite(I_45,sprintf('Results_monochrome/45.png'));
imwrite(I_135,sprintf('Results_monochrome/135.png'));
imwrite(I_0,sprintf('Results_monochrome/0.png'));
imwrite(S0,sprintf('Results_monochrome/S0.png'));
imwrite(aolp_dolp(AoP,sqrt(DoP)),sprintf('Results_monochrome/AoP_DoP.png'));


%% Polarization demosaicking
% Make polarization mosaic image
MPFA = zeros(s1,s2);
MPFA(1:2:end,1:2:end,:) = I_90(1:2:end,1:2:end);
MPFA(1:2:end,2:2:end,:) = I_45(1:2:end,2:2:end);
MPFA(2:2:end,1:2:end,:) = I_135(2:2:end,1:2:end);
MPFA(2:2:end,2:2:end,:) = I_0(2:2:end,2:2:end);   

% Polarization demosaicking
if method == 1
    [Dem_0, Dem_45, Dem_90, Dem_135] = EARI(BayerDem_RGB,eps,mask_P0,mask_P45,mask_P90,mask_P135);
elseif method == 2
    [Dem_0, Dem_45, Dem_90, Dem_135] = IGRI2(BayerDem_RGB,eps,mask_P0,mask_P45,mask_P90,mask_P135);
end


%% Calculate stokes parameters
[Dem_S0,Dem_S1,Dem_S2,Dem_DoP,Dem_AoP]...
    = Process_images_stokes(Dem_0,Dem_45,Dem_90,Dem_135,A);

% Save demosaicked images 
imwrite(Dem_90,sprintf('Results_monochrome/90_%s.png',filename));
imwrite(Dem_45,sprintf('Results_monochrome/45_%s.png',filename));
imwrite(Dem_135,sprintf('Results_monochrome/135_%s.png',filename));
imwrite(Dem_0,sprintf('Results_monochrome/0_%s.png',filename));
imwrite(Dem_S0,sprintf('Results_monochrome/S0_%s.png',filename));
imwrite(aolp_dolp(Dem_AoP,sqrt(Dem_DoP)),sprintf('Results_monochrome/AoP_DoP_%s.png',filename));


%% Calculate CPSNR and RMSE of angle error
psnr_90 = impsnr(I_90,Dem_90,1,15);
psnr_45 = impsnr(I_45,Dem_45,1,15);  
psnr_135 = impsnr(I_135,Dem_135,1,15);  
psnr_0 = impsnr(I_0,Dem_0,1,15);
psnr_S0 = impsnr(S0,Dem_S0,1,15);
psnr_S1 = impsnr(S1,Dem_S1,1,15);
psnr_S2 = impsnr(S2,Dem_S2,1,15);
psnr_DOLP = impsnr(DoP,Dem_DoP,1,15);
angleerror = angleerror_AOLP(AoP,Dem_AoP,15);

result = [psnr_0,psnr_45,psnr_90,psnr_135,psnr_S0,psnr_S1,psnr_S2,psnr_DOLP,angleerror];
csvwrite('Results_monochrome/monochrome.csv',result)
