clear;
tic

%% method selection
method = 1; %EARI(IGRI1)
% method = 2; %IGRI2


%% settings
addpath(genpath('Functions'));
if method == 1
    filename = sprintf('EARI');
elseif method == 2
    filename = sprintf('IGRI2');
end

% Result folder
if exist('Results_color') == 0
    mkdir('Results_color')
end

% Load data
data = sprintf('Input/apple');
load(data)

% image size
s1 = 768;
s2 = 1024;


%% make mosaic mask
% mask for 4x4 regular pattern
mask = [];
for i = 1:4
    for j = 1:4
        temp_mask = zeros(s1,s2,1);
        temp_mask(i:4:end,j:4:end,1) = 1;
        mask = cat(3,mask,temp_mask);
    end
end

% mask for R channel
mask_R90 = mask(:,:,9);
mask_R45 = mask(:,:,10);
mask_R135 = mask(:,:,13);
mask_R0 = mask(:,:,14);

% mask for G channel
mask_G90 = mask(:,:,1) + mask(:,:,11);
mask_G45 = mask(:,:,2) + mask(:,:,12);
mask_G135 = mask(:,:,5) + mask(:,:,15);
mask_G0 = mask(:,:,6) + mask(:,:,16);

% mask for B channel
mask_B90 = mask(:,:,3);
mask_B45 = mask(:,:,4);
mask_B135 = mask(:,:,7);
mask_B0 = mask(:,:,8);

% mask for each polarization angle
mask_P90 = mask_R90 + mask_G90 + mask_B90;
mask_P45 = mask_R45 + mask_G45 + mask_B45;
mask_P135 = mask_R135 + mask_G135 + mask_B135;
mask_P0 = mask_R0 + mask_G0 + mask_B0;


%% calculate Stokes parameters(original)
A = [1,1,0,0;
    1,0,1,0;
    1,-1,0,0;
    1,0,-1,0];
[R_S0,R_S1,R_S2,R_DoP,R_AoP] = Process_images_stokes(RGB_0(:,:,1),RGB_45(:,:,1),RGB_90(:,:,1),RGB_135(:,:,1),A);
[G_S0,G_S1,G_S2,G_DoP,G_AoP] = Process_images_stokes(RGB_0(:,:,2),RGB_45(:,:,2),RGB_90(:,:,2),RGB_135(:,:,2),A);
[B_S0,B_S1,B_S2,B_DoP,B_AoP] = Process_images_stokes(RGB_0(:,:,3),RGB_45(:,:,3),RGB_90(:,:,3),RGB_135(:,:,3),A);

% save images
imwrite(RGB_90,sprintf('Results_color/90.png'));
imwrite(RGB_45,sprintf('Results_color/45.png'));
imwrite(RGB_135,sprintf('Results_color/135.png'));
imwrite(RGB_0,sprintf('Results_color/0.png'));
S0 = cat(3,R_S0,G_S0,B_S0);
imwrite(S0,sprintf('Results_color/S0.png'));

imwrite(R_S0,sprintf('Results_color/R_S0.png'));
imwrite(aolp_dolp(R_AoP,sqrt(R_DoP)),sprintf('Results_color/R_AoP_DoP.png'));

imwrite(G_S0,sprintf('Results_color/G_S0.png'));
imwrite(aolp_dolp(G_AoP,sqrt(G_DoP)),sprintf('Results_color/G_AoP_DoP.png'));

imwrite(B_S0,sprintf('Results_color/B_S0.png'));
imwrite(aolp_dolp(B_AoP,sqrt(B_DoP)),sprintf('Results_color/B_AoP_DoP.png'));


%% Bayer demosaicking
% make PCFA image
R_90 = mask_R90 .* RGB_90(:,:,1);
R_45 = mask_R45 .* RGB_45(:,:,1);
R_135 = mask_R135 .* RGB_135(:,:,1);
R_0 = mask_R0 .* RGB_0(:,:,1);

G_90 = mask_G90 .* RGB_90(:,:,2);
G_45 = mask_G45 .* RGB_45(:,:,2);
G_135 = mask_G135 .* RGB_135(:,:,2);
G_0 = mask_G0 .* RGB_0(:,:,2);

B_90 = mask_B90 .* RGB_90(:,:,3);
B_45 = mask_B45 .* RGB_45(:,:,3);
B_135 = mask_B135 .* RGB_135(:,:,3);
B_0 = mask_B0 .* RGB_0(:,:,3);

PCFA = R_90 + R_45 + R_135 + R_0 + G_90 + G_45 + G_135 + G_0...
    + B_90 + B_45 + B_135 + B_0;

% make Bayer polarization images
Bayer_90 = PCFA(1:2:end,1:2:end);
Bayer_45 = PCFA(1:2:end,2:2:end);
Bayer_135 = PCFA(2:2:end,1:2:end);
Bayer_0 = PCFA(2:2:end,2:2:end);

