# solve for the two intersections between a ray and a box on a 2D plane.
# useful for accelerated ray tracing.
# pos_camera: origin of ray
# ray: direction of ray, need to be unitary
# pos_min: position of lower-left corner of the cube
# pos_max: position of upper-right corner of the cube
# if the intersections exist, return [pos_intersec_min; pos_intersec_max];
# if they do not exist, return [zero; zero]

function pos_intersections = ray_trace_solve_intersection_box2D (pos_camera, ray, pos_min, pos_max)
  # check if the ray vector has been normalized
  if (utils_check_equal(norm(ray), 1.0, 0.01) != 1)
    error("the ray vector is not unitary!");
  endif
  # check if the input vectors are on the x-y plane
  if ((numel(pos_camera)==3 && utils_check_equal(pos_camera(3), 0.0, 0.001) != 1) || 
    (numel(pos_min)==3 && utils_check_equal(pos_min(3), 0.0, 0.001) != 1) || 
    (numel(pos_max)==3 && utils_check_equal(pos_max(3), 0.0, 0.001) != 1))
    error("not everything is on the x-y plane!");
  endif
  
  #initialize intersections
  pos_intersections = [[0 0];[0 0]];
  
  # compute x and y interval
  R = pos_camera;
  RPrime = pos_camera + 500 * ray;  
  # compute x interval
  # x min
  a = pos_min(1) - R(1);
  k = a/(RPrime(1)-R(1));
  I_x_min = k * (RPrime-R) + R
  # x max
  a = pos_max(1) - R(1);
  k = a/(RPrime(1)-R(1));
  I_x_max = k * (RPrime-R) + R
  # compute y interval
  # y min
  a = pos_min(2) - R(2);
  k = a/(RPrime(2)-R(2));
  I_y_min = k * (RPrime-R) + R
  # y max
  a = pos_max(2) - R(2);
  k = a/(RPrime(2)-R(2));
  I_y_max = k * (RPrime-R) + R
  
  # check if the intervals overlap (using x coordinates)
  xInterval_min = I_x_min(1);
  xInterval_max = I_x_max(1);
  yInterval_min = I_y_min(1);
  yInterval_max = I_y_max(1);
  if ((xInterval_min>=yInterval_min && xInterval_min<=yInterval_max) ||
      (xInterval_max>=yInterval_min && xInterval_max<=yInterval_max) ||
      (yInterval_min>=xInterval_min && yInterval_min<=xInterval_max) ||
      (yInterval_max>=xInterval_min && yInterval_max<=xInterval_max))
    printf("intersect!\n");
  else
    printf("does not intersect!\n");
    return;
  endif
  
  # compute the intersections
  num_intersections_found = 0;
  if (I_y_min(1)>=pos_min(1) && I_y_min(1)<=pos_max(1))
    pos_intersections(num_intersections_found+1,:) = I_y_min;
    num_intersections_found = num_intersections_found+1;
  endif
  if (I_y_max(1)>=pos_min(1) && I_y_max(1)<=pos_max(1))
    pos_intersections(num_intersections_found+1,:) = I_y_max;
    num_intersections_found = num_intersections_found+1;
  endif
  if (I_x_min(2)>=pos_min(2) && I_x_min(2)<=pos_max(2))
    pos_intersections(num_intersections_found+1,:) = I_x_min;
    num_intersections_found = num_intersections_found+1;
  endif
  if (I_x_max(2)>=pos_min(2) && I_x_max(2)<=pos_max(2))
    pos_intersections(num_intersections_found+1,:) = I_x_max;
    num_intersections_found = num_intersections_found+1;
  endif
  return;  
endfunction
