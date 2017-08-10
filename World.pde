class World {
  ArrayList <Icon> icon = new ArrayList <Icon>();
  ArrayList <Particle> ion = new ArrayList <Particle>();
  ArrayList <Particle> p = new ArrayList <Particle>();
  ArrayList <Electron> el = new ArrayList <Electron>();
  Stream driller;
  Stream waterStream;
  Facility [] monoliths = new Facility[4];
  //Particle [] p;
  //Electron[] el;
  Paddle paddle;
  int originX, originY;
  int cols, rows, w = 800, h = displayHeight;
  int posX = 0, posY = 0, cell = 10;
  int drillDeeper = 0, drillDepth = -350, actualStream = 0, ionCount = 0, atomNum = 30;
  int iconNumber = 15;
  float wave = 0, waveCount = 0, resetRotation = 1, rotX = PI / 3, rotZ = -PI / 3;
  boolean isDrilling = false;
  boolean bottom = false, reset = false;
  PVector position;
  //Check all the lake references
  World() {
    cols = w / cell;
    rows = h / cell;
    originX = round(cols * 0.5);
    originY = round(rows * 0.75);
    for (int i = 0; i < iconNumber; i++) {
      icon.add(new Icon(floor(random(cols)) * cell, floor(random(rows * 0.1, rows * 0.5)) * cell));
    }
    //float posX, float posY, float posZ, float trX, float trY, float trZ
    for (int i = 0; i < monoliths.length; i++) {
      int w = 25;
      int r = cell * 7;
      float angle = map(i, 0, monoliths.length, 0, TWO_PI);
      int x = originX * cell + round(r * cos(angle));
      int y = w + r + round(r * sin(angle));
      monoliths[i] = new Facility(x, y, 0, w, 70, 35, angle, drilling, true, true);
    }
    paddle = new Paddle();
    ///Water stream and the driller
    waterStream = new Stream(originX * cell, 0, -200, originX * cell, originY * cell, 0, water, true);
  }

  void update() {
    paddle.update(constrain(mouseX, 0, cols * cell));
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
    if (frameCount % 30 == 0 && ion.size() < 10) {
      //insert here a for loop that shoots as many ions as
      //high the radition level is based on time 2017 – 12017
      Icon target = icon.get(floor(random(icon.size())));
      if (target.health > 0)ion.add(new Particle(originX * cell, originY * cell, 0, target.pos.x, target.pos.y, target.pos.z, true));
    }
    for (Particle i : ion) {
      i.update();      
      i.hit(i, paddle, icon);
    }
    for (Icon i : icon) {
      i.update();
    }
  }


  void show() { 
    // worldRotation();    
    terrain();
    paddle.show();
    for (Particle i : ion)i.show();
    if (gameStart)for (Icon i : icon)i.show();
    for (Facility f : monoliths)f.show();
  }
  ///the terrain of the world
  void terrain() {
    beginShape(TRIANGLE); 
    float inc = 0.1, yOff = 0; 
    for (int y = 0; y < rows; y++) {
      float xOff = 0; 
      for (int x = 0; x < cols; x++) {
        int index = x + cols * y; 
        float steepness = map(index, 0, rows * cols, 25, 0); 
        float n = map(noise(xOff, yOff), 0, 1, -10, 10); 
        float amp = noise(xOff, yOff) > 0.5 ? 0 : 1; 
        color c = lerpColor(land, grass, amp); 
        noStroke(); 
        //stroke(c);
        //drawing the lake and a wavy texture
        float d1 = dist(x, y, originX, originY); 
        float d2 = dist(x, y, cols * 0.35, rows * 0.8); 
        float d3 = dist(x, y, cols * 0.65, rows * 0.7); 
        if (d1 < 15 || d2 < 8 || d3 < 10) {
          fill(water); 
          wave = sin(waveCount) * n;
        } else {
          fill(c); 
          wave = 0;
        }
        vertex(x * cell, y * cell, wave); 
        vertex(x * cell, (y + 1) * cell, 0); 
        vertex((x + 1) * cell, (y + 1) * cell, 0); 
        //vertex((x + 1) * cell, y  * cell, n);
        xOff += inc;
      }
      yOff += inc;
    }
    endShape(); 
    //animate the lake
    waveCount += 0.05;
  }
  //set the world in perspective and back to topo view
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

  void drillinganimation() {
    int decrement = 1;
    stroke(drilling);
    strokeWeight(5);
    line(originX * cell, rows / 2 * cell, 0, originX * cell, rows / 2 * cell, drillDeeper);
    if (drillDeeper >= drillDepth) drillDeeper -= decrement;
    if (drillDeeper == drillDepth) {
      driller = new Stream(originX * cell, rows / 2 * cell, drillDepth, drilling, false);
      drillDeeper = drillDepth;
      //decrement = 0;
    }
    //driller and waterStream update
    waterStream.update();
    if (driller != null) {
      driller.crossingStream(driller, waterStream);
      driller.update();
    }
    //waterStream driller show
    waterStream.show();
    if (driller != null)driller.show();
  }

  void atomAnimation() {
    if (driller != null && driller.hittedWater && p.size() < atomNum) {
      blink = true;
      initAtom(5);
      //when the radWaste hits the water pond start the music
      if (playSound) {
        BGSound();
        playSound = false;
      }
    }
    if (p.size() == atomNum)reset = true;
    //update
    if (p != null)for (Particle part : p)  part.update();
    for (Electron e : el) e.update();
    //show
    if (p != null)for (Particle part : p)part.show();
    for (Electron e : el)e.show();
  }

  void initAtom(int numOfAtoms) {
    //add particles
    for (int i = 0; i < numOfAtoms; i++) {
      float angle = map( i, 0, numOfAtoms, 0, TWO_PI);
      float x = originX * cell + (cos(angle) * random(0, r / 5));
      float y = originY * cell + (sin(angle) * random(0, r / 5));
      p.add(new Particle(x, y, random(0, 200), originX * cell, originY * cell, 50, false));
    }
    //add electrons
    //electrons
    el.add(new Electron(random(TWO_PI), random(TWO_PI), originX * cell, originY * cell, 50, 150, 50));
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