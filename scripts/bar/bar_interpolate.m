# solves interpolated value using pt values and barycentric
# coordinates
# requires row vectors as inputs

function interpolated = bar_interpolate (a, b, c, bar_values)
  interpolated = sum(([bar_values; bar_values; bar_values].*[a' b' c']), 2);
  return;
endfunction
