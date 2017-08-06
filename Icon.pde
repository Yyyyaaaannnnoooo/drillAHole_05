class Icon {
  Health h;
  PImage[] dancingGuy = new PImage[2];
  boolean dead = false, hitted = false, updateHealth = false;
  ;
  PImage icon;
  int hitCounter = 0, step = 0, health = 4, prevHealth = health;
  private int deadCounter = 60;
  PVector pos;
  private String fileName = "", directory = dataPath("")+"/emotions/";
  Icon(float posX, float posY) {
    h = new Health(posX / 10, posY / 10);
    //load icons
    String pathIcon = dataPath("") + "/icons";
    String[] filenames = listFileNames(pathIcon);
    icon = loadIcon(pathIcon, filenames[floor(random(1, filenames.length - 1))]);
    pos = new PVector(posX, posY);
  }
  void update() {
    //make the icon disappear
    if (health < 1)deadCounter--;
    if (deadCounter < 0)dead = true;
    //reset the health animation
    if (prevHealth != health) {
      h.showAnimation = true;
      //updateHealth = true;
      prevHealth = health;
    }
    //if (updateHealth) h.update();
  }
  void show() {
    imageMode(CENTER);
    //get angle from peasy cam / needs correction
    //float [] angles = cam.getRotations();
    //println(angles);
    pushMatrix();
    translate(pos.x, pos.y, icon.height / 2);
    //rotateX(HALF_PI);
    //rotate(PI);
    //rotateY(radians(-30) + map(angles[2], -PI, PI, 0, TWO_PI));
    fill(255);
    image(icon, 0, 0);
    if (health == 3) {      
      println("happy");
      //h.showAnimation = true;
      h.update();
      h.show(0);
    }
    if (health == 2) {
      println("sad");
      //h.showAnimation = true;
      h.update();
      h.show(1);
    }
    if (health <= 1) {
      println("dead");
      //h.showAnimation = true;
      h.update();
      h.show(2);
    }
    //emotion = loadIcon(directory, fileName);
    //stroke(radWaste);
    //strokeWeight(1);
    //line(0, 0, 0, -100);
    //image(emotion, 0, -100);
    popMatrix();
    //println(health);
  }
}