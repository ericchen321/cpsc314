uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightPosition; // world frame light pos
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

	// compute light position in camera frame in 3D
	vec4 lightPos4D = viewMatrix * vec4(lightPosition, 1.0);
	vec3 lightPos = vec3(lightPos4D) / lightPos4D.w;

	// compute normal in camera frame in 3D
	vec3 normalVec = normalMatrix * normal;

	// compute light vector
	vec3 lightVec = normalize(lightPos - vertPos);

	// compute ambient component
	vec3 ambient = kAmbient*ambientColor;
	
	// compute diffuse component
	// compute lambertian value
	float lambertian = max(dot(normalVec, lightVec), 0.0);
	vec3 diffuse = kDiffuse*lambertian*lightColor;

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
	vec3 specular = kSpecular*specAmount*lightColor;

	// compute vertex color
	V_Color = vec4((ambient + diffuse + specular), 1.0);

	// Position
	gl_Position = projectionMatrix *  modelViewMatrix * vec4(position, 1.0);
}