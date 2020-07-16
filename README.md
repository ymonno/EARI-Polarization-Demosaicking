# EARI Polarization Demosaicking Codes
This is the source code of our proposed edge-aware residual interpolation (EARI) for monochrome and color polarization demosaicking <a href="http://www.ok.sc.e.titech.ac.jp/res/PolarDem/index.html" target="_blank">[Project]</a>.

## Demo

### - sample_download.m
To run our demo codes, please first run sample_download.m code to obtain sample 12-channel color-polarization data to be used for the demo.

### - demo_monochrome.m
#### Input
4-channel monochrome-polarization data (G channel data): I_0, I_45, I_90, I_135<br>
#### Mosaic pattern
90 &nbsp; 45<br>
135  &nbsp; 0<br>
#### Output
Demosaicked monochrome images for each polarization direction: Dem_0, Dem_45, Dem_90, Dem_135<br>
Stokes parameter images derived from the demosaicked images: Dem_S0, Dem_S1, Dem_S2, Dem_DoP, Dem_AoP<br>
CSV file containing PSNR values and angle RMSE for Table 1 in the paper

### - demo_color.m
#### Input
12-channel color-polarization mat data: mat = cat(3, RGB_0, RGB_45, RGB_90, RGB_135)<br>
#### Mosaic pattern
R_90 &nbsp;&nbsp; R_45 &nbsp; G_90 &nbsp; G_45<br>
R_135 &nbsp; R_0 &nbsp; G_135 &nbsp; G_0<br>
G_90 &nbsp;&nbsp; G_45 &nbsp; B_90 &nbsp; B_45<br>
G_135 &nbsp; G_0 &nbsp; B_135 &nbsp; B_0<br>
#### Output
Demosaicked RGB images for each polarization direction: Dem_0, Dem_45, Dem_90, Dem_135<br>
Stokes parameter images derived from the demosaicked RGB images: Dem_S0, Dem_S1, Dem_S2, Dem_DoP, Dem_AoP<br>
CSV file containing PSNR values and angle RMSE for Table 2 in the paper

## Dataset
Our 12-channel full color-polarization dataset is downloadable from our project page <a href="http://www.ok.sc.e.titech.ac.jp/res/PolarDem/index.html" target="_blank">[Project]</a>.

## Reference
The code is available only for research purpose. If you use this code for publications, please cite the following paper.<br>

"Monochrome and Color Polarization Demosaicking Using Edge-Aware Residual Interpolation"<br>
Miki Morimatsu, Yusuke Monno, Masayuki Tanaka, and Masatoshi Okutomi,<br>
IEEE International Conference on Image Processing (ICIP), October, 2020 (To appear).
