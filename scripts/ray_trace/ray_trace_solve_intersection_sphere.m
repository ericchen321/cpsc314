# solve for intersection between a ray and a sphere
# requires normalized ray vector
# returns [position of intersection; normal at intersection]

function retVal = ray_trace_solve_intersection_sphere (pos_camera, pos_sphere, radius_sphere, ray)
  # check if the ray vector has been normalized
  if (utils_check_equal(norm(ray), 1.0, 0.01) != 1)
    error("the ray vector is not unitary!");
  endif
  
  # get theta
  v1 = pos_sphere - pos_camera;
  v1_normalized = utils_normalize(v1);
  theta = acos(dot(ray, v1_normalized));
  
  # get d
  d = norm(v1) * sin(theta);
  
  # get a
  if (d > radius_sphere)
    error("d > radius, ray does not intersect the sphere!");
  endif
  a = sqrt(radius_sphere^2 - d^2);
  
  # get b
  b = norm(v1) * cos(theta) - a;
  
  # get pos_intersect
  pos_intersect = pos_camera + b*ray;
  
  # get normal
  normal = (pos_intersect - pos_sphere) / norm(pos_intersect - pos_sphere);
  
  retVal = [pos_intersect; normal]
  return;
endfunction
