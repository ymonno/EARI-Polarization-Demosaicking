function  [PolarDem_0, PolarDem_45, PolarDem_90, PolarDem_135] = IGRI2(MPFA,eps,mask_P0,mask_P45,mask_P90,mask_P135)

PolarDem_90 = zeros(size(MPFA));
PolarDem_45 = zeros(size(MPFA));
PolarDem_135 = zeros(size(MPFA));
PolarDem_0 = zeros(size(MPFA));

%residual interpolation parameta
pattern = 'rggb';
pattern2 = 'grbg';
sigma = 1;

[s1, s2] = size(MPFA(:,:,1));

for c = 1:size(MPFA,3)
    
    Input_90_0 = zeros(size(MPFA(:,:,c)));
    Input_135_45 = zeros(size(MPFA(:,:,c)));

    I_90_demo = zeros(size(MPFA(:,:,c)));
    I_135_demo = zeros(size(MPFA(:,:,c)));
    I_0_demo = zeros(size(MPFA(:,:,c)));
    I_45_demo = zeros(size(MPFA(:,:,c)));
    
    %% deformation data for diagonal RI
    for i = 1:s1
        for j = 1:s2
            
            if rem(i+j,2) == 0
            i1 = (i+j)/2;
            j1 = i1 - i + (s1/2);
            Input_90_0(i1,j1) = MPFA(i,j,c);
            
            else
            
            i2 = (i+j-1)/2;
            j2 = i2 - i + (s1/2+1);
            Input_135_45(i2,j2) = MPFA(i,j,c);
            
            end
        end
    end
    
    
    %% Diagonal RI
    Id_90_demo= residual_interpolation2(Input_90_0, pattern, sigma, eps); 
    Id_90_demo = clip(Id_90_demo,0,1);
    Id_0_demo= residual_interpolation2(Input_90_0, pattern2, sigma,eps); 
    Id_0_demo = clip(Id_0_demo,0,1);
    Id_135_demo= residual_interpolation2(Input_135_45, pattern, sigma,eps); 
    Id_135_demo = clip(Id_135_demo,0,1);
    Id_45_demo= residual_interpolation2(Input_135_45, pattern2, sigma,eps); 
    Id_45_demo = clip(Id_45_demo,0,1);
    
    
    %% deformation data for horizontal and vertical interpolation
    for i = 1:s1
        for j = 1:s2
            
            if rem(i+j,2) == 0
                
                i1 = (i+j)/2;
                j1 = i1 - i + (s1/2);
                I_90_demo(i,j) = Id_90_demo(i1,j1);
                I_0_demo(i,j) = Id_0_demo(i1,j1);
                
            else
            
                i2 = (i+j-1)/2;
                j2 = i2 - i + (s1/2+1);
                I_135_demo(i,j) = Id_135_demo(i2,j2);
                I_45_demo(i,j) = Id_45_demo(i2,j2);
                
            end
            
        end
    end
    
    S0_90_0 = (I_90_demo + I_0_demo)./2;
    S0_135_45 = (I_135_demo + I_45_demo)./2;
    
    Input2_90 = I_90_demo + S0_135_45;
    Input2_0 = I_0_demo + S0_135_45;
    Input2_135 = I_135_demo + S0_90_0;
    Input2_45 = I_45_demo + S0_90_0;
    
    
    %% Horizontal and vertical RI
    I_90_demo2 = residual_interpolation2(Input2_90, pattern2, sigma,eps); 
    I_90_demo2 = clip(I_90_demo2,0,1);
    I_0_demo2 = residual_interpolation2(Input2_0, pattern2, sigma,eps); 
    I_0_demo2 = clip(I_0_demo2,0,1);
    I_135_demo2 = residual_interpolation2(Input2_135, pattern, sigma,eps); 
    I_135_demo2 = clip(I_135_demo2,0,1);
    I_45_demo2 = residual_interpolation2(Input2_45, pattern, sigma,eps); 
    I_45_demo2 = clip(I_45_demo2,0,1);
    
    
    %% Residual Interpolation 
    % Guide image
    Guide = (I_90_demo2+I_0_demo2+I_135_demo2+I_45_demo2)./4;
 
    PolarDem_90(:,:,c) = residual_interpolation(Guide,mask_P90.*MPFA(:,:,c),mask_P90,eps);
    PolarDem_45(:,:,c) = residual_interpolation(Guide,mask_P45.*MPFA(:,:,c),mask_P45,eps);
    PolarDem_135(:,:,c) = residual_interpolation(Guide,mask_P135.*MPFA(:,:,c),mask_P135,eps);
    PolarDem_0(:,:,c) = residual_interpolation(Guide,mask_P0.*MPFA(:,:,c),mask_P0,eps); 
    
end
