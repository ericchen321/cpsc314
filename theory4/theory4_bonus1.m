# THEORY 4 BONUS 1
# data
pos_camera=[-60 40 0]
ray=[0.939693,-0.34202,0]
pos_v1=[-40 0 0]
pos_v2=[0 40 0]
pos_v3=[40 0 0]
pos_v4=[0 -40 0]
normal_v1=[cos(utils_deg2rad(135)) sin(utils_deg2rad(135)) 0]
normal_v2=[0 1 0]
normal_v3=[cos(utils_deg2rad(315)) sin(utils_deg2rad(315)) 0]
normal_v4=[0 -1 0]
pos_p1 = [90 -70 0]
pos_p2 = [90 30 0]
color_p1 = [0 255 0]
color_p2 = [0 0 255]

# 1a
# get position and normal of 1st intersection
pos_intersect_1st = ray_trace_solve_intersection_line(pos_camera, pos_v1, pos_v2, ray)
normal_intersect_1st = lin_interp_interpolate_line(pos_intersect_1st, pos_v1, pos_v2, normal_v1, normal_v2, 1)

# 1b
# refraction at v1-v2
n_i = 1.0;
n_t = 1.5;
refractRecord_1st = refract_solve_refract_ray(n_i, n_t, ray, normal_intersect_1st)
ray_refract_1st = refractRecord_1st(1,:)
incident_angle_refract_1st = refractRecord_1st(2,1)
refract_angle_refract_1st = refractRecord_1st(3,1)

# try intersection at v2-v3
try
  pos_intersect_2nd = ray_trace_solve_intersection_line(pos_intersect_1st, pos_v2, pos_v3, ray_refract_1st)
  normal_intersect_2nd = lin_interp_interpolate_line(pos_intersect_2nd, pos_v2, pos_v3, normal_v2, normal_v3, 1)
  # refraction at v2-v3
  n_i = 1.5;
  n_t = 1.0;
  refractRecord_2nd = refract_solve_refract_ray(n_i, n_t, ray_refract_1st, -1.0*normal_intersect_2nd)
  ray_refract_2nd = refractRecord_2nd(1,:)
  incident_angle_refract_2nd = refractRecord_2nd(2,1)
  refract_angle_refract_2nd = refractRecord_2nd(3,1)
catch
  printf("1st refraction ray does not intersect v2-v3!\n");
end_try_catch

# v2-v3 doesn't work. try v3-v4
pos_intersect_2nd = ray_trace_solve_intersection_line(pos_intersect_1st, pos_v3, pos_v4, ray_refract_1st)
normal_intersect_2nd = lin_interp_interpolate_line(pos_intersect_2nd, pos_v3, pos_v4, normal_v3, normal_v4, 1)
# refraction at v3-v4
n_i = 1.5;
n_t = 1.0;
refractRecord_2nd = refract_solve_refract_ray(n_i, n_t, ray_refract_1st, -1.0*normal_intersect_2nd)
ray_refract_2nd = refractRecord_2nd(1,:)
incident_angle_refract_2nd = refractRecord_2nd(2,1)
refract_angle_refract_2nd = refractRecord_2nd(3,1)

# 1c
# compute instersection and color at p1-p2
pos_intersect_final = ray_trace_solve_intersection_line(pos_intersect_2nd, pos_p1, pos_p2, ray_refract_2nd)
color_intersect_final = lin_interp_interpolate_line(pos_intersect_final, pos_p1, pos_p2, color_p1, color_p2, 0)