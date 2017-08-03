class Icon {
  PImage[] dancingGuy = new PImage[2];
  boolean isDancing = false, hitted = false;
  PImage icon;
  int hitCounter = 0, step = 0, health = 3;
  PVector pos;
  Icon(float posX, float posY) {
    String path = dataPath("") + "/icons";
    String[] filenames = listFileNames(path);
    pos = new PVector(posX, posY);
    icon = loadIcon(filenames[floor(random(1, filenames.length - 1))]);
  }
  void update(Particle p) {
    float d = pos.dist(p.pos);
    if (d < 25) {
      health--;
    }
  }
  void show() {
    imageMode(CENTER);
    float [] angles = cam.getRotations();
    println(angles);
    pushMatrix();
    translate(pos.x, pos.y, icon.height / 2);
    rotateX(HALF_PI);
    rotate(PI);
    rotateY(radians(-30) + map(angles[2], -PI, PI, 0, TWO_PI));
    fill(255);
    image(icon, 0, 0);
    popMatrix();
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
  PImage loadIcon(String binToLoad) {
    String[] loadedIcon = loadStrings(dataPath("") + "/icons/" + binToLoad);
    int num = 50;
    PImage img = createImage(num, num, ARGB);
    img.loadPixels();
    for (int x = 0; x < img.width; x ++) {
      for (int y = 0; y < img.height; y ++) {
        int index = x + img.width * y;
        //if(int(loadedIcon[index]) == 0)img.pixels[index] = color(255, 255);
        img.pixels[index] = int(loadedIcon[index]) == 0 ? color(255, 255) : color(0, 0);
      }
    }
    img.updatePixels();
    return img;
  }
}