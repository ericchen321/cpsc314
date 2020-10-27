/*
 * UBC CPSC 314 2020W1
 * Assignment 2
 * Transformations
 */

//*****************************TEMPLATE CODE DO NOT MODIFY********************************//
// ASSIGNMENT-SPECIFIC API EXTENSION
THREE.Object3D.prototype.setMatrix = function(a) {
  this.matrix=a;
  this.matrix.decompose(this.position,this.quaternion,this.scale);
}
// SETUP RENDERER AND SCENE
var scene = new THREE.Scene();
var renderer = new THREE.WebGLRenderer();
renderer.setClearColor(0xffffff);
document.body.appendChild(renderer.domElement);
// SETUP CAMERA
var camera = new THREE.PerspectiveCamera(30, 1, 0.1, 1000);
camera.position.set(-28,10,28);
camera.lookAt(scene.position);
scene.add(camera);
// SETUP ORBIT CONTROL OF THE CAMERA
var controls = new THREE.OrbitControls(camera);
controls.damping = 0.2;
// ADAPT TO WINDOW RESIZE
function resize() {
  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
}
window.addEventListener('resize', resize);
resize();
// FIXME: WORLD COORDINATE FRAME: other objects are defined with respect to it
var worldFrame = new THREE.AxisHelper(5) ;
scene.add(worldFrame);
// FLOOR WITH CHECKERBOARD 
var floorTexture = new THREE.ImageUtils.loadTexture('images/checkerboard.jpg');
floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping;
floorTexture.repeat.set(4, 4);
var floorMaterial = new THREE.MeshBasicMaterial({ map: floorTexture, side: THREE.DoubleSide });
var floorGeometry = new THREE.PlaneBufferGeometry(30, 30);
var floor = new THREE.Mesh(floorGeometry, floorMaterial);
floor.position.y = 0;
floor.rotation.x = Math.PI / 2;
//scene.add(floor);
//****************************************************************************************//

// OCTOPUS MATRIX: To make octopus move, modify this matrix in updatebody()
var octopusMatrix = {type: 'm4', value: new THREE.Matrix4().set(
  1.0,0.0,0.0,0.0, 
  0.0,1.0,0.0,3.0, 
  0.0,0.0,1.0,0.0, 
  0.0,0.0,0.0,1.0
  )};

//*****************************TEMPLATE CODE DO NOT MODIFY********************************//
// MATERIALS
var normalMaterial = new THREE.MeshNormalMaterial();
var octopusMaterial = new THREE.ShaderMaterial({
  uniforms:{
    octopusMatrix: octopusMatrix,
  },
});
var shaderFiles = [
  'glsl/octopus.vs.glsl',
  'glsl/octopus.fs.glsl'
];
new THREE.SourceLoader().load(shaderFiles, function(shaders) {
  octopusMaterial.vertexShader = shaders['glsl/octopus.vs.glsl'];
  octopusMaterial.fragmentShader = shaders['glsl/octopus.fs.glsl'];
})
// GEOMETRY
function loadOBJ(file, material, scale, xOff, yOff, zOff, xRot, yRot, zRot) {
  var onProgress = function(query) {
    if ( query.lengthComputable ) {
      var percentComplete = query.loaded / query.total * 100;
      console.log( Math.round(percentComplete, 2) + '% downloaded' );
    }
  };
  var onError = function() {
    console.log('Failed to load ' + file);
  };
  var loader = new THREE.OBJLoader();
  loader.load(file, function(object) {
    object.traverse(function(child) {
      if (child instanceof THREE.Mesh) {
        child.material = material;
      }
    });
    object.position.set(xOff,yOff,zOff);
    object.rotation.x= xRot;
    object.rotation.y = yRot;
    object.rotation.z = zRot;
    object.scale.set(scale,scale,scale);
    scene.add(object);
  }, onProgress, onError);
  
}
// We set octopus on (0,0,0) without scaling
// so we can change these values with transformation matrices.
loadOBJ('obj/Octopus_04_A.obj',octopusMaterial,1.0,0,0,0,0,0,0);

