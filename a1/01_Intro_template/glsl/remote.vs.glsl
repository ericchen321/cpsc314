// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 remotePosition;

void main() {
	/* HINT: WORK WITH remotePosition HERE! */
    vec3 pos_delta = vec3(remotePosition.x-0.0, remotePosition.y-5.0, remotePosition.z-3.0);
    vec3 pos_translated = position + pos_delta;

    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos_translated, 1.0);
}
