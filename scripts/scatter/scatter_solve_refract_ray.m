# solve for refraction ray, given IoRs, incident ray vector,
# normal vector of incident surface.
# n_i: IoR of incident material
# n_t: IoR of transmission material
# ray_i: the ray vector. Should be 1) unitary and 2) from light
#        position to the incident position
# normal: normal vector of the surface of incidence
# returns a matrix of the form:
#         [the refraction ray; angle_of_incidence 0 0; angle_of_refraction 0 0];
#         the angles are in degrees
# returns 1) the zero matrix for wrong inputs or blocked incident ray
#         2) [zero vector; angle_of_incidence; zero vector] for total reflection

function retVal = scatter_solve_refract_ray (n_i, n_t, ray_i, normal)
  # check if the ray vector has been normalized
  if (utils_check_equal(norm(ray_i), 1.0, 0.01) != 1)
    error("the ray vector is not unitary!");
  endif
  # check if the normal vector has been normalized
  if (utils_check_equal(norm(normal), 1.0, 0.01) != 1)
    error("the normal is not unitary!");
  endif
  
  # initialize retVal
  retVal = zeros(3, 3);
  ray_t = [0 0 0];
  angle_i = 0.0;
  angle_t = 0.0;
  
  ray_i_invert = -1.0 * ray_i;
  # if incident ray is occluded, return zero
  cos_theta_i = dot(ray_i_invert, normal)
  angle_i = utils_rad2deg(acos(cos_theta_i));
  if (cos_theta_i < 0.0)
    printf("incident ray blocked! Incident angle is %f\n", angle_i);
    printf("proceed to compute refraction, since we may still want it!\n");
  endif
  
  sin_theta_i = norm(cross(ray_i_invert, normal));
  sin_theta_t = (n_i / n_t) * sin_theta_i;
  
  # if total reflection, return zero
  if (sin_theta_t > 1.0)
    retVal = [ray_t; angle_i 0 0; angle_t 0 0];
    printf("total reflection!\n");
    return;
  endif
  
  # the refraction ray is on the plane of refraction
  # procedure to calculate the ray from https://graphics.stanford.edu/courses/cs148-10-summer/docs/2006--degreve--reflection_refraction.pdf
  ray_t = (n_i/n_t)*ray_i + ((n_i/n_t)*cos_theta_i-sqrt(1-sin_theta_t^2))*normal;
  ray_t = utils_normalize(ray_t);
  
  angle_t = utils_rad2deg(asin(sin_theta_t));
  retVal = [ray_t; angle_i 0 0; angle_t 0 0];
  return;
endfunction
