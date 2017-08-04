class Icon {
  PImage[] dancingGuy = new PImage[2];
  boolean dead = false, hitted = false;
  PImage icon;
  PImage emotion;
  int hitCounter = 0, step = 0, health = 3;
  private int deadCounter = 60;
  PVector pos;
  private String fileName = "", directory = dataPath("")+"/emotions/";;
  Icon(float posX, float posY) {
    //load icons
    String pathIcon = dataPath("") + "/icons";
    String[] filenames = listFileNames(pathIcon);
    icon = loadIcon(pathIcon, filenames[floor(random(1, filenames.length - 1))]);
    //load the emtions
    //String pathEmotions = dataPath("") + "/emotions";
    //filenames = listFileNames(pathEmotions);
    //emotions = loadIcon(pathEmotions, filenames[floor(random(1, filenames.length - 1))]);
    pos = new PVector(posX, posY);
  }
  void update() {
    if(health < 1)deadCounter--;
    if(deadCounter < 0)dead = true;
  }
  void show() {
    imageMode(CENTER);
    //get angle from peasy cam / needs correction
    float [] angles = cam.getRotations();
    //println(angles);
    pushMatrix();
    translate(pos.x, pos.y, icon.height / 2);
    rotateX(HALF_PI);
    rotate(PI);
    rotateY(radians(-30) + map(angles[2], -PI, PI, 0, TWO_PI));
    fill(255);
    image(icon, 0, 0);
    if(health == 3)fileName = "1_happy.txt";
    if(health == 2)fileName = "2_sad.txt";
    if(health == 1)fileName = "3_dead.txt";
    emotion = loadIcon(directory, fileName);
    stroke(radWaste);
    strokeWeight(1);
    line(0, 0, 0, -100);
    image(emotion, 0, -100);
    popMatrix();
    println(health);
  }

  // This function returns all the files in a directory as an array of Strings  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
  //function to load binary and return an image
  PImage loadIcon(String thePath, String binToLoad) {
    String[] loadedIcon = loadStrings(thePath +"/"+ binToLoad);
    int num = 50;
    PImage img = createImage(num, num, ARGB);
    img.loadPixels();
    for (int x = 0; x < img.width; x ++) {
      for (int y = 0; y < img.height; y ++) {
        int index = x + img.width * y;
        //if(int(loadedIcon[index]) == 0)img.pixels[index] = color(255, 255);
        img.pixels[index] = int(loadedIcon[index]) == 0 ? color(255, 255) : color(255, 0);
      }
    }
    img.updatePixels();
    return img;
  }
}