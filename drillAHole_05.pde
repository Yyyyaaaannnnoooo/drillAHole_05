import peasy.*;
PeasyCam cam;
Terrain terrain;
//float terrain[][];
int r = 200;
int count = 0;
color water = color(0, 150, 255), drilling = color(255), radWaste = color(0, 255, 0), 
      grass = color(10, 255, 50), land = color(180, 100, 10);
void settings() {
  size(1200, 900, P3D);
}
void setup() {
  background(0); 
  terrain = new Terrain();
  cam = new PeasyCam(this, 1000);
}
void draw() {
  lights();
  terrain.update();
  terrain.show();
  //worldRotation();
  //LAKE should have it's own stream//
  //also adriller with it's own stream//
  
  /////ADD ALL THIS TO TERRAIN/////
  facility(terrain.lakeX, terrain.lakeY - 300, terrain.drillDepth, 150, 350, 50, color(0), true);
  //facility(lakeX, lakeY - 300, drillDepth, 150, 350, 40, radWaste, true);
  facility(terrain.lakeX + 200, 120 / 2, 100 / 2, 200, 120, 100, drilling, true);
  //facility(terrain.lakeX, terrain.lakeY - 300, 100 / 2, 50, 50, 100, color(255, 0, 0), true);
  beginShape();
  noFill();
  stroke(155);
  strokeWeight(10);
  vertex(terrain.lakeX + 200, 120 / 2, 0);
  vertex(terrain.lakeX + 200, 120 / 2, terrain.drillDepth);
  vertex(terrain.lakeX - 50, 120 / 2, terrain.drillDepth);
  vertex(terrain.lakeX - 50, terrain.lakeY - 275 - (350 / 2), terrain.drillDepth);
  endShape();
  count++;
  //int posX = (int)map(mouseX, 0, width, 0, w);
  //int posY = (int)map(mouseY, 0, height, 0, h);
  //fill(255, 0, 0);
  //noStroke();
  //rect(posX, posY, cell, cell);
  surface.setTitle(str(frameRate));
}

void mouseClicked() {
  terrain.mouseClicked();
  //drillDeeper -= 50;
  //if (drillDeeper < drillDepth) {
  //  drillDeeper = drillDepth;
  //  bottom = true;
  //  drill.crossingStream(drill, waterStream);
  //}
}

void keyPressed() {
  //if (key == 'r')drillDeeper = -50;
  terrain.keyPressed();
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