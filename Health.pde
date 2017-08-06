class Health {
  PImage[] emotions = new PImage[3];
  float speed = 2, x, y;
  int life = 30;
  private String fileName = "", directory = dataPath("")+"/emotions/";
  PVector pos, vel, acc, target;
  boolean showAnimation = true;
  Health(float x_, float y_) {
    x = x_;
    y = y_;
    //load the emtions
    String pathEmotions = dataPath("") + "/emotions";
    String[] filenames = listFileNames(pathEmotions);
    filenames = listFileNames(pathEmotions);
    for (int i = 0; i < emotions.length; i++)emotions[i] = loadIcon(pathEmotions, filenames[i]);

    pos = new PVector(x, y);
    target = new PVector(x, y - 300);
    vel = new PVector(0, 0);
  }

  void update() {    
    //showAnimation = true;
    PVector dir = PVector.sub(target, pos);
    dir.normalize();
    dir.mult(0.1);
    vel.add(dir);
    vel.limit(speed);
    pos.add(vel);
    life--;
    if (life <= 0) {
      pos = new PVector(x, y);
      showAnimation = false;
      life = 30;
    }
  }

  void show(int index) {
    if (showAnimation) {
      imageMode(CENTER);
      //for (int i = 0; i < emotions.length; i++)image(emotions[i], emotions[i].height / 2, emotions[i].width * i);
      pushMatrix();
      translate(pos.x, pos.y);
      image(emotions[index], 0, 0);
      println(index);
      popMatrix();
    }
  }
}