//***** YOU MAY FIND THESE FUNCTIONS USEFUL ******//
function defineRotation_X(theta) {
  var cosTheta = Math.cos(theta);
  var sinTheta = Math.sin(theta);
  var mtx = new THREE.Matrix4().set(
    1.0,       0.0,      0.0,       0.0, 
    0.0,       cosTheta, -sinTheta, 0.0, 
    0.0,       sinTheta, cosTheta,  0.0, 
    0.0,       0.0,      0.0,       1.0
  );
  return mtx;
}
function defineRotation_Y(theta) {
  var cosTheta = Math.cos(theta);
  var sinTheta = Math.sin(theta);
  var mtx = new THREE.Matrix4().set(
    cosTheta,  0.0,      sinTheta,  0.0, 
    0.0,       1.0,      0.0,       0.0, 
    -sinTheta, 0.0,      cosTheta,  0.0, 
    0.0,       0.0,      0.0,       1.0
  );
  return mtx;
}
function defineRotation_Z(theta) {
  var cosTheta = Math.cos(theta);
  var sinTheta = Math.sin(theta);
  var mtx = new THREE.Matrix4().set(
    cosTheta,  -sinTheta, 0.0,       0.0, 
    sinTheta,  cosTheta,  0.0,       0.0, 
    0.0,       0.0,       1.0,       0.0, 
    0.0,       0.0,       0.0,       1.0
  );
  return mtx;
}
function defineTranslation(dx, dy, dz) {
  var mtx = new THREE.Matrix4().set(
    1.0,       0.0,       0.0,       dx, 
    0.0,       1.0,       0.0,       dy, 
    0.0,       0.0,       1.0,       dz, 
    0.0,       0.0,       0.0,       1.0
  );
  return mtx;
}
//************************************************//
function addEyeAndPupil(material, eyeballTS, pupilTS, pupilTheta) {
  var eyegeo = new THREE.SphereGeometry(1.0,64,64);
  // Eyeball
  var eyeball = new THREE.Mesh(eyegeo, material);
    var eyeballMtx = new THREE.Matrix4().multiplyMatrices(
    octopusMatrix.value,
    eyeballTS 
  );
  eyeball.setMatrix(eyeballMtx);
  scene.add(eyeball);
  // Pupil
  var pupilRT = defineRotation_Y(pupilTheta);
  var pupilTSR = new THREE.Matrix4().multiplyMatrices(
    pupilRT, 
    pupilTS
  );
  var pupilMtx = new THREE.Matrix4().multiplyMatrices(
    eyeballMtx, 
    pupilTSR
  );
  var pupil = new THREE.Mesh(eyegeo, material);
  pupil.setMatrix(pupilMtx);
  scene.add(pupil);
  return [eyeball, pupil];
}

// Left eye
var eyeballTS_L = new THREE.Matrix4().set(
  0.5,0.0,0.0,-0.2, 
  0.0,0.5,0.0,4.1, 
  0.0,0.0,0.5,0.92, 
  0.0,0.0,0.0,1.0
);
var pupilTS_L = new THREE.Matrix4().set(
  0.35,0.0,0.0,0.0, 
  0.0,0.35,0.0,0.0, 
  0.0,0.0,0.15,-0.9, 
  0.0,0.0,0.0,1.0
);
var theta_L = Math.PI * (130 /180.0);
// Right eye
var eyeballTS_R = new THREE.Matrix4().set(
  0.5,0.0,0.0,-0.2, 
  0.0,0.5,0.0,4.1, 
  0.0,0.0,0.5,-0.92, 
  0.0,0.0,0.0,1.0
);
var pupilTS_R = new THREE.Matrix4().set(
  0.35,0.0,0.0,0.0, 
  0.0,0.35,0.0,0.0, 
  0.0,0.0,0.15,-0.9, 
  0.0,0.0,0.0,1.0
);
var theta_R = Math.PI * (50 /180.0);
lefteye = addEyeAndPupil(normalMaterial, eyeballTS_L, pupilTS_L, theta_L);
eyeball_L = lefteye[0];
pupil_L = lefteye[1];
righteye = addEyeAndPupil(normalMaterial, eyeballTS_R, pupilTS_R, theta_R);
eyeball_R = righteye[0];
pupil_R = righteye[1];
//****************************************************************************************//


