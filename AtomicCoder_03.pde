World world;
Audio a;
int r = 200;
float BGcount = 0, volume = -20.0, setVolume = volume;
boolean gameStart = false, blink = false, pause = false, playSound = true;
color water = color(0, 150, 255), white = color(255), black = color(0), drilling = color(255, 0, 0), radWaste = color(0, 255, 0), 
  grass = color(10, 255, 50), land = color(180, 100, 10);
void settings() {
  int theHeight = floor((displayHeight - 50) / 100) * 100;
  println(theHeight);
  size(1400, theHeight, P3D);
}
void setup() {
  background(0); 
  world = new World();
  a = new Audio();
  background = new Minim(this);
  BG = background.loadFile("DescenteInfinie_03.aiff", 2048);
}
void draw() {
  lights(); 
  ortho(); 
  background(0);  
  //blinking red for drama!
  if (blink)background(abs(sin(BGcount)) * 150, 0, 0);
  //draws the frame around the game
  frame();
  if (gameStart && !pause) {
    world.update();
  }
  world.worldRotation();
  world.drillinganimation();
  world.atomAnimation();
  world.show();
  BGcount += 0.05;
  surface.setTitle(str(frameRate));
  if (playSound) {
    BGSound();
    playSound = false;
  }
}

void BGSound() {  
  BG.setGain(volume);
  BG.loop();
}

void frame() {
  int cell = 20;
  int cols = width / cell;
  int rows = height / cell;
  stroke(255);
  strokeWeight(3);
  pushMatrix();
  rotateX(0);
  rotateZ(0);
  for (int i = 0; i < cols; i += 1) {
    line(i * cell, 0, (i + 1) * cell, cell);
    line(i * cell, height - cell, (i + 1) * cell, height);
  }
  for (int i = 0; i < rows; i += 1) {
    line(0, i * cell, cell, (i + 1) * cell);
    line(width - cell, i * cell, width, (i + 1) * cell);
  }
  popMatrix();
}

void keyPressed() {
  if (key == ' ') pause = !pause;
}