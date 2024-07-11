function I =  residual_interpolation2(mosaic,pattern,sigma,eps)

[mosaic, mask] = mosaic_pol(mosaic, pattern);

I = green_interpolation(mosaic, mask, pattern, sigma,eps);

end
