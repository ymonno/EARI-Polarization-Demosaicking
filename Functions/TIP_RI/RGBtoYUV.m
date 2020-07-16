function YUV = RGBtoYUV(rgb)

% size
[H W B] = size(rgb);
% to vect
vecsRGB = [reshape(rgb(:,:,1),1,H*W);
           reshape(rgb(:,:,2),1,H*W);
           reshape(rgb(:,:,3),1,H*W)];
% convert matrix
M = [ 0.299  ,  0.587  ,  0.114  ;
     -0.14713, -0.28886,  0.436  ;
      0.615  , -0.51499, -0.10001];

      
% convert to YUV
vecYUV = M * vecsRGB;
YUV = cat(3,reshape(vecYUV(1,:),H,W),reshape(vecYUV(2,:),H,W),reshape(vecYUV(3,:),H,W));


end
