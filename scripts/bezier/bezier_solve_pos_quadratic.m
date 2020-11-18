# given three control points, compute the new position on the quadratic curve,
# and the positions of the two fictifious points
# cp1, cp2, cp3: positions of control points
# step: the step of the new position, should be an integer
# totalStep: total number of steps to complete the curve
# returns a matrix of the form [new_pos; fict_1; fict_2]

function retVal = bezier_solve_pos_quadratic (cp1, cp2, cp3, step, totalSteps)
  # compute the first two arms
  v1 = cp2 - cp1;
  v2 = cp3 - cp2;
  scaleFactor = step/totalSteps;
  
  # compute the fictifious points and the third arm
  fict_1 = cp1 + scaleFactor*v1;
  fict_2 = cp2 + scaleFactor*v2;
  v3 = fict_2 - fict_1;
  
  # compute the new pos
  new_pos = fict_1 + scaleFactor*v3;
  
  # pack up stuff in retVal
  retVal = [new_pos; fict_1; fict_2];
  
  return;
endfunction
