# solves for the handles of cubic bezier curve defined by p0, p1, p2
# returns coordinates of handle l1, l2, r1, r2; in the matrix returned,
# each row is a handle

function handles = bezier_solve_cubic_handles (p0, p1, p2)
  C = p1 - p0;
  D = C / 3.0;
  E = p2 - p1;
  F = E / 3.0;
  l2r1 = (p2-p0) / 3.0;
  l2p1 = l2r1 / 2.0;
  p1r1 = l2r1 / 2.0;
  l2 = p1 - l2p1;
  l1 = l2 - D;
  r1 = p1 + p1r1;
  r2 = r1 + F;
  handles = [l1; l2; r1; r2]
  return;
endfunction
