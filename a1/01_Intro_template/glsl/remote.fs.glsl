uniform int rcState;
uniform vec3 rcState1_color;
uniform vec3 rcState2_color;
uniform vec3 rcState3_color;

uniform float timeElapsed;

#define PI 3.1416
#define SCALE 7.0
#define PERIOD 2.0 // period for sinusoidal scaling

void main() {
	// HINT: WORK WITH rcState HERE

	//Paint it red
	if (rcState == 1) {
    	gl_FragColor = vec4(normalize(rcState1_color), 1.0);
	}
	else if (rcState == 2) {
		gl_FragColor = vec4(normalize(rcState2_color), 1.0);
	}
	else {
		gl_FragColor = vec4(normalize(rcState3_color), 1.0);
	}

    //gl_FragColor = vec4(1, 0, 0, 1);


}