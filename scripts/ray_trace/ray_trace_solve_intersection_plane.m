# solve for intersection between a ray and a plane;
# pos_p: position of an arbitrary point on plane
# pos_camera: position where the ray originates
# normal: normal of the plane
# ray: ray vector, need to be unitary
# returns position of intersection

function pos_intersect = ray_trace_solve_intersection_plane (pos_p, pos_camera, normal, ray)
  # check if the ray vector has been normalized
  if (utils_check_equal(norm(ray), 1.0, 0.01) != 1)
    error("the ray vector is not unitary!");
  endif
  
  # get a
  w = pos_p - pos_camera;
  a = dot(w, normal)
  
  # get b
  b = dot(ray, normal)
  
  # get k
  k = a/b;
  if (utils_check_equal(b, 0.0, 0.01))
    error("seems like the ray is parallel to the plane!");
  elseif (k<0)
    error("the plane is behind the ray!");
  elseif (utils_check_equal(k, 0.0, 0.01))
    error("the camera lies on the plane!");
  endif
  
  # get pos_intersect
  pos_intersect = pos_camera + k*ray;
  return;
endfunction
