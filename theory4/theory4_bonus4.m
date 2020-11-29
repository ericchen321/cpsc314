# THEORY 4 BONUS 4
# data
pos_camera=[-44.1182, 30.7795, 0]
ray=[0.642788, -0.766044, 0]
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
n_xenon = 1.00068947
n_glycerol = 1.4631

# 1a
# get position and normal of 1st intersection
pos_intersect_1st = ray_trace_solve_intersection_line(pos_camera, pos_v1, pos_v2, ray)
normal_intersect_1st = lin_interp_interpolate_line(pos_intersect_1st, pos_v1, pos_v2, normal_v1, normal_v2, 1)

# 1b
# refraction at v1-v2
n_i = n_xenon;
n_t = n_glycerol;
refractRecord_1st = refract_solve_refract_ray(n_i, n_t, ray, normal_intersect_1st)
ray_refract_1st = refractRecord_1st(1,:)
incident_angle_refract_1st = refractRecord_1st(2,1)
refract_angle_refract_1st = refractRecord_1st(3,1)

# try v3-v4
pos_intersect_2nd = ray_trace_solve_intersection_line(pos_intersect_1st, pos_v3, pos_v4, ray_refract_1st)
normal_intersect_2nd = lin_interp_interpolate_line(pos_intersect_2nd, pos_v3, pos_v4, normal_v3, normal_v4, 1)
# refraction at v3-v4
n_i = n_glycerol;
n_t = n_xenon;
refractRecord_2nd = refract_solve_refract_ray(n_i, n_t, ray_refract_1st, -1.0*normal_intersect_2nd)
ray_refract_2nd = refractRecord_2nd(1,:)
incident_angle_refract_2nd = refractRecord_2nd(2,1)
refract_angle_refract_2nd = refractRecord_2nd(3,1)

# 1c
# compute instersection and color at p1-p2
pos_intersect_final = ray_trace_solve_intersection_line(pos_intersect_2nd, pos_p1, pos_p2, ray_refract_2nd)
color_intersect_final = lin_interp_interpolate_line(pos_intersect_final, pos_p1, pos_p2, color_p1, color_p2, 0)