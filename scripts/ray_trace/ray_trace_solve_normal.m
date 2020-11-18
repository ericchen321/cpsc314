# solve for the normal at point of intersection, given intersection point 
# and center of sphere
# pos_intersect: position of intersection point
# pos_sphere: position of sphere
# returns unitary normal vector

function normal = ray_trace_solve_normal (pos_intersect, pos_sphere)
  normal = (pos_intersect - pos_sphere) / norm(pos_intersect - pos_sphere);
  return;
endfunction
