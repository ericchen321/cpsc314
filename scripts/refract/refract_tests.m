# tests for refract_solve_refract_ray
source("../utils/utils_normalize.m")
source("../utils/utils_deg2rad.m")
source("../utils/utils_rad2deg.m")
source("refract_solve_refract_ray.m")

# refraction happens
angle_i = utils_deg2rad(45);
ray_i = [cos(angle_i) -1.0*sin(angle_i) 0];
ray_t = refract_solve_refract_ray(1.00, 1.33, ray_i, [0 1 0])
norm(ray_t)
angle_t = utils_rad2deg(acos(dot([0 -1 0], ray_t)))

# total reflection
angle_i = utils_deg2rad(0.5)
ray_i = [cos(angle_i) -1.0*sin(angle_i) 0];
ray_t = refract_solve_refract_ray(1.33, 1.00, ray_i, [0 1 0])
norm(ray_t) # should be 0

