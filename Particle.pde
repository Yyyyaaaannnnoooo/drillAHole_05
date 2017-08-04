class Particle {
  PVector pos, target, vel, acc;
  PVector[] trail;
  float speed = 5, G = 0.4, mass = 5.0, sinFactor = 0, sinCounter = 0;
  int r = 7, ionizingFactor = 0, count = 0;
  color c;
  boolean removeParticle = false, t;
  PVector hitTarget = new PVector(-10, random(-200, height + 200));
  //position and target of the particle
  Particle(float posX, float posY, float posZ, float trX, float trY, float trZ, boolean hasTrail) {
    c = color(0, 255, 0, 175);
    t = hasTrail;
    target = new PVector(trX, trY, trZ);
    pos = new PVector(posX, posY, posZ);
    vel = new PVector(0, 0, 0);
    trail = new PVector[25];
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
    trail[count % trail.length] = new PVector(pos.x, pos.y, pos.z);
    count++;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(c);
    noStroke();
    box(15);
    popMatrix();
    if (t) {
      pushMatrix();
      beginShape();
      for (int i = 0; i < trail.length; i++) {
        strokeWeight(3);
        stroke(255, 0, 0);
        if (trail[i] != null)vertex(trail[i].x, trail[i].y, trail[i].z);
        //box(15);
      }
      endShape();
      popMatrix();
    }
  }
  //the ionized particle is hits a target
  void hit(Particle p, Paddle pad, ArrayList <Icon> i) {
    for (Icon theTarget : i) {
      float d = PVector.dist(theTarget.pos, p.pos);
      if (d < 5) {
        p.removeParticle = true;
        theTarget.health--;
      }
    }

    if (p.pos.x < pad.x + pad.w && p.pos.x > pad.x - pad.w && p.pos.y > pad.y - pad.h / 2 && p.pos.y < pad.y + pad.h / 2) {
      p.removeParticle = true;
      pad.w -= 5;
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