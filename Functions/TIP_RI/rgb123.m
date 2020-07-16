% rgb123 translate r, g, and b to 1, 2, and 3, respectively.
% 
% num = rgb123(str)
% 
% 
% Output parameter:
%  num: translated number
% 
% 
% Input parameter:
%  str: string ex) 'rggb'
% 
% 
% Example:
%  num = rgb123( 'rggb' );
% 
% 
% Version: 20120616

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous tools for image processing                 %
%                                                          %
% Copyright (C) 2012 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function num = rgb123(str)

num = zeros(size(str));

p = find( ( str == 'r' ) + ( str == 'R' ) );
num(p) = 1;

p = find( ( str == 'g' ) + ( str == 'G' ) );
num(p) = 2;

p = find( ( str == 'b' ) + ( str == 'B' ) );
num(p) = 3;

