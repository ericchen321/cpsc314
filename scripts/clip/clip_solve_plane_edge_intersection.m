# solve intersection point between a triangle edge and a clipping plane

function pt_intersection = clip_solve_plane_edge_intersection(pt_1, pt_2, pt_p, n)
  d1 = dot(n, (pt_1 - pt_p))
  d2 = dot(n, (pt_2 - pt_p))
  t =  d1 / (d1-d2)
  pt_intersection = pt_1 + t*(pt_2 - pt_1)
  return
endfunction
