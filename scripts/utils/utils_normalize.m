# normalizes a given vector
# returns the normalized vector

function retVec = utils_normalize (vec)
  retVec = vec / norm(vec);
  return;
endfunction
