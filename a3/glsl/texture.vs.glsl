
varying vec2 texCoords;

void main() {
	
	//ADJUST THIS FILE TO SEND PROPER DATA TO THE FRAGMENT SHADER
    texCoords = uv;
   
    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
