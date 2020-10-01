// Create shared variable for the vertex and fragment shaders
varying vec3 interpolatedNormal;
/* HINT: YOU WILL NEED A DIFFERENT SHARED VARIABLE TO COLOR ACCORDING TO POSITION */
varying float interpolatedDist;

uniform float distObjToFloor;
uniform vec3 remotePosition;
uniform float timeElapsed;

#define PI 3.1416
#define SCALE 7.0
#define PERIOD 2.0 // period for sinusoidal scaling

void main() {
    // Set shared variable to vertex normal
    interpolatedNormal = normal;

    // Make paws same scale as the remote orb; also scale sinusoidally
    mat4 scaleMatrix = mat4(1.0);
    scaleMatrix[0][0] = SCALE * abs(cos(2.0*PI*(1.0/PERIOD)*timeElapsed));
    scaleMatrix[1][1] = SCALE * abs(cos(2.0*PI*(1.0/PERIOD)*timeElapsed));
    scaleMatrix[2][2] = SCALE * abs(cos(2.0*PI*(1.0/PERIOD)*timeElapsed));

    // Compute position in world frame
    vec4 position_world_untranslated = modelMatrix * scaleMatrix * vec4(position, 1.0);
    vec4 position_world = vec4(position_world_untranslated.x, position_world_untranslated.y-distObjToFloor, position_world_untranslated.z, 1.0);

    // Compute distance from vertex to remote's centre
    interpolatedDist = distance(position_world, vec4(remotePosition, 1.0));

    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * viewMatrix * position_world;
}