//***** YOUR CODE HERE *****//
// You need to add 3 joints and 3 links for each arm
// Each arm starts with a joint and ends with a link
// joint-link-joint-link-joint-link

// some useful constants
const LINK_LENGTH = 2; // length of links
// transformations along local y axis for each joint/link w.r.t its parent
const LINK1_SHIFT = 1.2;
const JOINT2_SHIFT =  1.2;
const LINK2_SHIFT = 1.22;
const JOINT3_SHIFT = 1.1;
const LINK3_SHIFT = 1.1;

// Geometries of the arm
var j1 = new THREE.SphereGeometry(0.5,64,64);
var l1 = new THREE.CylinderGeometry(0.35, 0.45, LINK_LENGTH, 64);
var j2 = new THREE.SphereGeometry(0.4, 64, 64);
var l2 = new THREE.CylinderGeometry(0.25, 0.35, LINK_LENGTH, 64);
var j3 = new THREE.SphereGeometry(0.3, 64, 64);
var l3 = new THREE.CylinderGeometry(0.1, 0.25, LINK_LENGTH, 64);

// ***** Q1 *****//
function addOneArm(angle_Y, angle_Z, socketPosition) {
  /* angle_Y, angle_Z determines the direction of the enire arm
   * i.e. you create a arm on world scene's origin, rotate along
   * y-axis, and z-axis by these angles will let you insert your
   * arm into the socket
  */

  // Add joint1
  /* Hint: You should rotate joint1 so that for future links and joints,
   *       They can be along the direction of the socket
   *       Even though the sphere looks unchanged but future links are
   *       chidren frames of this joint1
   * Hint: You also need to translate joint1
  */
  var joint1 = new THREE.Mesh(j1, normalMaterial);
  var joint1T = defineTranslation(socketPosition[0], socketPosition[1], socketPosition[2]);
  var joint1R_y = defineRotation_Y(angle_Y);
  var joint1R_z = defineRotation_Z(angle_Z);
  var joint1TR = new THREE.Matrix4().multiplyMatrices(
    joint1T,
    new THREE.Matrix4().multiplyMatrices(joint1R_y, joint1R_z)
  )
  var joint1Mtx = new THREE.Matrix4().multiplyMatrices(
    octopusMatrix.value,
    joint1TR
  );
  joint1.setMatrix(joint1Mtx);
  scene.add(joint1);

  // Add link1
  /* Hint: Find out the translation matrix so that
   *       link is connected with joints, without overlaping
   */
  var link1 = new THREE.Mesh(l1, normalMaterial);
  var link1T = defineTranslation(0.0, LINK1_SHIFT, 0.0);
  var link1Mtx = new THREE.Matrix4().multiplyMatrices(
    joint1Mtx,
    link1T
  );
  link1.setMatrix(link1Mtx);
  scene.add(link1);
  
  // Add joint2
  var joint2 = new THREE.Mesh(j2, normalMaterial);
  var joint2T = defineTranslation(0.0, JOINT2_SHIFT, 0.0);
  var joint2Mtx = new THREE.Matrix4().multiplyMatrices(
    link1Mtx,
    joint2T
  );
  joint2.setMatrix(joint2Mtx);
  scene.add(joint2);

  // Add link2
  var link2 = new THREE.Mesh(l2, normalMaterial);
  var link2T = defineTranslation(0.0, LINK2_SHIFT, 0.0);
  var link2Mtx = new THREE.Matrix4().multiplyMatrices(
    joint2Mtx,
    link2T
  );
  link2.setMatrix(link2Mtx);
  scene.add(link2);

  // Add joint3
  var joint3 = new THREE.Mesh(j3, normalMaterial);
  var joint3T = defineTranslation(0.0, JOINT3_SHIFT, 0.0);
  var joint3Mtx = new THREE.Matrix4().multiplyMatrices(
    link2Mtx,
    joint3T
  );
  joint3.setMatrix(joint3Mtx);
  scene.add(joint3);

  // Add link3
  var link3 = new THREE.Mesh(l3, normalMaterial);
  var link3T = defineTranslation(0.0, LINK3_SHIFT, 0.0);
  var link3Mtx = new THREE.Matrix4().multiplyMatrices(
    joint3Mtx,
    link3T
  );
  link3.setMatrix(link3Mtx);
  scene.add(link3);

  return [joint1, link1, joint2, link2, joint3, link3];
}

