// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
varying vec3 interpolatedNormal;
/* HINT: YOU WILL NEED A DIFFERENT SHARED VARIABLE TO COLOR ACCORDING TO POSITION */
varying float interpolatedDist;

void main() {
  // Set final rendered color according to the surface normal
  float threshold = 5.0;
  /*
  if (interpolatedDist < threshold) {
    gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
  }
  else {
    gl_FragColor = vec4(normalize(interpolatedNormal), 1.0);
  }
  */
  gl_FragColor = vec4(normalize(interpolatedNormal), 1.0); // REPLACE ME
}
