class Stream {
  ArrayList <PVector> stream = new ArrayList <PVector>();
  PVector[] crossStream;
  boolean isCrossed = false;
  color c;
  int step = 0, pxl = 8;
  Stream (float x, float y, float z, color col, boolean isZAxis, boolean hasAngle) {
    if (isZAxis == false) {
      for (float i = 0; i < y; i += 5) {
        stream.add(new PVector(x, i, z));
      }
    }
    if (hasAngle || isZAxis) {
      for (float i = z; i < 0; i += 5) {
        stream.add(new PVector(x, y, i));
      }
    }
    c = col;
  }
  void update() {
    step ++;
  }
  void show() {
    stroke(c);
    noFill();
    strokeWeight(5);
    beginShape();
    for (int i = 0; i < stream.size(); i++) {
      PVector p = stream.get(i);
      vertex(p.x, p.y, p.z);
    }
    endShape();
    PVector p = stream.get(step % stream.size());
    for ( int i = 0; i < 5; i++) {
      pushMatrix();
      translate(p.x, p.y, p.z);
      noStroke();
      fill(c);
      box(pxl);
      popMatrix();
    }
    if (isCrossed) {
      noFill();
      stroke(radWaste);
      strokeWeight(5);
      beginShape();
      for (int i = 0; i < crossStream.length; i++) {
        vertex(crossStream[i].x, crossStream[i].y, crossStream[i].z);
      }
      endShape();
    }
  }
  void crossingStream(Stream s1, Stream s2) {
    int s1End = 0, s2Begin = 0;
    for (int i = 0; i < s1.stream.size(); i++) {
      PVector p1 = s1.stream.get(i);
      for (int j = 0; j < s2.stream.size(); j++) {
        PVector p2 = s2.stream.get(j);
        if (p1.x == p2.x && p1.y == p2.y && p1.z == p2.z) {
          isCrossed = true;
          s1End = i;
          s2Begin = j;
        }
      }
    }
    int numVec = s1End + (s2.stream.size() - s2Begin);
    crossStream = new PVector[numVec];
    for (int i = 0; i < crossStream.length; i++) {
      if (i < s1End) {
        PVector p3 = s1.stream.get(i);
        crossStream[i] = new PVector(p3.x, p3.y, p3.z);
      } else {
        PVector p3 = s2.stream.get(i + (s2Begin - s1End));
        crossStream[i] = new PVector(p3.x, p3.y, p3.z);
      }
    }
  }
}