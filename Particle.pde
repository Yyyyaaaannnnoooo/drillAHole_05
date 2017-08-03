class Particle {
  PVector pos, target, vel, acc;
  PVector[] trail = new PVector[5];
  float speed = 5, G = .4, mass = 5.0, sinFactor = 0, sinCounter = 0;
  int r = 7, ionizingFactor = 0, count = 0;
  color c;
  boolean removeParticle = false;
  PVector hitTarget = new PVector(-10, random(-200, height + 200));
  //position and target of the particle
  Particle(float posX, float posY, float posZ, float trX, float trY, float trZ) {
    c = color(0, 255, 255, 75);
    target = new PVector(trX, trY, trZ);
    pos = new PVector(posX, posY, posZ);
    vel = new PVector(0, 0, 0);
  }


  void update() {
    PVector dir = PVector.sub(target, pos);
    dir.normalize();
    dir.mult(.25);
    acc = dir;
    vel.add(acc);
    vel.limit(speed);
    pos.add(vel);
    ionizingFactor += 10;
    sinFactor += 0.07;
  }

  void show() {
    for (int i = 0; i < constrain(count, 0, trail.length); i++) {
      float sze = 10;
      pushMatrix();
      translate(trail[i].x, trail[i].y);
      color c2 = color(0, 255, 255, map(i, 0, trail.length, 255, 55));
      pixelCircle(0, 0, c2);
      popMatrix();
    }
    pushMatrix();
    pixelCircle(pos.x, pos.y, c);
    popMatrix();
  }
  //ionizing function the particle gets excited
  void ionizing(Particle p) {
    float alphaSin = map(sin(sinFactor), -1, 1, 150, 255);
    p.c = color(255 - ionizingFactor % 255, 0, 0, alphaSin);
  }
  //the ionized particle is shot to a target
  void radiation(Particle p, Paddle pad) {
    PVector dir = PVector.sub(hitTarget, p.pos);
    dir.normalize();
    dir.mult(1);
    p.acc = dir;
    p.vel.add(p.acc);
    p.vel.limit(5);
    p.pos.add(vel);
    trail[count % trail.length] = new PVector(p.pos.x, p.pos.y);
    count++;
    if (p.pos.x < pad.x + pad.w && p.pos.x > pad.x - pad.w && p.pos.y > pad.y - pad.h / 2 && p.pos.y < pad.y + pad.h / 2) {
      p.removeParticle = true;
      pad.h -= 5;
      //paddleHit = minim.loadFile("output_02.mp3");
      //paddleHit.play();
    }
  }
  //animation when the target has been hitted
  void targetIsHitted(PVector p, int radius) {
    noFill();
    stroke(0, 255, 0);
    strokeWeight(2);
    beginShape(POINTS);
    for (int i = 0; i < 8; i ++) {
      float angle = map ( i, 0, 8, 0, TWO_PI);
      float x = p.x + (cos(angle) * radius);
      float y = p.y + (sin(angle) * radius);
      vertex(x, y);
    }
    endShape();
  }
}