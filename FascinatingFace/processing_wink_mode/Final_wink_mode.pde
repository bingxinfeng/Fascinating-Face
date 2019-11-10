/* 
 Code for Physical Computing Project: 
 Wink Mode - Particles Walk
 
 Author: Bingxin Feng
 
 To do: 
 1. Particles walk straightly, left side of screen is the origin, right side of screen is the destination
 2. When user's eyes are open, particles keep walking straightly.
 3. When user's eyes are closed or blinked, particles walk turning zigzag, like lost their mind.
 4. When particles hit to the destination, exit the programm and save a screenshot image of the particles tracks.
 (bonus option)
 5. Particles size keep slightly varying, to make it looks a bit more organic.
 6. Play a song named 'A wink and a smile'. When user's eyes are open, song played in normal rate. 
 When user's eyes are closed or blinked, song played in slowed down rate. 
 
 Referenced code credit:
 1. 'TwoFriendlyParticlesWithObjects' from Tim Blackwell -> https://learn.gold.ac.uk/mod/folder/view.php?id=585638
 I modified this code (a lot) to make the particles drunk walk.
 
 2. 'Arduino - Processing: serial data' from Youtube channel: Programming for People -> https://bit.ly/2EsYCmf
 I learned how to input Arduino serial data to Processing from this video tutorial.
 */


//--------------------------------------------------------------------------------
import processing.video.*;
Capture cam;

// LIBRARY FOR SOUND
import processing.sound.*;
SoundFile file;


// LIBRARY FOR ARDUINO SERIAL DATA
import processing.serial.*;  // includes the serial object library
Serial mySerial; // creates local serial object from serial library

// here's other variables:
String myString = null;  // the variable to collect serial data
int nl = 10;  // ASCII code for carage return in serial
// we gonna use this to validate whether we have finished receiving all the data on the serial port
float myVal;  //float for storing converted ASCII serial data (from String)



//--------------------------------------------------------------------------------
// The particles, variables of type Particle
Particle particle0;
Particle particle1;

// Initial speed
float speed;

// DECLARE THE ARRAY : arrayType[] arrayName
Particle[] ptcl0 = new Particle[20];
Particle[] ptcl1 = new Particle[20];



//--------------------------------------------------------------------------------
// Initialise globals
void setup() {

  // link processing to serial port 
  String myPort = Serial.list()[3];  // find the correct serial port in your arduino menu
  // Tool - Port - which number is your port (count from 0)
  mySerial = new Serial(this, myPort, 9600);  // initialize mySerial port here.


  file = new SoundFile(this, "a_wink_and_a_smile.mp3");
  file.loop();


  fullScreen();
  //size(500, 500);
  background(0);

  // Initial speed
  speed = 2;

  // Now make the Particle objects
  //particle0 = initParticle();
  //particle1 = initParticle();

  // Now make the Particle Arrays
  for (int i=0; i<ptcl0.length; i++) {
    ptcl0[i] = initParticle();
    ptcl1[i] = initParticle();
  }

  //cam
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}



//--------------------------------------------------------------------------------
// Place the initialisation code in its own function
Particle initParticle() {

  //INITIAL POSITION!!!
  PVector pos = new PVector(0, random(height));

  // Random velocity
  PVector vel = PVector.random2D();
  vel.setMag(speed);

  // Colour
  color c = color(random(100, 255), random(100, 255), random(100, 255));

  // Make the object with a call to the constructor
  return new Particle(pos, vel, c);
}



//--------------------------------------------------------------------------------
// The animations
void draw() {
  println(myVal);
  if (cam.available() == true) {
    cam.read();
  }
  tint(255, 255, 255, 50);
  image(cam, width-500, 0, 500, 300);


  while (mySerial.available() > 0) { // data was on the serial port

    //I'ma strip everything of the serial port, until I that carage return code:
    myString = mySerial.readStringUntil(nl);

    if (myString != null) {
      myVal = float(myString); // takes data from serial and turn it into number
      //--------------------------------------------------------------------------------
      //DO SOMETHING with the 'myVal' value:

      for (int i=0; i<ptcl0.length; i++) {

        // Draw the particles
        ptcl0[i].display();
        //ptcl1[i].display();  //hide the other targeted particle

        // UPDATE THE SERIAL DATA CONDITION BEFORE PRESENTATION
        float threshold = 95;
        float min = 80;
        float max = 800;

        // EYE OPEN CONDITION
        if (myVal>threshold && myVal<max) {
          // straight go particles
          ptcl0[i].goMove();
          ptcl1[i].goMove();

          //sound
          file.rate(0.8);
        }

        // EYE CLOSED CONDITION
        if ( myVal>min && myVal<threshold) {

          // Move particles
          ptcl0[i].move(ptcl1[i], ptcl0[i]);
          ptcl1[i].move(ptcl0[i], ptcl1[i]);

          //sound
          file.rate(0.5);
        }
      }
    }
  }
  println(myVal);

  textSize(18);
  text(myVal, width-100, 320);
}