/* Now, call addOneArm() 4 times with 4 directions and
 * and 4 socket positions, you will add 4 arms on octopus
 * We return a tuple of joints and links, use them to 
 * animate the octupus
*/

// Socket positions
socketPos1 = [-2.4, -0.35, 2.4];
socketPos2 = [2.4, -0.35, 2.4];
socketPos3 = [2.4, -0.35, -2.4];
socketPos4 = [-2.4, -0.35, -2.4];
//***** Q2 *****//
var arm1 = addOneArm(Math.PI*(-135/180), Math.PI*(-0.5), socketPos1);
var arm2 = addOneArm(Math.PI*(-45/180), Math.PI*(-0.5), socketPos2);
var arm3 = addOneArm(Math.PI*(45/180), Math.PI*(-0.5), socketPos3);
var arm4 = addOneArm(Math.PI*(135/180), Math.PI*(-0.5), socketPos4);

//***** Q3.b *****/
function animateArm(t, arm, angle_Y, angle_Z, socketPosition) {
  joint1 = arm[0];
  link1 = arm[1];
  joint2 = arm[2];
  link2 = arm[3];
  joint3 = arm[4];
  link3 = arm[5];
  /* copy and paste your function of addOneArm() here,
   * remove the lines of new THREE.mesh(...) and scene.add(...)
   * will update the matrices of the meshes so that 
   * the arms move with the body, but without effects of swimming
   * 
   * Hint: In addOneArm(), you computed the transformation
   *       matrices of joints and links, simulating swimmiing effect
   *       requires you to rotate only links in links' own frame
   *       You also have computed transformation matrices that
   *       transform link to its parent, think about how you can
   *       do rotation only in the link's frame and then transform
   *       points to its parents
   * 
   * Hint: T_{oct-joint} * T_{joint-link}
   *                       |
   *       T_{oct-joint} * R * T_{joint-link}
   *       Your task is to find R for 3 links and multiply R between
   *       transformation matrices.
   * 
   * Hint: To generate time related rotation, use
   *       rotate along axis you want by angle of function of
   *       sine t, then we have a periodic effect
   *       var rotation = defineRotation_{AXIS}(f(sin(t)))
  */
  var armMoveAmplitude = 15; // amplitude of arm movement in degree

  // Add joint1
  var joint1T = defineTranslation(socketPosition[0], socketPosition[1], socketPosition[2]);
  var joint1R_y = defineRotation_Y(angle_Y);
  var joint1R_z = defineRotation_Z(angle_Z);
  var joint1TR = new THREE.Matrix4().multiplyMatrices(
    joint1T,
    new THREE.Matrix4().multiplyMatrices(joint1R_y, joint1R_z)
  )
  var joint1Mtx = new THREE.Matrix4().multiplyMatrices(
    octopusMatrix.value,
    joint1TR
  );
  joint1.setMatrix(joint1Mtx);

  // Add link1
  var link1Theta = Math.PI * (Math.sin(2*Math.PI*t/5.0)*armMoveAmplitude)/180.0;
  var link1R = defineRotation_Z(link1Theta)
  var link1T = defineTranslation(0.0, 1.2, 0.0);
  var link1Mtx = new THREE.Matrix4().multiplyMatrices(
    joint1Mtx,
    new THREE.Matrix4().multiplyMatrices(link1R, link1T)
  );
  link1.setMatrix(link1Mtx);
  
  // Add joint2
  var joint2T = defineTranslation(0.0, 1.2, 0.0);
  var joint2Mtx = new THREE.Matrix4().multiplyMatrices(
    link1Mtx,
    joint2T
  );
  joint2.setMatrix(joint2Mtx);

  // Add link2
  var link2Theta = Math.PI * (Math.sin(2*Math.PI*t/5.0 + Math.PI/2)*armMoveAmplitude)/180.0;
  var link2R = defineRotation_Z(link2Theta)
  var link2T = defineTranslation(0.0, 1.22, 0.0);
  var link2Mtx = new THREE.Matrix4().multiplyMatrices(
    joint2Mtx,
    new THREE.Matrix4().multiplyMatrices(link2R, link2T)
  );
  link2.setMatrix(link2Mtx);

  // Add joint3
  var joint3T = defineTranslation(0.0, 1.1, 0.0);
  var joint3Mtx = new THREE.Matrix4().multiplyMatrices(
    link2Mtx,
    joint3T
  );
  joint3.setMatrix(joint3Mtx);

  // Add link3
  var link3Theta = Math.PI * (Math.sin(2*Math.PI*t/5.0 - Math.PI/4)*armMoveAmplitude)/180.0;
  var link3R = defineRotation_Z(link3Theta)
  var link3T = defineTranslation(0.0, 1.1, 0.0);
  var link3Mtx = new THREE.Matrix4().multiplyMatrices(
    joint3Mtx,
    new THREE.Matrix4().multiplyMatrices(link3R, link3T)
  );
  link3.setMatrix(link3Mtx);

  return;
}

