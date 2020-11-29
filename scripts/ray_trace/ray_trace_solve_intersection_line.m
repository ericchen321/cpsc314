# solve for intersection between a ray and a line segment on x-y plane. This 
# requires the input vectors to have 0 for their z coordinates.
# pos_camera: position where the ray originates
# pos_pt1: position of the 1st point that defines the line
# pos_pt2: position of the 2nd point that defines the line
# ray: ray vector, need to be unitary
# returns position of intersection

function pos_intersect = ray_trace_solve_intersection_line (pos_camera, pos_pt1, pos_pt2, ray)
  # check if the ray vector has been normalized
  if (utils_check_equal(norm(ray), 1.0, 0.01) != 1)
    error("the ray vector is not unitary!");
  endif
  # check if the input vectors are on the x-y plane
  if (utils_check_equal(pos_camera(3), 0.0, 0.001) != 1 || utils_check_equal(pos_pt1(3), 0.0, 0.001) != 1 || utils_check_equal(pos_pt2(3), 0.0, 0.001) != 1)
    error("not everything is on the x-y plane!");
  endif
  
  # check if ray is parallel to the line
  dot_prod = dot(ray, utils_normalize(pos_pt2-pos_pt1));
  if (utils_check_equal(norm(dot_prod), 1.0, 0.01) == 1)
    error("the ray is parallel to the line!");
  endif
  
  # calculation intersection point of two lines
  # method from https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
  x1 = pos_camera(1);
  y1 = pos_camera(2);
  x2 = pos_camera(1)+ray(1);
  y2 = pos_camera(2)+ray(2);
  x3 = pos_pt1(1);
  y3 = pos_pt1(2);
  x4 = pos_pt2(1);
  y4 = pos_pt2(2);
  mat_nomi = [(x1-x3) (x3-x4);(y1-y3) (y3-y4)];
  mat_deno = [(x1-x2) (x3-x4);(y1-y2) (y3-y4)];
  t = det(mat_nomi) / det(mat_deno);
  
  # check if line is behind the ray
  if (t<0.0)
    error("the line is behind the ray!");
  endif
  
  pos_intersect = pos_camera + t*ray;
  
  # check if the intersection is on the segment
  sum_dists = utils_solve_distance(pos_intersect, pos_pt1) + utils_solve_distance(pos_intersect, pos_pt2);
  segLength = utils_solve_distance(pos_pt1, pos_pt2);
  if (utils_check_equal(sum_dists, segLength, 0.05) != 1)
    pos_intersect
    error("the intersection is not between the two points!");
  endif
  return;
endfunction
