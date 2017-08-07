//import peasy.*;
//PeasyCam cam;
World world;
//float world[][];
int r = 200;
float BGcount = 0;
boolean gameStart = false;
color water = color(0, 150, 255), drilling = color(255), radWaste = color(0, 255, 0), 
  grass = color(10, 255, 50), land = color(180, 100, 10);
void settings() {
  size(1200, displayHeight, P3D);
}
void setup() {
  background(0); 
  world = new World();
  //cam = new PeasyCam(this, 1000);
}
void draw() {
  //lights();
 // noFill(); 
  ortho(); 
  background(0);
  //worldRotation();
  //LAKE should have it's own stream//
  //also adriller with it's own stream//
  if (gameStart) {
    world.update();
    //blinking red for drama!
    background(abs(sin(BGcount)) * 200, 0, 0);
  }
  world.worldRotation();
  world.show();
  /////ADD ALL THIS TO world/////
  facility(world.originX, world.originY - 300, world.drillDepth, 150, 350, 50, color(0), true);
  //facility(originX, originY - 300, drillDepth, 150, 350, 40, radWaste, true);
  facility(world.originX + 200, 120 / 2, 100 / 2, 200, 120, 100, drilling, true);
  //facility(world.originX, world.originY - 300, 100 / 2, 50, 50, 100, color(255, 0, 0), true);
  beginShape();
  noFill();
  stroke(155);
  strokeWeight(10);
  vertex(world.originX + 200, 120 / 2, 0);
  vertex(world.originX + 200, 120 / 2, world.drillDepth);
  vertex(world.originX - 50, 120 / 2, world.drillDepth);
  vertex(world.originX - 50, world.originY - 275 - (350 / 2), world.drillDepth);
  endShape();  
  BGcount += 0.05;
  //int posX = (int)map(mouseX, 0, width, 0, w);
  //int posY = (int)map(mouseY, 0, height, 0, h);
  //fill(255, 0, 0);
  //noStroke();
  //rect(posX, posY, cell, cell);
  surface.setTitle(str(frameRate));
}

void mouseClicked() {
  world.reset = true;
  world.mouseClicked();
  //drillDeeper -= 50;
  //if (drillDeeper < drillDepth) {
  //  drillDeeper = drillDepth;
  //  bottom = true;
  //  drill.crossingStream(drill, waterStream);
  //}
}

void keyPressed() {
  //if (key == 'r')drillDeeper = -50;
  world.keyPressed();
}

void facility(float x, float y, float z, float ww, float hh, float dd, color c, boolean isFill) {
  pushMatrix();
  strokeWeight(3);
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

void pixelCircle( float x, float y, color c) {
  pushMatrix();
  noStroke();
  fill(c);
  rectMode(CENTER);
  for ( int i = 0; i < 2; i++) {
    rect(x, y, 10 + (i * 10), 20 - (i * 10));
  }
  popMatrix();
}