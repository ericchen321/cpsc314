# solves barycentric coordinates alpha, beta and gamma
# requires 3-vectors as inputs
function bar_values = solve_bar (a, b, c, p)
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
  bar_values = [alpha; beta; gama];
  return;
endfunction
