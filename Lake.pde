class Lake {
  Stream [] waterStream;
  int posX, posY;
  int radius;
  float waterDepth = -200;
  color c1, c2;
  Lake(int x, int y, int r) {
    waterStream = new Stream [10];
    for (int i = 0; i < waterStream.length; i++) {
      waterStream[i] = new Stream(int(random(0, x * 2)), int(random(0, 100)), round(-25 * random(i + 1))/*int(random(-120, -250))*/, x, y, 0, water);
    }
    posX = x;
    posY = y;
    radius = r;
  }
  void update(int step) {
    float amp = map(step, 0, 5, 0, 1);
    c1 = lerpColor(water, radWaste, amp);
    for (int i = 0; i < waterStream.length; i++) {
      waterStream[i].update();
    }
  }
  void show() {
    for (int i = 0; i < waterStream.length; i++) {
      waterStream[i].show();
    }
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
      //here to visually show the pollution of the lake
      //float amp = map(angle, 0, 200, 0, 1);
      //c2 = lerpColor(water, c1, amp);
      fill(water);
      vertex(x, y);
      xOff += inc;
    }
    endShape(CLOSE);
    popMatrix();
  }
}