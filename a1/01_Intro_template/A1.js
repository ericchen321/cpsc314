/**
 * UBC CPSC 314, Vsep2015
 * Assignment 1 Template
 */
var scene = new THREE.Scene();

// SETUP RENDERER
var renderer = new THREE.WebGLRenderer();
//renderer.setClearColor(0xffffff); // white background colour
renderer.setClearColor(0x000000); // black background colour
document.body.appendChild(renderer.domElement);

// SETUP CAMERA
var camera = new THREE.PerspectiveCamera(30, 1, 0.1, 1000); // view angle, aspect ratio, near, far
camera.position.set(10,15,40);
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

// WORLD COORDINATE FRAME: other objects are defined with respect to it
var worldFrame = new THREE.AxisHelper(5) ;
scene.add(worldFrame);

// LIGHT STUFF
var spotLight = new THREE.SpotLight(0xfff700, 0.4, undefined, Math.PI/4);
spotLight.position.set(10, 10, 10);
spotLight.casShadow = true;
scene.add(spotLight);

var displayScreenGeometry = new THREE.CylinderGeometry(5, 5, 10, 32);
var displayMaterial = new THREE.MeshPhongMaterial({color: 0xffff00, transparent: true, opacity: 0.2});
var displayObject = new THREE.Mesh(displayScreenGeometry,displayMaterial);
displayObject.position.x = 0;
displayObject.position.y = 5;
scene.add(displayObject);
displayObject.parent = worldFrame;

// FLOOR 
var floorTexture = new THREE.ImageUtils.loadTexture('images/floor.jpg');
floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping;
floorTexture.repeat.set(1, 1);

var floorMaterial = new THREE.MeshPhongMaterial({ map: floorTexture, side: THREE.DoubleSide });
var floorGeometry = new THREE.PlaneBufferGeometry(30, 30);
var floor = new THREE.Mesh(floorGeometry, floorMaterial);
floor.position.y = -0.1;
floor.rotation.x = Math.PI / 2;
scene.add(floor);
floor.parent = worldFrame;
var bboxFloor = new THREE.Box3().setFromObject(floor);
console.log('z min for floor is ' + bboxFloor.min.y);

// UNIFORMS
var distObjToFloor = {type: 'f', value: 0.0}; // distance from object's bottom to floor
var remotePosition = {type: 'v3', value: new THREE.Vector3(0,5,3)};
var rcState = {type: 'i', value: 1};
var rcState1_color = {type: 'v3', value: new THREE.Vector3(1,0,0)};
var rcState2_color = {type: 'v3', value: new THREE.Vector3(0,1,0)};
var rcState3_color = {type: 'v3', value: new THREE.Vector3(0,0,1)};
var timeInit = Date.now();
var timeElapsed = {type: 'f', value: 0.0}
var enableExplosion = {type: 'i', value: 0};

// MATERIALS
/* HINT: YOU WILL NEED TO SHARE VARIABLES FROM HERE */
var racoonMaterial = new THREE.ShaderMaterial({
  uniforms: {
    distObjToFloor: distObjToFloor,
    remotePosition: remotePosition,
    timeElapsed: timeElapsed,
    rcState: rcState,
    rcState1_color: rcState1_color,
    rcState2_color: rcState2_color,
    rcState3_color: rcState3_color,
    enableExplosion: enableExplosion,
  }
});
racoonMaterial.transparent = true;

var remoteMaterial = new THREE.ShaderMaterial({
   uniforms: {
    remotePosition: remotePosition,
    rcState: rcState,
    timeElapsed: timeElapsed,
    rcState1_color: rcState1_color,
    rcState2_color: rcState2_color,
    rcState3_color: rcState3_color,
  },
});
remoteMaterial.transparent = true;

// LOAD SHADERS
var shaderFiles = [
  'glsl/racoon.vs.glsl',
  'glsl/racoon.fs.glsl',
  'glsl/remote.vs.glsl',
  'glsl/remote.fs.glsl'
];

new THREE.SourceLoader().load(shaderFiles, function(shaders) {
  racoonMaterial.vertexShader = shaders['glsl/racoon.vs.glsl'];
  racoonMaterial.fragmentShader = shaders['glsl/racoon.fs.glsl'];

  remoteMaterial.vertexShader = shaders['glsl/remote.vs.glsl'];
  remoteMaterial.fragmentShader = shaders['glsl/remote.fs.glsl'];
})

// LOAD RACCOON
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
    object.parent = worldFrame;
    scene.add(object);
    var bboxObj = new THREE.Box3().setFromObject(object);
    console.log('z min for racoon is ' + bboxObj.min.y);
    distObjToFloor.value = bboxObj.min.y - bboxFloor.min.y;
    console.log('offset value is ' + (bboxObj.min.y - bboxFloor.min.y))
    material.needsUpdate = true;

  }, onProgress, onError);
}

loadOBJ('obj/Racoon.obj', racoonMaterial, 0.5, 0,1,0, Math.PI/2,Math.PI,Math.PI);

// CREATE REMOTE CONTROL
var remoteGeometry = new THREE.SphereGeometry(1, 32, 32);
var remote = new THREE.Mesh(remoteGeometry, remoteMaterial);
remote.parent = worldFrame;
scene.add(remote);

// LISTEN TO KEYBOARD
var keyboard = new THREEx.KeyboardState();
function checkKeyboard() {

  if (keyboard.pressed("Q"))
    remotePosition.value.z -= 0.1;
  else if (keyboard.pressed("Z"))
    remotePosition.value.z += 0.1;

  if (keyboard.pressed("A"))
    remotePosition.value.x -= 0.1;
  else if (keyboard.pressed("D"))
    remotePosition.value.x += 0.1;

  if (keyboard.pressed("W"))
    remotePosition.value.y += 0.1;
  else if (keyboard.pressed("S"))
    remotePosition.value.y -= 0.1;
  
  if (keyboard.pressed("E"))
    enableExplosion.value = 1;
  else if (keyboard.pressed("R"))
    enableExplosion.value = 0;

  for (var i=1; i<4; i++)
  {
    if (keyboard.pressed(i.toString()))
    {
      rcState.value = i;
      break;
    }
  }
  remoteMaterial.needsUpdate = true; // Tells three.js that some uniforms might have changed
  racoonMaterial.needsUpdate = true; // Tells three.js that some uniforms might have changed
}

// UPDATE TIME
function updateTime() {
  timeElapsed.value = (Date.now() - timeInit) / 1000.0;

  //var noise_r = 0.002;
  //var noise_g = 0.002; 
  //var noise_b = 0.002;  
  var noise_r = Math.random()/2;
  var noise_g = Math.random()/2;
  var noise_b = Math.random()/2;
  rcState1_color.value.set(1.0+noise_r, 0.0+noise_g, 0.0+noise_b);
  rcState2_color.value.set(0.0+noise_r, 1.0+noise_g, 0.0+noise_b);
  rcState3_color.value.set(0.0+noise_r, 0.0+noise_g, 1.0+noise_b);
  racoonMaterial.needsUpdate = true; // Tells three.js that some uniforms might have changed
  remoteMaterial.needsUpdate = true;
}

// SETUP UPDATE CALL-BACK
function update() {
  checkKeyboard();
  updateTime();
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

update();

