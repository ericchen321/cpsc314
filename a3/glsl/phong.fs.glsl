uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;
uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

varying vec4 V_ViewPosition;
varying vec4 V_Normal_VCS;


void main() {
	// COMPUTE LIGHTING HERE
	// get fragement position in camera frame in 3D
	vec3 fragPos = vec3(V_ViewPosition);

	// compute light vector (light direction in camera frame in 3D)
	vec4 lightDir4D = viewMatrix * vec4(lightDirection, 0.0);
	vec3 lightVec = normalize(vec3(lightDir4D));

	// get fragment normal in camera frame in 3D
	vec3 normalVec = normalize(vec3(V_Normal_VCS));

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
		vec3 viewVec = normalize(-1.0*fragPos);
		specAmount = pow(max(0.0, dot(reflectVec,viewVec)), shininess);
	}
	else {
		specAmount = 0.0;
	}
	vec3 specular = kSpecular*specAmount*lightColor;

	// compute vertex color
	gl_FragColor = vec4((ambient + diffuse + specular), 1.0);
}