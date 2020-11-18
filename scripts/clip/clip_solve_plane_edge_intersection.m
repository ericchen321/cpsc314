# solve intersection point between a triangle edge and a clipping plane

function pt_intersection = clip_solve_plane_edge_intersection(pt_1, pt_2, pt_p, n)
  d1 = dot(n, (pt_1 - pt_p))
  d2 = dot(n, (pt_2 - pt_p))
  t = 0.0 # declare t
  if (utils_check_equal(d1, 0.0, 0.01) && utils_check_equal(d2, 0.0, 0.01))
    error("both pt_1 and pt_2 lie on the plane!");
  elseif (utils_check_equal(d1, 0.0, 0.01))
    error("pt_1 lies on the plane!");
  elseif (utils_check_equal(d2, 0.0, 0.01))
    error("pt_2 lies on the plane!");
  elseif (utils_check_equal((d1-d2), 0.0, 0.01))
    error("the edge does not intersect the plane!");
  else
    t =  d1 / (d1-d2);
  endif
  pt_intersection = pt_1 + t*(pt_2 - pt_1);
  return
endfunction
