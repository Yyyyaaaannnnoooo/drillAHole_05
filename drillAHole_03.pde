Stream waterStream;
Stream drill;
Lake lake;
float terrain[][];
int cell = 10;
int r = 200;
int cols, rows, w = 800, h = 900, count = 0, drillDeeper = -50, drillDepth = -450;
float lakeX, lakeY;
float waterDepth = -300;
color water = color(0, 150, 255), drilling = color(255), radWaste = color(0, 255, 0);
boolean bottom = false;
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
  drill = new Stream(lakeX, lakeY - 300, -50, color(255, 0, 0), true, true);
  lake = new Lake (lakeX, lakeY, r);
}
void draw() {
  lights();
  //drill = new Stream(lakeX, lakeY - 300, drillDeeper, drilling, true, true);
  world();
  //worldRotation();
  lake.update(drill.pollution);
  lake.show();
  waterStream.update(count, 0);
  waterStream.show();
  drill.update(count, drillDeeper);
  drill.show(); 
  facility(lakeX, lakeY - 300, drillDepth, 150, 350, 50, color(0), true);
  //facility(lakeX, lakeY - 300, drillDepth, 150, 350, 40, radWaste, true);
  facility(lakeX + 200, 120 / 2, 100 / 2, 200, 120, 100, drilling, true);
  facility(lakeX, lakeY - 300, 100 / 2, 50, 50, 100, color(255, 0, 0), true);
  beginShape();
  noFill();
  stroke(155);
  strokeWeight(10);
  strokeCap(ROUND);
  vertex(lakeX + 200, 120 / 2, 0);
  vertex(lakeX + 200, 120 / 2, drillDepth);
  vertex(lakeX - 50, 120 / 2, drillDepth);
  vertex(lakeX - 50, lakeY - 275 - (350 / 2), drillDepth);
  endShape();
  count++;
  //float posX = map(mouseX, 0, width, 0, w);
  //float posY = map(mouseY, 0, height, 0, h);
  //fill(255, 0, 0);
  //noStroke();
  //rect(posX, posY, cell, cell);
  surface.setTitle(str(frameRate));
}

void mouseClicked() {
  drillDeeper -= 50;
  if (drillDeeper < drillDepth) {
    drillDeeper = drillDepth;
    bottom = true;
    drill.crossingStream(drill, waterStream);
  }
}

void keyPressed() {
  if (key == 'r')drillDeeper = -50;
}

void facility(float x, float y, float z, float ww, float hh, float dd, color c, boolean isFill) {
  pushMatrix();
  if (isFill) {
    stroke(255);
    fill(c);
  } else {
    noFill();
    stroke(255);
    strokeWeight(3);
  }
  translate(x, y, z);
  box(ww, hh, dd);
  popMatrix();
}

void worldRotation() {
  translate(width / 2, height / 2.3);
  rotateX(PI / 3);
  rotateZ( -PI / 3);
  translate(-w / 2, -h / 2);
}
void world() {
  color grass = color(10, 255, 50);
  color land = color(180, 100, 10);
  noFill();
  ortho();
  background(0);
  worldRotation();
  beginShape(QUAD);
  float inc = 0.1, yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      int index = x + cols * y;
      float steepness = map(index, 0, rows * cols, 15, 0);
      float n = map(noise(xOff, yOff), 0, 1, -steepness, steepness);
      strokeWeight(1);
      color c = lerpColor(land, grass, n);
      //noStroke();
      stroke(c);
      vertex(x * cell, y * cell, n);
      vertex(x * cell, (y + 1) * cell, n);
      vertex((x + 1) * cell, (y + 1) * cell, n);
      vertex((x + 1) * cell, y  * cell, n);
      xOff += inc;
    }
    yOff += inc;
  }
  endShape();
  //translate(0, 0, 3);
}