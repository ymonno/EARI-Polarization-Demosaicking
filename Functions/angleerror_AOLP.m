function [angleerror] = angleerror_AOLP(x, y, b)

if( b > 0 )
     x = x(b:size(x,1)-b, b:size(x,2)-b,:);
     y = y(b:size(y,1)-b, b:size(y,2)-b,:);
end

 x = within01( x );
 y = within01( y );
 
 x = x(:);
 y = y(:);
 
 d0 = x - y;     d0 = d0 .* d0;
 dp = (x+1) - y; dp = dp .* dp;
 dn = (x-1) - y; dn = dn .* dn;
 
 dif = cat( 3, d0, dp, dn );
 dif = min( dif, [], 3 );
 
 mse = sum( dif ) / numel(dif);
 angleerror = sqrt(mse)*180;

end


function dst = within01( src )
 dst = src;
 
 d = ( dst > 1 );
 while( sum(d(:)) > 0 )
  dst = dst - d;
  d = ( dst > 1 );
 end

 d = ( dst < 0 );
 while( sum(d(:)) > 0 )
  dst = dst + d;
  d = ( dst < 0 );
 end

end
