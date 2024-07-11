function [mosaic mask] = mosaic_pol(pol, pattern)

num = zeros(size(pattern));
p = find((pattern == 'r') + (pattern == 'R'));
num(p) = 1;
p = find((pattern == 'g') + (pattern == 'G'));
num(p) = 2;
p = find((pattern == 'b') + (pattern == 'B'));
num(p) = 3;

mosaic = zeros(size(pol, 1),size(pol, 2), 3);
mask = zeros(size(pol, 1), size(pol, 2), 3);

rows1 = 1:2:size(pol, 1);
rows2 = 2:2:size(pol, 1);
cols1 = 1:2:size(pol, 2);
cols2 = 2:2:size(pol, 2);

mask(rows1, cols1, num(1)) = 1;
mask(rows1, cols2, num(2)) = 1;
mask(rows2, cols1, num(3)) = 1;
mask(rows2, cols2, num(4)) = 1;

mosaic(:,:,1) = pol .* mask(:,:,1);
mosaic(:,:,2) = pol .* mask(:,:,2);
mosaic(:,:,3) = pol .* mask(:,:,3);

end
