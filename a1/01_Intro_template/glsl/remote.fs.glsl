uniform int rcState;


void main() {
	// HINT: WORK WITH rcState HERE

	//Paint it red
	if (rcState == 1) {
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else if (rcState == 2) {
		gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
	}
	else {
		gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
	}

    //gl_FragColor = vec4(1, 0, 0, 1);


}