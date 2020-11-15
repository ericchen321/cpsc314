# solve for intersection between a ray and a plane
# pos_p: position of an arbitrary point on plane
# pos_camera: position where the ray originates
# normal: normal of the plane
# ray: ray vector, need to be unitary
# returns position of intersection

function pos_intersect = ray_trace_solve_intersection_plane (pos_p, pos_camera, normal, ray)
  # get a
  w = pos_p - pos_camera;
  a = dot(w, normal)
  
  # get b
  b = dot(ray, normal)
  
  # get k; here we assume we should get a k no more than 10000
  k = a/b
  if (b<=0.0001*a)
    error("seems like the ray is parallel to the plane!");
  elseif (k<0)
    error("the plane is behind the ray!");
  endif
  
  # get pos_intersect
  pos_intersect = pos_camera + k*ray;
  return;
endfunction
