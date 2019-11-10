/*
Class to represent a particle.
 Particle is a simple thing with dynamic attributes position and velocity
 and intrinsic properties radius and colour.
 Simple behaviour too, it can move() and display().
 */
class Particle {

  // Properties
  PVector pos, vel;
  float rad;
  color col;

  // Acceleration parameters
  float attrConst = 0.01;
  float fricConst = 0.01;
  float randConst = 0.2;
  float min = 9;       //smaller, more faraway, 5~9 looks okay
  float alpha = 1.5;
  float maxSpeed = 5;  //bigger, more faraway 

  float t, t2; //time to run the noise graph
  float sp;
  float stepSz; //to how big is control the noised value


  //--------------------------------------------------------------------------------
  // Constructor creates a particle object at (x, y) with random colour
  Particle(float x, float y) {
    this(new PVector(x, y), new PVector(0, 0), color(255, 0, 0));
  }

  // Creates a particle object at (x, y) with velocity v and colour c
  Particle(PVector r, PVector v, color c) {
    pos = r; 
    vel = v;
    col = c;
  }


  //--------------------------------------------------------------------------------
  void display() {
    
    //particles size varying organicly
    float n = noise(t);
    stepSz=10;
    rad = n*stepSz;

    ellipseMode(CENTER);
    noStroke();
    fill(col);

    ellipse(pos.x, pos.y, rad, rad);
    t+=0.03;
  }


  //--------------------------------------------------------------------------------
  void goMove() {
    
    pos.x = pos.x + sp; //go straight to right
    
    saveExit(); //check when x hit to destination, save screenshot and exit programm

    sp+=0.01;
  }



  //--------------------------------------------------------------------------------
  // Code to freely move the particle, no interaction
  void move() {

    pos.x += vel.x;
    pos.y += vel.y;

    boundary();
  }


  //--------------------------------------------------------------------------------
  // Code to calculate iteraction with anoter particle and the target
  void move(Particle part, Particle honey) {

    // Acceleration towrds particle
    PVector accn = accelerate(part);
    accn.add(PVector.random2D().mult(randConst * hyperbolic(min, alpha)) );
    vel.add(accn);

    // Acceration towards honey
    accn = accelerate(honey);
    vel.add(accn);

    // Trim speed
    trim();

    // Add velocity to position
    pos.add(vel);

    // Take care of boundary
    boundary();
  }



  //--------------------------------------------------------------------------------
  // Code for interaction with another particle
  void move(Particle part) {

    PVector accn = accelerate(part);
    vel.add(accn);
    trim();
    pos.add(vel);
    boundary();
  }

  // Spring-like acceleration, a = k(y - x) 
  PVector accelerate(Particle p) {

    PVector accn = new PVector(p.pos.x, p.pos.y);
    accn.sub(pos);
    accn.mult(attrConst);
    return accn;
  }



  //--------------------------------------------------------------------------------
  // Impose speed limit
  void trim() {

    float velMag = vel.mag();
    if (velMag > maxSpeed) {
      vel.normalize().mult(maxSpeed);
    }
  }


  //--------------------------------------------------------------------------------
  // Boundary action - written as a separate method to facilitate 
  // inclusion of other types of boundary
  void boundary() {

    if (pos.x > width) {
      pos.x = width - pos.x % width;
      vel.x *= -1;
    } else if (pos.x < 0) {
      pos.x = -1* (pos.x % width);
      vel.x *= -1;
    }

    if (pos.y > height) {
      pos.y = height - pos.y % height;
      vel.y *= -1;
    } else if (pos.y < 0) {
      pos.y = -1 * (pos.y % height);
      vel.y *= -1;
    }
  }


  //--------------------------------------------------------------------------------
  // Hyperbolic distribution
  float hyperbolic(float min, float alpha) {

    return min * pow(1 - random(1), -1.0 / alpha);
  }


  //--------------------------------------------------------------------------------
  void saveExit() {
    if (pos.x > width) { 
      save("img_" + frameCount + ".png");  
      exit();
    }
  }
}
