// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 remotePosition;

void main() {
	/* HINT: WORK WITH remotePosition HERE! */
    vec3 pos_delta = vec3(remotePosition.x, remotePosition.y, remotePosition.z);
    vec3 pos_translated = position + pos_delta;

    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos_translated, 1.0);
}
