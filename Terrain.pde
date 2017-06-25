class Terrain {
  Lake lake;
  Facility driller;  
  ArrayList <Stream> drill;
  float lakeX, lakeY;
  int cols, rows, w = 800, h = 900;
  int posX = 0, posY = 0;
  int drillDeeper = -50, drillDepth = -350, actualStream = 0;
  Terrain() {
    cols = w / cell;
    rows = h / cell;
    lakeX = w / 2;
    lakeY = h * 0.75;    
    lake = new Lake (lakeX, lakeY, r);
    driller = new Facility(0, 0, 100 / 2, 50, 50, 100, color(0, 255, 255), true);        
    drill = new ArrayList <Stream>();
    drill.add(new Stream(0, 0, -50, color(255, 0, 0), true, true));
  }
  void update() {
    driller.update(posX * cell, posY * cell);
    if (drill != null) {
      Stream dd = drill.get(actualStream);
      dd.drillDrill(posX * cell, posY * cell, drillDeeper);
      for (Stream d : drill) {
        d.update();
        lake.update(d.pollution);
      }
    }
  }
  void show() {
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
    lake.show();
    driller.show();    
    if (drill != null) {
      for (Stream d : drill) {
        d.show();
      }
    }
  }
  void worldRotation() {
    //translate(width / 2, height / 2.3); // turn on if peasyCam is off
    rotateX(PI / 3);
    rotateZ( -PI / 3);
    translate(-w / 2, -h / 2);
  }
  void mouseClicked() {
    drillDeeper -= 50;
    Stream d = drill.get(actualStream);
    if (d.bottom) {
      drill.add(new Stream(posX * cell, posY * cell, -50, color(255, 0, 0), true, true));        
      d.bottom = false;
      actualStream++;
      drillDeeper = -50;
    }
    if (drillDeeper < drillDepth) {
      drillDeeper = drillDepth;
      d.bottom = true;
      d.crossingStream(d, waterStream);
    }
  }
  void keyPressed() {
    ///inverted//
    if (key == CODED) {
      if (keyCode == UP) {
        posX++;
        if (posX > rows)posX = rows;
      }
      if (keyCode == DOWN) {
        posX--;
        if (posX < 0)posX = 0;
      }
      if (keyCode == LEFT) {
        posY--;
        if (posY < 0)posX = 0;
      }
      if (keyCode == RIGHT) {
        posY++;
        if (posY > cols)posY = cols;
      }
    }
  }
}