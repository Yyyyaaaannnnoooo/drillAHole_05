class Facility {
  int x, y, z;
  float w, h, d;
  boolean IF;
  color c;
  Facility(int xx, int yy, int zz, float ww, float hh, float dd, color cc, boolean isFill) {
    x = xx;
    y = yy;
    z = zz;
    w = ww;
    h = hh;
    d = dd;
    c = cc;
    IF = isFill;
  }
  void update(int posX, int posY) {
    x = posX;
    y = posY;
  }
  void show() {
    pushMatrix();
    if (IF) {
      stroke(255);
      fill(c);
    } else {
      noFill();
      stroke(255);
      strokeWeight(3);
    }
    translate(x, y, z);
    box(w, h, d);
    popMatrix();
  }
}