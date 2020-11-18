# solves interpolated value using pt values and barycentric
# coordinates
# a, b, c: color/normal/position/... values at a triangle's three vertices,
#          need to be row vectors
# bar_values: barycentric coordinates as a 1x3 row vector
# if_normalize: boolean to indicate if the interpolation result should be
#               normalized or not

function interpolated = bar_interpolate (a, b, c, bar_values, if_normalize)
  interpolated = sum(([bar_values; bar_values; bar_values].*[a' b' c']), 2);
  if if_normalize
    interpolated = utils_normalize(interpolated);
  endif
  return;
endfunction
