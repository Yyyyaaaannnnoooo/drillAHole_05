//this class defines the electrons rotating around the atom
class Electron {
  // Basic physics model (position, velocity, acceleration, mass)
  //PVector position;
  //PVector velocity;
  //PVector acceleration;
  //float mass, G = 1;
  //int count = 0;
  float w, h, rotY, rotZ, incZ, incY;
  PVector pos;
  PVector electron;
  PVector[] trail = new PVector[50];  
  Electron(float rotationY, float rotationZ, float x, float y, float z, float w_, float h_) {
    w = w_;
    h = h_;
    rotY = rotationY;
    rotZ = rotationZ;
    pos = new PVector(x, y, z);
    incZ = random(0.03, 0.001);
    incY = random(0.03, 0.001);
    //mass = m;
    //position = new PVector(x, y, z);
    //velocity = new PVector(1, 0);   // Arbitrary starting velocity
    //acceleration = new PVector(0, 0);
    //TX = targetX; 
    //TY = targetY;
    //TZ = targetZ;
  }
  //PVector attract(Electron e) {
  //  PVector target = new PVector(TX, TY, TZ);
  //  PVector force = PVector.sub(target, e.position);   // Calculate direction of force
  //  float d = force.mag();                            // Distance between objects
  //  d = constrain(d, 0, 2.0);                        // Limiting the distance to eliminate "extreme" results for very close or very far objects
  //  float strength = (G * mass * 2) / (d * d);      // Calculate gravitional force magnitude
  //  force.setMag(strength);                        // Get force vector --> magnitude * direction
  //  return force;
  //}
  // Newton's 2nd Law (F = M*A) applied
  //void applyForce(PVector force) {
  //  PVector f = PVector.div(force, mass);
  //  acceleration.add(f);
  //}

  // Our motion algorithm (aka Euler Integration)
  void update() {
    rotY += incY;
    rotZ += incZ;
    //velocity.add(acceleration); // Velocity changes according to acceleration
    //position.add(velocity);     // position changes according to velocity
    //acceleration.mult(.01);
    //trail[count % trail.length] = new PVector(position.x, position.y, position.z);
    count += .51;
  }

  // Draw the Electron
  void show() {
    color c = color(155, 0, 0);
    stroke(c);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(rotY);
    rotateZ(rotZ);
    noFill();
    beginShape();
    for ( float a = 0; a < TWO_PI; a += .7) {
      float x = cos(a) * w;
      float y = sin(a) * h;
      vertex(x, y);
    }
    endShape(CLOSE);
    float a = count % 360;
    float x = cos(radians(a)) * w;
    float y = sin(radians(a)) * h;
    translate(x, y);
    noStroke();
    fill(c);
    box(10);
    popMatrix();
    
    //pushMatrix();
    //translate(pos.x, pos.y, pos.z);
    //rotateY(rotY);
    //rotateZ(rotZ);
    //beginShape(POINTS);
    //for ( float angle = 0; angle < TWO_PI; angle += 0.01) {
    //  float xx = cos(angle) * w;
    //  float yy = sin(angle) * h;
    //  vertex(xx, yy);
    //}
    //endShape();
    //popMatrix();


    //pushMatrix();
    //translate(electron.x, electron.y, pos.z);
    //popMatrix();
    //noStroke(); 
    //pushMatrix(); 
    //noFill(); 
    //strokeWeight(2); 
    //stroke(155, 155, 0);
    //for (int i = 0; i < constrain(count, 0, trail.length); i++) {
    //  point(trail[i].x, trail[i].y, trail[i].z);
    //}
    //translate(position.x, position.y, position.z); 
    //noStroke(); 
    //color c = color(155, 0, 0); 
    //fill(c);
    //box(8);
    //popMatrix();
  }
}