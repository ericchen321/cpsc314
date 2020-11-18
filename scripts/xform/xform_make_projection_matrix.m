# create a projection matrix with near, far, top, bottom, right, left
# plane values in the camera frame. This matrix does VCS -> NDC transformation

function projMat = xform_make_projection_matrix (n, f, t, b, r, l)
  # check if plane values make sense
  if (n<=f)
    error("near/far plane error!");
  elseif (t<=b)
    error("top/bottom plane error!");
  elseif (r<=l)
    error("right/left plane error!");
  endif
  
  # compose the matrix
  projMat_1 = [2*n/(r-l) 0 (r+l)/(r-l) 0];
  projMat_2 = [0 2*n/(t-b) (t+b)/(t-b) 0];
  projMat_3 = [0 0 -1*(f+n)/(f-n) -2.0*f*n/(f-n)];
  projMat_4 = [0 0 -1 0];
  projMat = [projMat_1; projMat_2; projMat_3; projMat_4];
  return;
endfunction
