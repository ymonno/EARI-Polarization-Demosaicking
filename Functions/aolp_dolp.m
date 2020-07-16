function rgb = aolp_dolp(aolp,dolp)

z = ones(size(aolp));

hsv = cat(3,aolp,dolp,z);
rgb = hsv2rgb(hsv);

end

