varying vec4 V_Normal_VCS;
varying vec4 V_ViewPosition;

void main() {

	// ADJUST THESE VARIABLES TO PASS PROPER DATA TO THE FRAGMENTS
	// compute normal in camera frame
	V_Normal_VCS = vec4(normalMatrix * normal, 0.0);
	// compute vertex position in camera frame
	V_ViewPosition = modelViewMatrix * vec4(position, 1.0);

	gl_Position = projectionMatrix *  modelViewMatrix * vec4(position, 1.0);
}