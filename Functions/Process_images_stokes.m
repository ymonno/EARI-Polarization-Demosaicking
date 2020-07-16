function [S0_scaled,S1_scaled,S2_scaled,DOLP_scaled,AOLP_scaled] = Process_images_stokes(I0,I45,I90,I135,A)
% PROCESS_IMAGES_STOKES Recover 3 Stokes parameters from 4 states of
% polarization. DOLP, angle of linear polarization, and RGB visualization
% are also provided. All images are mapped to [0 1] range
% Author: Pierre-Jean Lapray
% Parameters: display: 'yes' or 'no' to plot results in one Figure
% A: measurement matrix from calibration (using ideal matrix if empty

%% Calculate Stokes parameters
if exist('A','var') == 0
    S0=I0+I90;
    % Scale between 0 and 1 for visualisation
    S1=I0-I90;
    S2=I45-I135;
else
    S = (A(:,:)'*reshape([I0(:,:,1) I45(:,:,1) I90(:,:,1) I135(:,:,1)],size(I0,1)*size(I0,2),4)')';
    S0 = reshape(S(:,1),size(I0,1),size(I0,2))./4;
    S1 = reshape(S(:,2),size(I0,1),size(I0,2));
    S2 = reshape(S(:,3),size(I0,1),size(I0,2));
end;

% Scaling
scale = [0 1];
S0_scaled = (S0)*(scale(2)-scale(1))/(scale(2)) + scale(1);
S1_scaled = (S1+scale(2))*(scale(2)-scale(1))/(2*scale(2)) + scale(1);
S2_scaled = (S2+scale(2))*(scale(2)-scale(1))/(2*scale(2)) + scale(1);

%% Calculate DOLP and AOLP
a = S1.^2;
b = S2.^2;
DOLP_2 = sqrt(a+b);
DOLP = DOLP_2 ./ (S0);
DOLP_scaled = ((DOLP)*(scale(2)-scale(1))/(2) + scale(1));
AOLP = 0.5*atan2(S2,S1);
AOLP_scaled = ((AOLP+pi/2)*(scale(2)-scale(1))/pi + scale(1));
%AOLP_scaled(DOLP_scaled(:)<0.15)=0;

%% Remove NaN and inf values
DOLP_scaled(DOLP_scaled<=0) = 0;
DOLP_scaled(DOLP_scaled>=1) = 1;
% DOLP_scaled(isnan(DOLP_scaled)) = 0;
% DOLP_scaled(isinf(DOLP_scaled)) = 0;

% Int_pol = sqrt(S1.^2+S2.^2);
% Int_unpol = (S0-0.5*Int_pol);
% 
% %% RGB and HSV pol representation
% RGBpol = zeros(size(I90,1),size(I90,2),3);
% RGBpol(:,:,1) = I90;
% RGBpol(:,:,2) = I0;
% RGBpol(:,:,3) = I45;
% 
% HSV = zeros(size(I90,1),size(I90,2),3);
% sRGB_HSV = zeros(size(I90,1),size(I90,2),3);
% HSV(:,:,1) = (AOLP +(pi/2))/pi;%(AOLP +(pi/2))/pi;max(max(DOLP))
% HSV(:,:,2) = DOLP_scaled*2;% DOLP;%Int_pol./S0;
% HSV(:,:,3) = S0_scaled;%Int_pol;%S0;%(S0-min(min(S0)))./(max(max(S0))-min(min(S0)));%(S0-min(min(S0)))./(max(max(S0))-min(min(S0)));%Int_pol;
% HSV(HSV<0)=0;
% sRGB_HSV = hsv2rgb(HSV);
% 
% if strcmp(display,'yes')
%     %% Plot image
%     figure('units','normalized','outerposition',[0 0 1 1]);set(gcf,'Color',[1,1,1]);
%     %% Plot intensity images
%     subplot(3,4,1);imshow(I0(:,:));title(['I0 ']);
%     subplot(3,4,2);imshow(I45(:,:));title(['I45 ']);
%     subplot(3,4,3);imshow(I90(:,:));title(['I90 ']);
%     subplot(3,4,4);imshow(I135(:,:));title(['I135 ']);
% 
%     %% Plot Stokes images
%     subplot(3,4,5);imshow(im2double(S0_scaled(:,:)));title('S0');
%     subplot(3,4,6);imshow(im2double(S1_scaled(:,:)));title('S1');
%     subplot(3,4,7);imshow(im2double(S2_scaled(:,:)));title('S2');
%     subplot(3,4,8);imshow(im2double(Int_unpol(:,:)));title('Intensity unpol');
%     subplot(3,4,9);imshow((DOLP_scaled(:,:)),[0 1 ]);title('DOLP');colorbar('Ticks',[0,0.25,0.50,0.75,1],...
%              'TickLabels',{'0%','25%','50%','75%','100%'});
%     ax2 = subplot(3,4,10);imshow(im2double(AOLP_scaled(:,:)));colormap(ax2,'jet');colorbar('Ticks',[0,0.25,0.50,0.75,1],...
%              'TickLabels',{'0°','45°','90°','135°','180°'});title('AOLP');
%     subplot(3,4,11);imshow(im2double(RGBpol(:,:,:)));title({'RGB representation';'R=I90 G=I0 B=I45'},'Interpreter','latex','FontSize',13);
%     subplot(3,4,12);imshow(im2double(sRGB_HSV(:,:,:)));title({'HSV representation';'Teinte=AOLP Saturation=DOLP';'Valeur=S0'},'Interpreter','latex','FontSize',13);
%     set(gcf,'PaperPositionMode','auto')
%     %saveas(gcf,[info '.jpg'])
% end
end

