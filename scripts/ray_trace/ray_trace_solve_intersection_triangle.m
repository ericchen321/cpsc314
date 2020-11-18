# solve for intersection between a ray and a triangle
# pos_pt1, pos_pt2, pos_pt3: position of the three points that define
# the triangle
# pos_camera: position where the ray originates
# ray: ray vector, need to be unitary
# requires all inputs being three-vectors
# returns position of intersection and barycentric coordinates
# in a matrix of the form [pos_intersect; bar_values]

function retVal = ray_trace_solve_intersection_triangle (pos_pt1, pos_pt2, pos_pt3, pos_camera, ray)
  # take pos_pt1 as pos_p for ray-plane intersection calculation;
  # compute the triangle's normal
  perp = cross((pos_pt2 - pos_pt1), (pos_pt3 - pos_pt1))
  normal = perp / norm(perp)
  
  # compute position of intersection btw ray and plane
  pos_intersect = ray_trace_solve_intersection_plane(pos_pt1, pos_camera, normal, ray)
  
  # check if the intersection pt is inside the triangle
  # gets an error if the pt is not in the triangle
  bar_values = bar_solve_bar_coords(pos_pt1, pos_pt2, pos_pt3, pos_intersect);
  
  # returns intersection and barycentric coords
  retVal = [pos_intersect; bar_values];
  return;
endfunction