% Bayer demosaicking
pattern = 'gbrg'; sigma = 1; eps = 1e-32;
BayerDem_90 = demosaick(repmat(Bayer_90,[1,1,3]),pattern,sigma,eps);
BayerDem_45 = demosaick(repmat(Bayer_45,[1,1,3]),pattern,sigma,eps);
BayerDem_135 = demosaick(repmat(Bayer_135,[1,1,3]),pattern,sigma,eps);
BayerDem_0 = demosaick(repmat(Bayer_0,[1,1,3]),pattern,sigma,eps);  


%% Polarization demosaicking
% make RGB polarization mosaic image
BayerDem_RGB = zeros(s1,s2,3);
BayerDem_RGB(1:2:end,1:2:end,:) = BayerDem_90;
BayerDem_RGB(1:2:end,2:2:end,:) = BayerDem_45;
BayerDem_RGB(2:2:end,1:2:end,:) = BayerDem_135;
BayerDem_RGB(2:2:end,2:2:end,:) = BayerDem_0;   

% Polarization demosaicking
if method == 1
    [Dem_0, Dem_45, Dem_90, Dem_135] = EARI(BayerDem_RGB,eps,mask_P0,mask_P45,mask_P90,mask_P135);
elseif method == 2
    [Dem_0, Dem_45, Dem_90, Dem_135] = IGRI2(BayerDem_RGB,eps,mask_P0,mask_P45,mask_P90,mask_P135);
end


%% Calculate stokes
[Dem_R_S0,Dem_R_S1,Dem_R_S2,Dem_R_DoP,Dem_R_AoP]...
    = Process_images_stokes(Dem_0(:,:,1),Dem_45(:,:,1),Dem_90(:,:,1),Dem_135(:,:,1),A);
[Dem_G_S0,Dem_G_S1,Dem_G_S2,Dem_G_DoP,Dem_G_AoP]...
    = Process_images_stokes(Dem_0(:,:,2),Dem_45(:,:,2),Dem_90(:,:,2),Dem_135(:,:,2),A);
[Dem_B_S0,Dem_B_S1,Dem_B_S2,Dem_B_DoP,Dem_B_AoP]...
    = Process_images_stokes(Dem_0(:,:,3),Dem_45(:,:,3),Dem_90(:,:,3),Dem_135(:,:,3),A);

% Save demosaicked images 
imwrite(Dem_90,sprintf('Results_color/90_%s.png',filename));
imwrite(Dem_45,sprintf('Results_color/45_%s.png',filename));
imwrite(Dem_135,sprintf('Results_color/135_%s.png',filename));
imwrite(Dem_0,sprintf('Results_color/0_%s.png',filename));
Dem_S0 = cat(3,Dem_R_S0,Dem_G_S0,Dem_B_S0);
imwrite(Dem_S0,sprintf('Results_color/S0_%s.png',filename));

imwrite(Dem_R_S0,sprintf('Results_color/R_S0_%s.png',filename));
imwrite(aolp_dolp(Dem_R_AoP,sqrt(Dem_R_DoP)),sprintf('Results_color/R_AoP_DoP_%s.png',filename));

imwrite(Dem_G_S0,sprintf('Results_color/G_S0_%s.png',filename));
imwrite(aolp_dolp(Dem_G_AoP,sqrt(Dem_G_DoP)),sprintf('Results_color/G_AoP_DoP_%s.png',filename));

imwrite(Dem_B_S0,sprintf('Results_color/B_S0_%s.png',filename));
imwrite(aolp_dolp(Dem_B_AoP,sqrt(Dem_B_DoP)),sprintf('Results_color/B_AoP_DoP_%s.png',filename));


%% CPSNR calculation 
S0 = cat(3,R_S0,G_S0,B_S0);
S1 = cat(3,R_S1,G_S1,B_S1);
S2 = cat(3,R_S2,G_S2,B_S2);
DoP = cat(3,R_DoP,G_DoP,B_DoP);
AoP = cat(3,R_AoP,G_AoP,B_AoP);
Dem_S1 = cat(3,Dem_R_S1,Dem_G_S1,Dem_B_S1);
Dem_S2 = cat(3,Dem_R_S2,Dem_G_S2,Dem_B_S2);
Dem_DoP = cat(3,Dem_R_DoP,Dem_G_DoP,Dem_B_DoP);
Dem_AoP = cat(3,Dem_R_AoP,Dem_G_AoP,Dem_B_AoP);

cpsnr_90 = imcpsnr(RGB_90,Dem_90,1,15);
cpsnr_45 = imcpsnr(RGB_45,Dem_45,1,15);  
cpsnr_135 = imcpsnr(RGB_135,Dem_135,1,15);  
cpsnr_0 = imcpsnr(RGB_0,Dem_0,1,15);

cpsnr_S0 = imcpsnr(S0,Dem_S0,1,15);
cpsnr_S1 = imcpsnr(S1,Dem_S1,1,15);
cpsnr_S2 = imcpsnr(S2,Dem_S2,1,15);
cpsnr_DOLP = imcpsnr(DoP,Dem_DoP,1,15);
angleerror = angleerror_AOLP(AoP,Dem_AoP,15);

result = [cpsnr_0,cpsnr_45,cpsnr_90,cpsnr_135,cpsnr_S0,cpsnr_S1,cpsnr_S2,cpsnr_DOLP,angleerror];
csvwrite('Results_color/color.csv',result)
