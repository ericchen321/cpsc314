# solve for the intersection between a ray and a torus using
# ray marching.
# pos_camera: ray origin
# ray: ray vector, should be unitary
# dist_epsilon: max distance to be considered as intersection
# pos_cen: position of center of torus
# normal: normal of torus
# r1, r2: Radius r1, r2 of torus
# return [position of intersection; surface normal] if the intersection exists;
# return [zero; zero] otherwise

function retVal = ray_trace_solve_intersection_torus (pos_camera, ray, dist_epsilon, pos_cen, normal, r1, r2)
  # compute max marchable distance
  dist_max = utils_solve_distance(pos_camera, pos_cen) + r1 + r2
  
  # recursively march ray
  retVal = march_ray(pos_camera, utils_normalize(ray), dist_epsilon, 0, dist_max, pos_cen, normal, r1, r2);
  return;
endfunction

# helper function to do ray marching
function retVal = march_ray(pos_camera, ray, dist_epsilon, dist_traversed, dist_max, pos_cen, normal, r1, r2)
  # computes distance and new camera position
  k = dot((pos_camera-pos_cen), normal);
  pos_p = pos_camera-k*normal
  M = utils_normalize(pos_p - pos_cen)
  pos_m = pos_cen + r1 * M
  dist_to_closest = utils_solve_distance(pos_m, pos_camera) - r2
  pos_camera_new = pos_camera + dist_to_closest*ray
  
  # base case: dist_traversed>=dist_max or dist_to_closest<=dist_epsilon
  if (dist_traversed>=dist_max || dist_to_closest<=dist_epsilon)
    if (dist_traversed>=dist_max)
      printf("no intersection with torus!\n");
      retVal = [[0 0 0]; [0 0 0]];
      return;
    else
      pos_intersect = pos_camera_new;
      k1 = dot((pos_intersect-pos_cen), normal);
      pos_p1 = pos_intersect - k1*normal;
      M1 = utils_normalize(pos_p1 - pos_cen);
      pos_m1 = pos_cen + r1 * M1;
      surf_normal = utils_normalize(pos_intersect - pos_m1);
      retVal = [pos_intersect; surf_normal]
      return;
    endif
  # recursive case: dist_traversed<dist_max and dist_to_closest>dist_epsilon
  else
    retVal = march_ray(pos_camera_new, ray, dist_epsilon, dist_traversed+dist_to_closest, dist_max, pos_cen, normal, r1, r2)
  endif
endfunction