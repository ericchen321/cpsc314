# returns the interpolated vector on a line segment
# pos_pt: position of point to be interpolated
# pos_pt1, pos_pt2: position of end points of the line segment
# vec_pt1, vec_pt2: color/normal/... of pt1 and pt2
# if_normalize: boolean to indicate if the interpolation result should be
#               normalized or not
# returns vec_pt, the interpolated color/normal of pt

function vec_pt = lin_interp_interpolate_line (pos_pt, pos_pt1, pos_pt2, vec_pt1, vec_pt2, if_normalize)
  # check if the pt is on the segment
  sum_dists = utils_solve_distance(pos_pt, pos_pt1) + utils_solve_distance(pos_pt, pos_pt2);
  segLength = utils_solve_distance(pos_pt1, pos_pt2);
  if (utils_check_equal(sum_dists, segLength, 0.05) != 1)
    error("the given point is not between the two end points!");
  endif
  
  # interpolate
  dist_pt1 = utils_solve_distance(pos_pt, pos_pt1);
  dist_pt2 = utils_solve_distance(pos_pt, pos_pt2);
  vec_pt = (dist_pt1/segLength)*vec_pt2 + (dist_pt2/segLength)*vec_pt1;
  
  # normalize if applicable
  if if_normalize
    vec_pt = utils_normalize(vec_pt);
  endif
  
  return;
endfunction
