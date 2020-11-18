# plot triangle to be clipped in the NDC cube;
# note that the NDC cube shown is right-handed

function retval = clip_plot_triangle_in_ndc (pos_a, pos_b, pos_c)
  # NDC cube vertex definitions
  pt_1 = [-1 1 1];
  pt_2 = [1 1 1];
  pt_3 = [1 1 -1];
  pt_4 = [-1 1 -1];
  pt_5 = [-1 -1 1];
  pt_6 = [1 -1 1];
  pt_7 = [1 -1 -1];
  pt_8 = [-1 -1 -1];
  
  # draw line segments that define the NDC cube
  # line 12
  plot_line_segment(pt_1, pt_2);
  hold on;
  # line 23
  plot_line_segment(pt_2, pt_3);
  hold on;
  # line 34
  plot_line_segment(pt_3, pt_4);
  hold on;
  # line 41
  plot_line_segment(pt_4, pt_1);
  hold on;
  # line 26
  plot_line_segment(pt_2, pt_6);
  hold on;
  # line 37
  plot_line_segment(pt_3, pt_7);
  hold on;
  # line 48
  plot_line_segment(pt_4, pt_8);
  hold on;
  # line 15
  plot_line_segment(pt_1, pt_5);
  hold on;
  # line 56
  plot_line_segment(pt_5, pt_6);
  hold on;
  # line 67
  plot_line_segment(pt_6, pt_7);
  hold on;
  # line 78
  plot_line_segment(pt_7, pt_8);
  hold on;
  # line 85
  plot_line_segment(pt_8, pt_5);
  hold on;
  text(0, 0, -1, 'near', 'FontSize',24);
  text(0, 0, 1, 'far', 'FontSize',24);
  text(0, 1, 0, 'top', 'FontSize',24);
  text(0, -1, 0, 'bottom', 'FontSize',24);
  text(1, 0, 0, 'right', 'FontSize',24);
  text(-1, 0, 0, 'left', 'FontSize',24);
  
  # draw the triangle
  plot_line_segment(pos_a, pos_b);
  hold on;
  plot_line_segment(pos_b, pos_c);
  hold on;
  plot_line_segment(pos_c, pos_a);
  hold on;
  text(pos_a(1), pos_a(2), pos_a(3), 'a', 'FontSize',24);
  text(pos_b(1), pos_b(2), pos_b(3), 'b', 'FontSize',24);
  text(pos_c(1), pos_c(2), pos_c(3), 'c', 'FontSize',24);
  
  # label axis
  xlabel('x');
  ylabel('y');
  zlabel('z');
  
  # turn on 3D rotation
  rotate3d on;
  return;
endfunction

function plot_line_segment(pt_a, pt_b)
  vectorx=[pt_a(1) pt_b(1)];
  vectory=[pt_a(2) pt_b(2)];
  vectorz=[pt_a(3) pt_b(3)];
  plot3(vectorx,vectory,vectorz);
  return;
 endfunction