var clock = new THREE.Clock(true);
var initalMtx = octopusMatrix.value;

// computes joint position given a 2-DOF IK problem
// returns the joint position
function computeJointPos(l1Pos, l1Length, l2Length, endPos, upVec) {
  var vecA = new THREE.Vector3(endPos.x-l1Pos.x, endPos.y-l1Pos.y, endPos.z-l1Pos.z);
  //console.log("vecA is " + vecA.x + " " + vecA.y + " " + vecA.z)
  var A = vecA.length()
  //console.log("A is " + A)
  var O_S2 = A - l2Length;
  var C = l1Length - O_S2;
  var B = O_S2 + 0.5*C;
  var D = B*C/A;
  //console.log("D is " + D)
  
  var j = vecA;
  j.normalize();
  j.multiplyScalar(O_S2+D)
  j.add(l1Pos);
  //console.log("j is " + j.x + " " + j.y + " " + j.z)

  var planeNormal = new THREE.Vector3();
  planeNormal.crossVectors(vecA, upVec);

  var jVec = new THREE.Vector3();
  jVec.crossVectors(planeNormal, vecA);
  jVec.normalize();
  //console.log("jVec is " + jVec.x + " " + jVec.y + " " + jVec.z)
  //console.log('l1^2 is ' + Math.pow(l1Length, 2))
  //console.log('(O_S2+D)^2 is ' + Math.pow((O_S2+D), 2))
  oppoLeg = Math.sqrt(Math.pow(l1Length, 2) - Math.pow((O_S2+D), 2));
  console.log("oppoLeg is " + oppoLeg)

  var jointPos = jVec;
  jointPos.multiplyScalar(oppoLeg);
  jointPos.add(j);
  //console.log("joint pos: " + jointPos.x + " " + jointPos.y + " " + jointPos.z)
  return jointPos;
}

