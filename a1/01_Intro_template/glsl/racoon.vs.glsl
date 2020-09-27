// Create shared variable for the vertex and fragment shaders
varying vec3 interpolatedNormal;
/* HINT: YOU WILL NEED A DIFFERENT SHARED VARIABLE TO COLOR ACCORDING TO POSITION */
varying float interpolatedDist;

uniform vec3 remotePosition;

void main() {
    // Set shared variable to vertex normal
    interpolatedNormal = normal;

    // Make paws same scale as the remote orb
    float scale = 4.0;
    mat4 scaleMatrix = modelMatrix;
    scaleMatrix[0][0] = scale;
    scaleMatrix[1][1] = scale;
    scaleMatrix[2][2] = scale;

    // Compute position in world frame
    vec4 position_world = scaleMatrix * vec4(position, 1.0);

    // Compute distance from vertex to remote's centre
    interpolatedDist = distance(position_world, vec4(remotePosition, 1.0));

    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * modelViewMatrix * position_world;
}
