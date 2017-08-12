class World {
  ArrayList <Icon> icon = new ArrayList <Icon>();
  ArrayList <Particle> ion = new ArrayList <Particle>();
  ArrayList <Particle> p = new ArrayList <Particle>();
  ArrayList <Electron> el = new ArrayList <Electron>();
  Stream driller;
  Stream waterStream;
  Facility [] monoliths = new Facility[4];
  Facility vault, radioactiveLager;
  Facility [] drillingMachine = new Facility[2];
  Paddle paddle;
  int originX, originY;
  int cols, rows, w = 800, h = height - 50;
  int posX = 0, posY = 0, cell = 10, posFacilityX, posFacilityY, drillerPosX, drillerPosY;
  int drillDeeper = 0, drillDepth = -350, atomNum = 30;
  int iconNumber = 15;
  float wave = 0, waveCount = 0, resetRotation = 1, rotX = PI / 3, rotZ = -PI / 3;
  boolean isDrilling = false;
  boolean bottom = false, reset = false;
  PVector position;
  int iconCell = 50, iconCols = (w - (iconCell * 2)) / iconCell, iconRows = (h / 2) / iconCell;
  int topGutter = cell * 5; //the space from the top of the world
  int leftGutter = iconCell;
  World() {
    cols = w / cell;
    rows = h / cell;
    originX = round(cols * 0.5);
    originY = round(rows * 0.80);
    drillerPosX = originX * cell;
    drillerPosY = (rows / 2) * cell;
    //float posX, float posY, float posZ, float trX, float trY, float trZ
    //the monoliths sorrounding the vault
    posFacilityX = (originX + 20) * cell;
    int w = 5 * cell;
    int r = 7 * cell;
    posFacilityY = w + r;
    for (int i = 0; i < monoliths.length; i++) {
      float angle = map(i, 0, monoliths.length, 0, TWO_PI);
      int x = posFacilityX + round(r * cos(angle));
      int y = posFacilityY + round(r * sin(angle));
      monoliths[i] = new Facility(x, y, 0, w, 90, 35, angle, white, black, true, true);
    }
    //the vault
    vault = new Facility (posFacilityX, posFacilityY, 15, w, 45, 30, 0, black, radWaste, true, false);
    radioactiveLager = new Facility(originX * cell, ((originY - 30) * cell), drillDepth, 150, 350, 50, 0, black, radWaste, true, false);
    //the driller
    for (int i = 0; i < drillingMachine.length; i++)drillingMachine[i] = new Facility(drillerPosX, drillerPosY, 0, 25, 120, 50, i * PI, black, drilling, true, true);
    //adds ome spacing between the icons
    int index = 0;
    while (index < iconNumber) {
      int x = leftGutter + floor(random(iconCols)) * iconCell;
      int y = topGutter + floor(random(iconRows)) * iconCell;
      float d1 = dist(x, y, posFacilityX, posFacilityY); //check distance between icon and vault
      float d2 = dist(x, y, drillerPosX, drillerPosY);//check distance between driller and icon
        if (icon.size() >= 1) {
        while (checkPos(x, y, icon) && d1 > r * 1.5 && d2 > 50) {
          icon.add(new Icon(x, y));
          index++;
        }
      } else {
        icon.add(new Icon(x, y));
        index++;
      }
    }
    ///Water stream
    waterStream = new Stream(originX * cell, 0, -200, originX * cell, originY * cell, 0, water, true);
    paddle = new Paddle(floor(rows * 0.6) * cell);
  }
  //this function checks if a new icon overlaps any previous
  private boolean checkPos(int xx, int yy, ArrayList <Icon> obj) {
    int boolCounter = 0;
    for (int i = 0; i < obj.size(); i++) {
      Icon comparator = obj.get(i);
      float d = dist(xx, yy, comparator.pos.x, comparator.pos.y);
      if (d < 20)boolCounter ++;
    }
    if(boolCounter > 0)return false;
    else return true;
  }

  void update() {
    paddle.update(constrain(mouseX, 0, cols * cell));
    for (int i = ion.size() - 1; i >= 0; i--) {
      Particle p = ion.get(i);
      if (p.removeParticle) {
        ion.remove(i);
      }
    }

    for (int i = icon.size() - 1; i >= 0; i--) {
      Icon ic = icon.get(i);
      if (ic.dead)icon.remove(i);
    }
    //while loop?
    while (icon.size() < iconNumber) {
      int x = leftGutter + floor(random(iconCols)) * iconCell;
      int y = topGutter + floor(random(iconRows)) * iconCell;
      float d1 = dist(x, y, posFacilityX, posFacilityY); //check distance between icon and vault
      float d2 = dist(x, y, drillerPosX, drillerPosY);//check distance between driller and icon
      while (checkPos(x, y, icon) && d1 > r * 1.5 && d2 > 50)icon.add(new Icon(x, y));
    }
    //if (icon.size() < iconNumber)icon.add(new Icon(floor(random(cols)) * cell, floor(random(rows * 0.1, rows * 0.5)) * cell));
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
    if (gameStart)paddle.show();
    for (Particle i : ion)i.show();
    if (gameStart)for (Icon i : icon)i.show();
    for (Facility f : monoliths)f.show();
    for (Facility f : drillingMachine)f.show();
    vault.show();
    radioactiveLager.show();
    facilityConnection(vault, radioactiveLager, radWaste);
  }
  ///the terrain of the world
  void terrain() {
    beginShape(TRIANGLE); 
    float inc = 0.1, yOff = 0; 
    for (int y = 0; y < rows; y++) {
      float xOff = 0; 
      for (int x = 0; x < cols; x++) {
        int index = x + cols * y; 
        float n = map(noise(xOff, yOff), 0, 1, -10, 10); 
        float amp = noise(xOff, yOff) > 0.5 ? 0 : 1; 
        color c = lerpColor(land, grass, amp); 
        noStroke(); 
        //stroke(c);
        //drawing the lake and a wavy texture
        float d1 = dist(x, y, originX, originY); 
        float d2 = dist(x, y, cols * 0.35, rows * 0.82); 
        float d3 = dist(x, y, cols * 0.65, rows * 0.79); 
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
  //the connection bewtween the monolith on the surface and the lager underneath
  void facilityConnection(Facility f1, Facility f2, color c) {
    noFill();
    stroke(c);
    strokeWeight(7);
    pushMatrix();
    beginShape();
    vertex(f1.x, f1.y, f1.z);
    vertex(f1.x, f1.y, f2.z);
    vertex(f2.x, f1.y, f2.z);
    vertex(f2.x, f2.y, f2.z);
    endShape();
    popMatrix();
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
    int decrement = 2;
    stroke(drilling);
    strokeWeight(5);
    line(drillerPosX, drillerPosY, 0, originX * cell, rows / 2 * cell, drillDeeper);
    if (drillDeeper >= drillDepth) drillDeeper -= decrement;
    if (drillDeeper == drillDepth) {
      driller = new Stream(drillerPosX, drillerPosY, drillDepth, drilling, false);
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
      //when the radWaste hits the water rise the volume
      float inc = (abs(volume) + 10) / (atomNum / 5);
      //println(inc);
      setVolume += inc;      
      BG.shiftGain(BG.getGain(), setVolume, 500);
      //println(BG.getGain());
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
}