// Computes look-at transformation matrix from start (joint) position,
// end effector position, up vector
// returns the matrix 
function computeLookAtTransform(startPos, endPos, upVec) {
  lookAtVec = new THREE.Vector3(endPos.x-startPos.x, endPos.y-startPos.y, endPos.z-startPos.z);
  lookAtVec.normalize();
  /*
  col1 = new THREE.Vector3();
  col1.crossVectors(upVec, lookAtVec);
  col1.normalize();

  col2 = new THREE.Vector3();
  col2.crossVectors(lookAtVec, col1);
  col2.normalize();
  
  lookAtMat = new THREE.Matrix4().set(
    col1.x,  col2.x,   lookAtVec.x,  startPos.x, 
    col1.y,  col2.y,   lookAtVec.y,  startPos.y, 
    col1.z,  col2.z,   lookAtVec.z,  startPos.z, 
    0.0,     0.0,      0.0,          1.0
  );
  */
  //console.log(lookAtMat);

  col3 = new THREE.Vector3();
  col3.crossVectors(lookAtVec, upVec);
  col3.normalize();
  
  col1 = new THREE.Vector3();
  col1.crossVectors(lookAtVec, col3);
  col1.normalize();
  
  lookAtMat = new THREE.Matrix4().set(
    col1.x,  lookAtVec.x,  col3.x,  startPos.x, 
    col1.y,  lookAtVec.y,  col3.y,  startPos.y, 
    col1.z,  lookAtVec.z,  col3.z,  startPos.z, 
    0.0,     0.0,          0.0,     1.0
  );
  
  /*
  lookAtMat = new THREE.Matrix4().set(
    1.0,  0.0,   0.0,  0.0, 
    0.0,  1.0,   0.0,  0.0, 
    0.0,  0.0,   1.0,  0.0, 
    0.0,  0.0,   0.0,  1.0
  );
  */
  
  return lookAtMat;
}

// animate walking of an entire arm. socketPos allows computing
// the length of an imaginary link from the origin to joint 1,
// so we can compute joint 1's position;
// returns joint1's position
function animateArmWalking(arm, upVector, socketPos, tipPos) {
  joint1 = arm[0];
  link1 = arm[1];
  joint2 = arm[2];
  link2 = arm[3];
  joint3 = arm[4];
  link3 = arm[5];

  console.log("socket pos: " + socketPos.x + " " + socketPos.y + " " + socketPos.z)
  console.log("tip pos: " + tipPos.x + " " + tipPos.y + " " + tipPos.z)

  // compute virtual link 1's length
  var v1_min = 0.0
  var v1_max = 2.0 * LINK_LENGTH;
  var OP_max = 3.0 * LINK_LENGTH;
  var OPVec = tipPos;
  var OP = OPVec.length();
  var v1Length = (v1_max - v1_min)* OP/OP_max + v1_min;
  console.log("v1Length: " + v1Length);

  // compute joint3 position
  var joint3Pos = computeJointPos(socketPos, v1Length, LINK_LENGTH, tipPos, upVector);
  //console.log("joint3 pos: " + joint3Pos.x + " " + joint3Pos.y + " " + joint3Pos.z)
  // set transformation matrix for joint3
  var joint3Mtx = defineTranslation(joint3Pos.x, joint3Pos.y, joint3Pos.z);
  // set transformation matrix for link3
  var link3Mtx = computeLookAtTransform(joint3Pos, tipPos, upVector);
  //console.log(link3Mtx);

  // compute joint2 position
  var joint2Pos = computeJointPos(socketPos, LINK_LENGTH, LINK_LENGTH, joint3Pos, upVector);
  console.log("joint2 pos: " + joint2Pos.x + " " + joint2Pos.y + " " + joint2Pos.z);
  // set transformation matrix for joint2
  var joint2Mtx = defineTranslation(joint2Pos.x, joint2Pos.y, joint2Pos.z);
  // set transformation matrix for link2
  var link2Mtx = computeLookAtTransform(joint2Pos, joint3Pos, upVector);

  // compute joint1 position
  var joint1Pos = socketPos;
  console.log("joint1 pos: " + joint1Pos.x + " " + joint1Pos.y + " " + joint1Pos.z);
  // set transformation matrix for joint1
  var joint1Mtx = defineTranslation(joint1Pos.x, joint1Pos.y, joint1Pos.z);
  // set transformation matrix for link1
  var link1Mtx = computeLookAtTransform(joint1Pos, joint2Pos, upVector);

  joint3.setMatrix(joint3Mtx);
  link3.setMatrix(new THREE.Matrix4().multiplyMatrices(link3Mtx, defineTranslation(0.0, LINK3_SHIFT, 0.0)));
  joint2.setMatrix(joint2Mtx);
  link2.setMatrix(new THREE.Matrix4().multiplyMatrices(link2Mtx, defineTranslation(0.0, LINK2_SHIFT, 0.0)));
  joint1.setMatrix(joint1Mtx);
  link1.setMatrix(new THREE.Matrix4().multiplyMatrices(link1Mtx, defineTranslation(0.0, LINK1_SHIFT, 0.0)));

  return joint1Pos;
}

