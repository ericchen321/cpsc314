uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightPosition;
uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

varying vec4 V_Color;

void main() {
	// COMPUTE COLOR ACCORDING TO GOURAUD HERE
	
	// compute vertex position in camera frame in 3D
	vec4 vertPos4D = modelViewMatrix * vec4(position, 1.0);
	vec3 vertPos = vec3(vertPos4D) / vertPos4D.w;

	// compute normal in camera frame in 3D
	vec3 normalVec = normalMatrix * normal;

	// compute light vector
	vec3 lightVec = normalize(lightPosition - vertPos);

	// compute ambient component
	vec4 ambient = vec4(kAmbient*ambientColor, 1.0);
	
	// compute diffuse component
	// compute lambertian value
	float lambertian = max(dot(normalVec, lightVec), 0.0);
	vec4 diffuse = vec4(kDiffuse*lambertian*lightColor, 1.0);

	// compute specular component
	// compute specular amount
	float specAmount;
	if (lambertian > 0.0) {
		// compute reflection vector
		vec3 reflectVec = reflect(-1.0*lightVec, normalVec);
		// compute view vector
		vec3 viewVec = -1.0*vertPos;
		specAmount = pow(max(0.0, dot(reflectVec,viewVec)), shininess);
	}
	else {
		specAmount = 0.0;
	}
	vec4 specular = vec4(kSpecular*specAmount*lightColor, 1.0);

	// compute vertex color
	V_Color = ambient + diffuse + specular;

	// Position
	gl_Position = projectionMatrix *  modelViewMatrix * vec4(position, 1.0);
}