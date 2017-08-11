World world;
Audio a;
int r = 200;
float BGcount = 0;
boolean gameStart = false, blink = false, pause = false, playSound = true;
color water = color(0, 150, 255), drilling = color(255), radWaste = color(0, 255, 0), 
  grass = color(10, 255, 50), land = color(180, 100, 10);
void settings() {
  size(1400, displayHeight - 50, P3D);
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
  // noFill(); 
  ortho(); 
  background(0);
  //blinking red for drama!
  if (blink)background(abs(sin(BGcount)) * 150, 0, 0);
  if (gameStart && !pause) {
    world.update();
  }
  world.worldRotation();
  world.drillinganimation();
  world.atomAnimation();
  world.show();
  BGcount += 0.05;
  surface.setTitle(str(frameRate));
}

void BGSound() {
  println("sound");
  BG.loop();
}

void keyPressed() {
  if (key == ' ') pause = !pause;
  world.keyPressed();
}