function updateBody() {
  switch(channel)
  {
    case 0: 
      break;

    case 1:
      //***** Example of how to rotate eyes with octopus *****//
      // Your animations should be similar to this
      // i.e. octopus' body parts moves at the same time
      var t = clock.getElapsedTime();
      octopusMatrix.value = new THREE.Matrix4().multiplyMatrices(
        defineRotation_Y(t),
        initalMtx
      );
      // Right eye
      eyeball_R.setMatrix(new THREE.Matrix4().multiplyMatrices(
        octopusMatrix.value,
        eyeballTS_R
      ));
      pupil_R.setMatrix(new THREE.Matrix4().multiplyMatrices(
        new THREE.Matrix4().multiplyMatrices(
          octopusMatrix.value,
          eyeballTS_R
        ),
        new THREE.Matrix4().multiplyMatrices(
          defineRotation_Y(theta_R),
          pupilTS_R
        )
      ));
      scene.add(eyeball_R);
      scene.add(pupil_R);
      // You can also define the matrices and multiply
      // Left eye
      oct_eye_L = new THREE.Matrix4().multiplyMatrices(
        octopusMatrix.value,
        eyeballTS_L
      );
      pupil_L_TSR = new THREE.Matrix4().multiplyMatrices(
        defineRotation_Y(theta_L),
        pupilTS_L
      );
      oct_pupil = new THREE.Matrix4().multiplyMatrices(
        oct_eye_L,
        pupil_L_TSR
      );
      eyeball_L.setMatrix(oct_eye_L);
      pupil_L.setMatrix(oct_pupil);
      break;
    case 2:
      break;

    //animation
    case 3:
      {
        var t = clock.getElapsedTime();

        // Animate Octopus Body
        octopusMatrix.value = new THREE.Matrix4().set(
          1.0,0.0,0.0,0.0, 
          0.0,1.0,0.0,(Math.sin(t/1.1+11)*1.8)+3, 
          0.0,0.0,1.0,0.0, 
          0.0,0.0,0.0,1.0
        );
        //***** Q3.a *****//
        // Animate Right Eye (eyeball and pupil)
        eyeball_R.setMatrix(new THREE.Matrix4().multiplyMatrices(
          octopusMatrix.value,
          eyeballTS_R
        ));
        pupil_R.setMatrix(new THREE.Matrix4().multiplyMatrices(
          new THREE.Matrix4().multiplyMatrices(
            octopusMatrix.value,
            eyeballTS_R
          ),
          new THREE.Matrix4().multiplyMatrices(
            defineRotation_Y(theta_R),
            pupilTS_R
          )
        ));
        //scene.add(eyeball_R);
        //scene.add(pupil_R);
        // Animate Left Eye (eyeball and pupil)
        eyeball_L.setMatrix(new THREE.Matrix4().multiplyMatrices(
          octopusMatrix.value,
          eyeballTS_L
        ));
        pupil_L.setMatrix(new THREE.Matrix4().multiplyMatrices(
          new THREE.Matrix4().multiplyMatrices(
            octopusMatrix.value,
            eyeballTS_L
          ),
          new THREE.Matrix4().multiplyMatrices(
            defineRotation_Y(theta_L),
            pupilTS_L
          )
        ));
        //scene.add(eyeball_L);
        //scene.add(pupil_L);
        // Animate Arms
        //***** Q3.c *****//
        animateArm(t, arm1, Math.PI*(-135/180), Math.PI*(-0.5), socketPos1);
        animateArm(t, arm2, Math.PI*(-45/180), Math.PI*(-0.5), socketPos2);
        animateArm(t, arm3, Math.PI*(45/180), Math.PI*(-0.5), socketPos3);
        animateArm(t, arm4, Math.PI*(135/180), Math.PI*(-0.5), socketPos4);
      }

      break;
      
    // inverse kinematics
    case 4:
      {
        var upVector = new THREE.Vector3(0.0, 1.0, 0.0); // moving in x-y plane
        var t = clock.getElapsedTime();

        var xInit_14 = -4.0;
        var xInit_23 = 3.0;
        var zInit_12 = socketPos1[2]+3.0;
        var zInit_34 = socketPos3[2];

        // IK for arm 1
        var socketPos1Vec = new THREE.Vector3(socketPos1[0], socketPos1[1], socketPos1[2]);
        socketPos1Vec.applyMatrix4(octopusMatrix.value);
        var tipPosArm1 = new THREE.Vector3(xInit_14+Math.cos(t/1.1), Math.abs(Math.sin(t/1.1)*1.2), zInit_12);
        var joint1Pos = animateArmWalking(arm1, upVector, socketPos1Vec, tipPosArm1);
        /*
        // IK for arm 2
        var socketPos2Vec = new THREE.Vector3(socketPos2[0]-1.0*t, socketPos2[1], socketPos2[2]);
        var tipPosArm2 = new THREE.Vector3(xInit_23-1.0*t, Math.abs(Math.sin(t/1.1)*1.2), zInit_12);
        animateArmWalking(arm2, upVector, socketPos2Vec, tipPosArm2);

        // IK for arm 3
        var socketPos3Vec = new THREE.Vector3(socketPos3[0]-1.0*t, socketPos3[1], socketPos3[2]);
        var tipPosArm3 = new THREE.Vector3(xInit_23-1.0*t, Math.abs(Math.sin(t/1.1)*1.2), zInit_34);
        animateArmWalking(arm3, upVector, socketPos3Vec, tipPosArm3);

        // IK for arm 2
        var socketPos4Vec = new THREE.Vector3(socketPos4[0]-1.0*t, socketPos4[1], socketPos4[2]);
        var tipPosArm4 = new THREE.Vector3(xInit_14-1.0*t, Math.abs(Math.sin(t/1.1)*1.2), zInit_34);
        animateArmWalking(arm4, upVector, socketPos4Vec, tipPosArm4);
        */
      }

      break;
    default:
      break;
  }
}


// LISTEN TO KEYBOARD
var keyboard = new THREEx.KeyboardState();
var channel = 0;
function checkKeyboard() {
  for (var i=0; i<6; i++)
  {
    if (keyboard.pressed(i.toString()))
    {
      channel = i;
      break;
    }
  }
}


// SETUP UPDATE CALL-BACK
function update() {
  checkKeyboard();
  updateBody();
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

update();