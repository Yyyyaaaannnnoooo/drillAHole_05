Stream waterStream;
Stream drill;
float terrain[][];
int cell = 20;
int cols, rows, w = 700, h = 900, count = 0;
float lakeX, lakeY;
float waterDepth = -300, drillDepth = -450 ;
color water = color(0, 150, 255), drilling = color(255), radWaste = color(0, 255, 0);
void settings() {
  size(1200, 900, P3D);
  cols = w / cell;
  rows = h / cell;
  terrain = new float[cols][rows];
}
void setup() {
  background(0);
  lakeX = w / 2;
  lakeY = h * 0.75;
  waterStream = new Stream(lakeX, lakeY, waterDepth, water, false, true);
  drill = new Stream(lakeX, lakeY - 300, drillDepth, drilling, true, true);
}
void draw() {
  world(lakeX, lakeY);
  waterStream.update();
  waterStream.show();
  drill.update();
  drill.show();
  drill.crossingStream(drill, waterStream);
  facility(lakeX, lakeY - 300, drillDepth, 150, 350, 50, drilling);
  facility(lakeX - 100, 120 / 2, 100 / 2, 200, 120, 100, drilling);
  count++;
  surface.setTitle(str(frameRate));
}
void facility(float x, float y, float z, float ww, float hh, float dd, color c) {
  pushMatrix();
  stroke(c);
  strokeWeight(3);
  translate(x, y, z);
  box(ww, hh, dd);
  popMatrix();
}
void lake(float posX, float posY, int radius) {
  float inc = 0.035;
  float xOff = 0;
  fill(water);
  beginShape();
  for (int angle = 0; angle < 200; angle ++) {
    float a = map(angle, 0, 200, 0, TWO_PI);
    float n = map(noise(xOff), 0, 1, 0.5, 1);
    float x = posX + (cos(a) * (radius + (radius / 5)) * n);
    float y = posY + (sin(a) * radius * n);
    vertex(x, y);
    xOff += inc;
  }
  endShape();
}
void worldRotation() {
  translate(width / 2, height / 2.3);
  rotateX(PI / 3);
  rotateZ( -PI / 3);
  translate(-w / 2, -h / 2);
}
void world(float lakePosX, float lakePosY) {
  noFill();
  ortho();
  background(0);
  worldRotation();
  beginShape(TRIANGLE_STRIP);
  float inc = 0.1, yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      int index = x + cols * y;
      float steepness = map(index, 0, rows * cols, 15, 0);
      float n = map(noise(xOff, yOff), 0, 1, -steepness, steepness);
      strokeWeight(.5);
      stroke(200, 155, 100);
      vertex(x * cell, y * cell, n);
      vertex(x * cell, (y + 1) * cell, n);
      xOff += inc;
    }
    yOff += inc;
  }
  endShape();
  int r = 200;
  translate(0, 0, 3);
  lake(lakePosX, lakePosY, r);
}