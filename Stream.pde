class Stream {
  ArrayList <PVector> stream;
  PVector[] crossStream;
  boolean isCrossed = false, ZA;
  color c;
  int step = 0, pxl = 8;
  float x, y, z;
  Stream (float x_, float y_, float z_, color col, boolean isZAxis, boolean hasAngle) {
    stream = new ArrayList <PVector>();
    x = x_;
    y = y_;
    z = z_;
    ZA = isZAxis;
    if (isZAxis == false) {
      for (float i = 0; i < y; i += 5) {
        stream.add(new PVector(x, i, z));
      }
    }
    if (hasAngle || ZA) {
      for (float i = z; i < 0; i += 5) {
        stream.add(new PVector(x, y, i));
      }
    }
    c = col;
    println(stream.size());
  }
  void update(int step_, int d) {
    step = step_;
    if (ZA && bottom == false) {
      stream = new ArrayList <PVector>(0);
      for (float i = d; i < 0; i += 5) {
        stream.add(new PVector(x, y, i));
      }
    }
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
      int index = step % crossStream.length;
      pushMatrix();
      translate(crossStream[index].x, crossStream[index].y, crossStream[index].z);
      noStroke();
      fill(radWaste);
      box(pxl);
      popMatrix();
    }
  }
  void crossingStream(Stream s1, Stream s2) {
    int s1End = 0, s2Begin = 0;
    println(s1.stream.size());
    for (int i = 0; i < s1.stream.size(); i++) {
      PVector p1 = s1.stream.get(i);
      for (int j = 0; j < s2.stream.size(); j++) {
        PVector p2 = s2.stream.get(j);
        float d = PVector.dist(p1, p2);
        if (d < 5) {
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