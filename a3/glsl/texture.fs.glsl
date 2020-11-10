uniform sampler2D rockTexture;

// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
varying vec2 texCoords;

void main() {

	// LOOK UP THE COLOR IN THE TEXTURE
  vec4 fragColor = texture2D(rockTexture, texCoords);

  vec3 finalLight = fragColor.rgb;
  gl_FragColor = vec4(finalLight, 1.0); 

  // Set final rendered color according to the surface normal
  gl_FragColor = fragColor; 
}
