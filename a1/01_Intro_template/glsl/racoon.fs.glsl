// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
varying vec3 interpolatedNormal;
/* HINT: YOU WILL NEED A DIFFERENT SHARED VARIABLE TO COLOR ACCORDING TO POSITION */
varying float interpolatedDist;

uniform float timeElapsed;
uniform int rcState;
uniform vec3 rcState1_color;
uniform vec3 rcState2_color;
uniform vec3 rcState3_color;

#define PI 3.1416
#define SCALE 7.0
#define PERIOD 2.0 // period for sinusoidal scaling

void main() {
  // Set final rendered color according to the surface normal
  float threshold = 2.8;

  if (interpolatedDist < threshold) {
    if (rcState == 1) {
    	gl_FragColor = vec4(normalize(rcState1_color), 0.6);
	  }
    else if (rcState == 2) {
      gl_FragColor = vec4(normalize(rcState2_color), 0.6);
    }
    else {
      gl_FragColor = vec4(normalize(rcState3_color), 0.6);
    }
  }
  else {
    float r_factor = cos(2.0*PI*(1.0/PERIOD)*timeElapsed);
    float g_factor = sin(2.0*PI*(1.0/PERIOD)*timeElapsed);
    float b_factor = g_factor;
    vec3 color_vec = vec3(interpolatedNormal.x*r_factor, interpolatedNormal.y*g_factor, interpolatedNormal.z*b_factor);
    gl_FragColor = vec4(normalize(color_vec), 1.0);
  }

  //gl_FragColor = vec4(normalize(interpolatedNormal), 1.0); // REPLACE ME
}
