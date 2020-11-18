# checks if the given value is within the range of [check_val-epsilon, check_val+epsilon]
# given_val: value for comparision
# check_val: value to be compared against
# epsilon: half of error range
# returns true if equal, false if not

function retval = utils_check_equal (given_val, check_val, epsilon)
  retval = false;
  if(given_val >= check_val-epsilon && given_val<=check_val+epsilon)
    retval = true;
  endif
  return;
endfunction
