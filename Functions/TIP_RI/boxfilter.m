%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-h:x+h,y-v:y+v)));
%   - Running time independent of h, v; 
%   - Equivalent to the function: colfilt(imSrc, [2*v+1, 2*h+1], 'sliding', @sum);
%   - But much faster.
%
%   This code is modified from the downloaded code of original guided filter paper. 
%       http://research.microsoft.com/en-us/um/people/kahe/eccv10/
%       "Guided Image Filtering", by Kaiming He, Jian Sun, and Xiaoou Tang, in TPAMI 2012.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function imDst = boxfilter(imSrc, h, v)

[hei, wid] = size(imSrc);
imDst = zeros( size(imSrc) );

if v ~= 0
%cumulative sum over Y axis
imCum = cumsum(imSrc, 1);
%difference over Y axis
imDst(1:v+1, :) = imCum(1+v:2*v+1, :);
imDst(v+2:hei-v, :) = imCum(2*v+2:hei, :) - imCum(1:hei-2*v-1, :);
imDst(hei-v+1:hei, :) = repmat(imCum(hei, :), [v, 1]) - imCum(hei-2*v:hei-v-1, :);
end

if h ~= 0
    if v ~= 0
        %cumulative sum over X axis
        imCum = cumsum(imDst, 2);
    else
        %cumulative sum over X axis
        imCum = cumsum(imSrc, 2);
    end
%difference over Y axis
imDst(:, 1:h+1) = imCum(:, 1+h:2*h+1);
imDst(:, h+2:wid-h) = imCum(:, 2*h+2:wid) - imCum(:, 1:wid-2*h-1);
imDst(:, wid-h+1:wid) = repmat(imCum(:, wid), [1, h]) - imCum(:, wid-2*h:wid-h-1);
end

end

