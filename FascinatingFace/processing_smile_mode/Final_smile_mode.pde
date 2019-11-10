/* 
 Code for Physical Computing Project: 
 Smile Mode - Breathing sea
 
 Author: Bingxin Feng
 
 To do: 
 1. Draw the sea: a curvy polyline shape, with perlin noise. 
 2. When user is poker-faced, the sea is calm and quiet.
 3. When user is smiling, the sea turns active and wavy.
 4. Adding layers to make the sea looked more dynamic.
 
 Referenced code credit:
 1. 'Perlin Noise Wave' from Anna Fedchenko -> https://www.openprocessing.org/sketch/576489
 I modified this code to use perlin noise to create the shape for the 'sea'. And the structure of the modified code is very different from the original code.
 
 2. 'Arduino - Processing: serial data' from Youtube channel: Programming for People -> https://bit.ly/2EsYCmf
 I learned how to input Arduino serial data to Processing from this video tutorial.
 */


//--------------------------------------------------------------------------------
import processing.video.*;
Capture cam;

// LIBRARY FOR ARDUINO SERIAL DATA
import processing.serial.*;  // includes the serial object library
Serial mySerial; // creates local serial object from serial library

// here's other variables:
String myString = null;  // the variable to collect serial data
int nl = 10;  // ASCII code for carage return in serial
// we gonna use this to validate whether we have finished receiving all the data on the serial port
float myVal;  //float for storing converted ASCII serial data (from String)

///DECLARE THE OBJECT
Wave wave;//give it a name wave
Wave wave2;//give it a name wave
Wave wave3;//give it a name wave

float min, max;

//--------------------------------------------------------------------------------
void setup() {

  // link processing to serial port (the correct one)
  String myPort = Serial.list()[3];  // find the correct serial port in your arduino menu
  // Tool - Port - which number is your port (count from 0)
  mySerial = new Serial(this, myPort, 9600);  // initialize mySerial port here.

  // UPDATE THE SERIAL DATA CONDITION BEFORE PRESENTATION HERE
  min = 190;
  max = 202;

  fullScreen();
  //size(1000, 500);
  background(0); // color above the sea
  frameRate(20);

  //INITIALIZE THE OBJECT (Y0, To, From, Min, Max)
  wave = new Wave(412, #4766BF, #478ABF, min, max); 
  wave2 = new Wave(415, #75C4CE, #75CEB7, min, max); 
  wave3 = new Wave(410, #7EB6E3, #478ABF, min, max); 

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


void draw() {


  while (mySerial.available() > 0) { // data was on the serial port

    //I'ma strip everything of the serial port, until I that carage return code:
    myString = mySerial.readStringUntil(nl);

    if (myString != null) {
      myVal = float(myString); // takes data from serial and turn it into number
      //--------------------------------------------------------------------------------
      //DO SOMETHING with the 'myVal' value:

      fill(0, 0, 0, 20); // color above the sea
      noStroke();
      rect(0, 0, width, height);
      
      pushMatrix();
      translate(0, -100);//the highest sea level position
      wave.lightValCheck();
      wave.seaLevel();
      wave.seaColor();
      strokeWeight(6);
      wave.drawLine();
      
      pushMatrix();
      translate(-100, 0);
      wave2.lightValCheck();
      wave2.seaLevel();
      wave2.seaColor();
      strokeWeight(3);
      wave2.drawLine();
      
      pushMatrix();
      translate(-100, 0);
      wave3.lightValCheck();
      wave3.seaLevel();
      wave3.seaColor();
      strokeWeight(1);
      wave3.drawLine();

      popMatrix();
      popMatrix();
      popMatrix();
    }
  }

  println(myVal);
  if (cam.available() == true) {
    cam.read();
  }
  tint(255, 255, 255, 50);
  image(cam, 0, 0, width, height);
  
  textSize(18);
  text(myVal, 10, 30);
}
