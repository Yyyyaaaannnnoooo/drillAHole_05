class Lake {
  float posX, posY;
  int radius;
  color c1, c2;
  Lake(float x, float y, int r) {
    posX = x;
    posY = y;
    radius = r;
  }
  void update(int step) {
    float amp = map(step, 0, 5, 0, 1);
    c1 = lerpColor(water, radWaste, amp);
  }
  void show() {
    float inc = 0.035;
    float xOff = 0;
    pushMatrix();
    translate(0, 0, 5);
    beginShape();
    for (int angle = 0; angle < 200; angle ++) {
      float a = map(angle, 0, 200, 0, TWO_PI);
      float n = map(noise(xOff), 0, 1, 0.5, 1);
      float x = posX + (cos(a) * (radius + (radius / 5)) * n);
      float y = posY + (sin(a) * radius * n);
      float amp = map(angle, 0, 200, 0, 1);
      c2 = lerpColor(water, c1, amp);
      fill(c2);
      vertex(x, y);
      xOff += inc;
    }
    endShape(CLOSE);
    popMatrix();
  }
}