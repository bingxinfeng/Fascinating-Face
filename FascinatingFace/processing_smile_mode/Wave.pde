///DEFINE A CLASS 
//(this is the 'template' for the object, not the object itself)
class Wave {

  ///DECLARE THE OBJECT DATA (variables)
  float step; //how close of each wave
  float noiseScale; //how high of the waves
  float offset; //the lowest sea level position

  float min, max;

  float y0;
  color to, from;

  float ofs; // initial off set position
  float ofs_v; //off set speed

  ///CONSTRUCTOR 
  Wave(float Y0, color To, color From, float Min, float Max) {

    y0 = Y0 + ofs;
    to = To;
    from = From;

    min = Min; //190
    max = Max; //410

    ofs =0;
    ofs_v =.01;
  }


  //--------------------------------------------------------------------------------
  //The function to set up the ARDUINO THRESHOLD VAL
  void lightValCheck() {

    noiseScale = map(myVal, min, max, 0, 0.05);
    step = map(myVal, min, max, 200, 60);
    offset = map(myVal, min, max, 250, 300);
    
    if (myVal>max){
      noiseScale = 0.05;
      step = 60;
      offset = 300;
    }
    
    if (myVal<min){
      noiseScale = 0;
      step = 200;
      offset = 250;
    }
  }


  //--------------------------------------------------------------------------------
  void seaLevel() {

    //sea level shifting up and down
    ofs+=ofs_v;
    //then sea hit either edge, go opposite direction
    if ((ofs==offset) || (ofs==0))
    {
      ofs_v=0-ofs_v;
    }
  }


  //--------------------------------------------------------------------------------
  //Color of the sea
  void seaColor() {
    for (int i =0; i<width/step+10; i+=1) { //the smaller i, the slower noise move
      float noiseVal = noise(i*noiseScale*(y0*0.006), noiseScale); //THE SPEED OF THE NOISE MOVING
      fill(lerpColor(from, to, noiseVal)); // color within the sea
      stroke(lerpColor(from, to, noiseVal));
    }
  }

  //--------------------------------------------------------------------------------
  //The function to draw one wave
  void drawLine() {

    beginShape();
    curveVertex(-100, y0);

    for (int i =0; i<width/step+10; i+=1) { //the smaller i, the slower noise move
      float noiseVal = noise(i*noiseScale*(y0*0.06), frameCount*noiseScale); //THE SPEED OF THE NOISE MOVING
      //gradient color
      //fill(lerpColor(from, to, noiseVal)); // color within the sea
      //stroke(lerpColor(from, to, noiseVal));
      curveVertex(i*step-10, y0+noiseVal*offset);
    }

    curveVertex(width+10, height+200);
    curveVertex(0, height+210);
    curveVertex(0, height+210);
    endShape();
  }
}
