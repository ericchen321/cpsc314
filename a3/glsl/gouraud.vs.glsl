uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection; // world frame light pos
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

	// compute light vec (light direction in camera frame in 3D)
	vec4 lightDir4D = viewMatrix * vec4(lightDirection, 0.0);
	vec3 lightVec = normalize(vec3(lightDir4D));

	// compute normal in camera frame in 3D
	vec3 normalVec = normalMatrix * normal;

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
		vec3 viewVec = normalize(-1.0*vertPos);
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