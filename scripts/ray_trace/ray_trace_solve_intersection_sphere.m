# solve for intersection between a ray and a sphere
# requires normalized ray vector
# returns position of intersection

function pos_intersect = ray_trace_solve_intersection_sphere (pos_camera, pos_sphere, radius_sphere, ray)
  # get theta
  v1 = pos_sphere - pos_camera;
  v1_normalized = v1 / norm(v1);
  theta = acos(dot(ray, v1_normalized));
  
  # get d
  d = norm(v1) * sin(theta)
  
  # get a
  if (d > radius_sphere)
    error("d > radius, ray does not intersect the sphere!");
  endif
  a = sqrt(radius_sphere^2 - d^2);
  
  # get b
  b = norm(v1) * cos(theta) - a;
  
  # get pos_intersect
  pos_intersect = pos_camera + b*ray;
  return;
endfunction
