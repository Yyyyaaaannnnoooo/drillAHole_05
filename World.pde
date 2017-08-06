class World {
  ArrayList <Icon> icon = new ArrayList <Icon>();
  ArrayList <Particle> ion = new ArrayList <Particle>();
  Particle [] p;
  Electron[] el;
  Paddle paddle;
  int originX, originY;
  int cols, rows, w = 800, h = displayHeight;
  int posX = 0, posY = 0, cell = 10;
  int drillDeeper = -50, drillDepth = -350, actualStream = 0, ionCount = 0;
  int iconNumber = 15;
  float wave = 0, waveCount, resetRotation = 1, rotX = PI / 3, rotZ = -PI / 3;
  boolean isDrilling = false;
  boolean bottom = false, reset = false;
  PVector position;
  //Check all the lake references
  World() {
    cols = w / cell;
    rows = h / cell;
    originX = w / 2;
    originY = int(h * 0.75);
    for (int i = 0; i < iconNumber; i++) {
      icon.add(new Icon(floor(random(cols)) * cell, floor(random(rows * 0.1, rows * 0.5)) * cell));
    }
    //float posX, float posY, float posZ, float trX, float trY, float trZ
    p = new Particle[30];
    for (int i = 0; i < p.length; i++) {
      float angle = map( i, 0, p.length, 0, TWO_PI);
      float x = originX + (cos(angle) * random(0, r / 5));
      float y = originY + (sin(angle) * random(0, r / 5));
      p[i] = new Particle(x, y, random(0, 200), originX, originY, 50, false);
    }
    //electrons
    el = new Electron[7];
    for (int i = 0; i < el.length; i++) {
      el[i] = new Electron(random(TWO_PI), random(TWO_PI), originX, originY, 50, 150, 50);
    }
    paddle = new Paddle();
  }

  void update() {
    for (Particle part : p) {
      part.update();
    }
    for (Electron e : el) {
      e.update();
    }
    paddle.update(mouseX);
    //animate the lake
    waveCount += 0.05;

    for (int i = ion.size() - 1; i >= 0; i--) {
      Particle p = ion.get(i);
      if (p.removeParticle) {
        ion.remove(i);
        //position = new PVector(ion.get(i).pos.x, ion.get(i).pos.y, ion.get(i).pos.z);
        ////p.startRemovalAnimation = true;
        ////p.removalAnimationRadius = 50;
        //p.removalAnimation(position, 50);
      }
    }

    for (int i = icon.size() - 1; i >= 0; i--) {
      Icon ic = icon.get(i);
      if (ic.dead)icon.remove(i);
    }
    if (icon.size() < iconNumber)icon.add(new Icon(floor(random(cols)) * cell, floor(random(rows * 0.1, rows * 0.5)) * cell));
    //radiation shooter
    Icon target = icon.get(floor(random(icon.size())));
    if (frameCount % 30 == 0 && ion.size() < 10) {
      if (target.health > 0)ion.add(new Particle(originX, originY, 0, target.pos.x, target.pos.y, target.pos.z, true));
    }
    for (Particle i : ion) {
      i.update();      
      i.hit(i, paddle, icon);
    }
    for (Icon i : icon) {
      i.update();
    }
    //Animation if something is hitted

    //if (drill != null) {
    //  Stream d = drill.get(actualStream);
    //  d.drillDrill(posX * cell, posY * cell, drillDeeper);
    //  //Stream d = drill.get(actualStream);
    //  if (bottom) {
    //    drill.add(new Stream(posX * cell, posY * cell, -50, drilling));        
    //    bottom = false;
    //    actualStream++;
    //    drillDeeper = -50;
    //  }
    //  if (drillDeeper <= drillDepth) {
    //    //drillDeeper = drillDepth;
    //    isDrilling = false;
    //    bottom = true;
    //    for (int i = 0; i < lake.waterStream.length; i++) {
    //      d.crossingStream(d, lake.waterStream[i]);
    //    }
    //  }
    //  for (Stream dd : drill) {
    //    dd.update();
    //    lake.update(dd.pollution);
    //  }
    //}

    //if (isDrilling)drillDeeper -= 50;
  }


  void show() { 
    // worldRotation();    
    beginShape(TRIANGLE); 
    float inc = 0.1, yOff = 0; 
    for (int y = 0; y < rows; y++) {
      float xOff = 0; 
      for (int x = 0; x < cols; x++) {
        int index = x + cols * y; 
        float steepness = map(index, 0, rows * cols, 25, 0); 
        float n = 0;//map(noise(xOff, yOff), 0, 1, 0, steepness); 
        float amp = noise(xOff, yOff) > 0.5 ? 0 : 1; 
        color c = lerpColor(land, grass, amp); 
        noStroke(); 
        //stroke(c);
        //drawing the lake and a wavy texture
        float d1 = dist(x, y, cols * 0.5, rows * 0.75); 
        float d2 = dist(x, y, cols * 0.35, rows * 0.8); 
        float d3 = dist(x, y, cols * 0.65, rows * 0.7); 
        if (d1 < 15 || d2 < 8 || d3 < 10) {
          fill(water); 
          wave = map(sin(waveCount), -1, 1, -0.5, 0.5);
        } else {
          fill(c); 
          wave = 1;
        }
        vertex(x * cell, y * cell, n * wave); 
        vertex(x * cell, (y + 1) * cell, n); 
        vertex((x + 1) * cell, (y + 1) * cell, n); 
        //vertex((x + 1) * cell, y  * cell, n);
        xOff += inc;
      }
      yOff += inc;
    }
    endShape(); 

    for (Particle part : p) {
      part.show();
    }
    for (Electron e : el) {
      e.show();
    }
    for (Particle i : ion)i.show(); 
    paddle.show(); 
    //if (drill != null) {
    //  for (Stream d : drill) {
    //    d.show();
    //  }
    //}
    for (Icon i : icon) {
      i.show();
    }
  }
  void worldRotation() {
    translate(width / 2, height / 2); // turn on if peasyCam is off
    rotateX(rotX); 
    rotateZ(rotZ); 
    translate(-w / 2, -h / 2); 

    if (rotX <= 0 || rotZ >= 0) {
      //reset = false;
      rotX = rotZ = 0; 
      gameStart = true;
    } else if (reset) {
      rotX -= radians(resetRotation); 
      rotZ += radians(resetRotation);
    }
  }


  void mouseClicked() {
    isDrilling = true; 
    //drillDeeper -= 50;
    //Stream d = drill.get(actualStream);
    //if (d.bottom) {
    //  drill.add(new Stream(posX * cell, posY * cell, -50, drilling));        
    //  d.bottom = false;
    //  actualStream++;
    //  drillDeeper = -50;
    //}
    //if (drillDeeper < drillDepth) {
    //  drillDeeper = drillDepth;
    //  d.bottom = true;
    //  for (int i = 0; i < lake.waterStream.length; i++) {
    //    d.crossingStream(d, lake.waterStream[i]);
    //  }
    //}
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