# given four control points, compute the new position on the cubic curve,
# and the positions of the three fictifious points
# cp1, cp2, cp3, cp4: positions of control points
# step: the step of the new position, should be an integer
# totalStep: total number of steps to complete the curve
# returns a matrix of the form [new_pos; fict_1; fict_2; fict_3]

function retVal = bezier_solve_pos_cubic (cp1, cp2, cp3, cp4, step, totalSteps)
  # compute the first three arms
  v1 = cp2 - cp1;
  v2 = cp3 - cp2;
  v3 = cp4 - cp3;
  scaleFactor = step/totalSteps;
  
  # compute the fictifious points and the fourth arm;
  # this allows us to formulate a quadratic curve problem
  fict_1 = cp1 + scaleFactor*v1;
  fict_2 = cp2 + scaleFactor*v2;
  fict_3 = cp3 + scaleFactor*v3;
  
  # compute the new pos
  new_pos = bezier_solve_pos_quadratic(fict_1, fict_2, fict_3, step, totalSteps)(1, :);
  
  # pack up stuff in retVal
  retVal = [new_pos; fict_1; fict_2; fict_3]
  
  return;
endfunction
