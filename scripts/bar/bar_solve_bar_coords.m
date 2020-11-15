# solves barycentric coordinates alpha, beta and gamma
# from pt coordinates a, b, c, p;
# returns barycentric coordinates as a row vector
# requires 3-vectors as inputs

function bar_values = bar_solve_bar_coords (a, b, c, p)
  ab = b-a;
  ac = c-a;
  pb = b-p;
  pa = a-p;
  pc = c-p;
  
  At = 0.5*norm(cross(ab, ac));
  Aa = 0.5*norm(cross(pb, pc));
  Ab = 0.5*norm(cross(pa, pc));
  Ac = 0.5*norm(cross(pa, pb));
  
  alpha = Aa/At;
  beta = Ab/At;
  gama = Ac/At;
  bar_values = [alpha beta gama];
  if (sum(bar_values)<(1.0-0.05) || sum(bar_values)>(1.0+0.05))
    printf("sum of barycentric coordinates is: %f\n", sum(bar_values));
    error("point is outside the given triangle!");
  endif
  return;
endfunction
