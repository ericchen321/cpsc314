# solve for reflection ray, incident ray vector,
# normal vector of incident surface.
# ray_i: the ray vector. Should be 1) unitary and 2) from light
#        position to the incident position
# normal: normal vector of the surface of incidence
# returns a matrix of the form if reflection happens:
#         [the reflection ray; angle of incidence and reflection];
#         the angle is in degrees.
# returns the zero matrix for wrong inputs or blocked incident ray

function retVal = scatter_solve_reflect_ray (ray_i, normal)
  # check if the ray vector has been normalized
  if (utils_check_equal(norm(ray_i), 1.0, 0.01) != 1)
    error("the ray vector is not unitary!");
  endif
  # check if the normal vector has been normalized
  if (utils_check_equal(norm(normal), 1.0, 0.01) != 1)
    error("the normal is not unitary!");
  endif
  
  # initialize retVal
  retVal = zeros(2, 3);
  
  ray_i_invert = -1.0 * ray_i;
  # if incident ray is occluded, return zero
  cos_theta_i = dot(ray_i_invert, normal);
  angle_i = utils_rad2deg(acos(cos_theta_i));
  if (cos_theta_i < 0.0)
    printf("incident ray blocked! Incident angle is %f\n", angle_i);
    retVal = [0 0 0; angle_i 0 0];
    return;
  endif
  
  # compute reflection ray
  ray_t = 2*dot(normal, ray_i_invert)*normal - ray_i_invert;
  retVal = [ray_t; angle_i 0 0];
  return;
endfunction
