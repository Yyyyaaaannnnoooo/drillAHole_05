class Facility {
  int x, y, z;
  float w, h, d, r;
  boolean IF, IM;
  color c;
  Facility(int xx, int yy, int zz, float ww, float hh, float dd, float rotation, color cc, boolean isFill, boolean isMonolith) {
    x = xx;
    y = yy;
    z = zz;
    w = ww;
    h = hh;
    d = dd;
    r = rotation;
    c = cc;
    IF = isFill;
    IM = isMonolith;
  }
  void update(int posX, int posY) {
    x = posX;
    y = posY;
  }
  void show() {
    if (IF) {
      stroke(0);
      fill(c);
    } else {
      noFill();
      strokeWeight(3);
      stroke(0);
    }
    if (IM)monolith();
    else cubicFacility();
  }
  ///a box facility
  void cubicFacility() {  
    pushMatrix();
    translate(x, y, z);
    box(w, h, d);
    popMatrix();
  }
  //a spike shaped monolith
  void monolith() {
    pushMatrix();
    translate(x, y, z);
    rotateZ(r);
    beginShape(TRIANGLE);
    vertex(0, (d / 2), 0);
    vertex(0, 0, h);
    vertex(0, - (d / 2), 0);
    vertex(0, - (d / 2), 0);
    vertex(0, 0, h);
    vertex(w, 0, 0);
    vertex(w, 0, 0);
    vertex(0, 0, h);
    vertex(0, (d / 2), 0);
    endShape();
    popMatrix();
  }
}