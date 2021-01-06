# solve for the transformation matrix from VCS to WCS, given position of
# the target and the camera in the world frame.
# pos_cam: camera position in world frame
# pos_target: target position in world frame
# upVec: the up vector

function VCS2WCSMat = xform_solve_xform_matrix_VCS2WCS (pos_cam, pos_target, upVec)
  w = utils_normalize(pos_cam - pos_target)
  u = cross(utils_normalize(upVec), w)
  v = cross(w, u)
  VCS2WCSMat = [[u' v' w' pos_cam'];[0 0 0 1]];
  return;
endfunction
