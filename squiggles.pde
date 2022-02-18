void setup() {
  size(800, 800);
  background(0);
}

PVector[][][] points;

float t = 0;
float tstep = 0.005;

void draw() {
  
  background(0);
  t += tstep;
  t %= 1.0;

  translate(width/2, height/2);
  scale(1.5);

  int circles = 4;
  int lines = 6;
  float dtheta = TAU / lines;
  float r =5;
  float l = 90;
  int arcs = 20;

  points = new PVector[circles][][];

  // for each concentric circle
  for (int c = 0; c < circles; c++) {
    points[c] = new PVector[lines][arcs];
    dtheta = TAU / lines;
    // for each spoke
    for (int i = 0; i < lines; i++) {
      float rprop = i / (float) lines;
      //float rdisp = noise(30*rprop + sin(TAU * t)) * 50;
      float rdisp = (i % 2) * 20;
      float theta = i * dtheta;      
      // for each point along the spoke
      for (int a = 0; a < arcs; a++) {
        
        float rad = rdisp + r + l * a / (float) arcs;
        
        float scl = 0.02;
        float mg = 0.4;
        
        
        //float bigN = map(noise(rad * scl / 10 + 50, theta + 30, t/2), 0, 1, -0.5, 0.5);
        //float smallN = map(noise(rad * scl + 50, theta + 20, t), 0, 1, -mg, mg);
        //float n = bigN + smallN;
        float n = sin(2 * TAU * (t - rad / 100 - (cos(rprop * 5))));
        n *= 1 - pow((rad / 500), 4);
        n /= 6;
        
        float x = rad * sin(theta + n/2);
        float y = rad * cos(theta + n/2);
        
        //x += pow(noise(scl * rad + theta), 2)  * mg;
        //y += pow(noise(scl * rad + 3 * theta + 40), 2) * mg;
        //x += noise(c + i + 0.01 * a) * 50;
        //y += noise(c + i + 0.01 * (a + 100)) * 50;
        
        points[c][i][a] = new PVector(x, y);
      }
    }
    lines *= 2;
    r += l;
  }
  
  for (int c = points.length - 2; c >= 0; c--) {
    int spokes = points[c].length;
    for (int i = spokes-1; i >= 0; i--) {
      int as = points[c][i].length;
      for (int a = as - 1; a >= 0; a--) {
        PVector BR = points[c][i][a];
        PVector BL = points[c][(i+1) % spokes][a];

        PVector TR, TL;
        if (a < as - 1) {
          TR = points[c][i][a+1];
          TL = points[c][(i+1) % spokes][a+1];
        } else {
          int nextSpokes = points[c+1].length;
          TR = points[c+1][(2 * i) % nextSpokes][0];
          TL = points[c+1][(2 * (i + 1)) % nextSpokes][0];
        }

        PVector mid = PVector.sub(TR, TL).mult(0.5);
        PVector perp = mid.copy().rotate(-HALF_PI).setMag((a / (float) as) * 50);
        mid.add(TL);
        mid.add(perp);
        float cmag = BL.mag() / 800;
        //println(cmag);
        
        color s = lerpColor(color(250, 0, 160),color(180, 0, 80), cmag);
        color f = lerpColor(color(250, 240, 250),color(200,190,200), (1-cmag));
        //f = color(red(f), green(f), blue(f), 100);
        //s = color(red(s), green(s), blue(s), 200);
        //stroke(color(209, 11, 200));
        //fill(color(255));
        //fill(color(255, 128, 213, 100));
        //stroke(s);
        //fill(f);
        beginShape();
        strokeWeight(1.3);
        curveVertex(BL.x, BL.y);
        curveVertex(BL.x, BL.y);
        strokeWeight(1.2);
        curveVertex(TL.x, TL.y);
        curveVertex(mid.x, mid.y);
        curveVertex(TR.x, TR.y);
        strokeWeight(1.3);
        curveVertex(BR.x, BR.y);
        curveVertex(BR.x, BR.y);
        endShape(CLOSE);
      }
    }
    //noLoop();
  }
}

//stroke((360 / circles) * c, 255, 255);
//stroke(240, 255, 100);
//int curves = 10;
//for (int b = 0; b < curves; b++) {
//  PVector startv = PVector.lerp(v0, v1, b * 1.0 / curves);
//  PVector endv = PVector.lerp(vv0, vv1, b * 1.0 / curves);

//  PVector startvv = PVector.lerp(v0, v1, (b+1) * 1.0 / curves);
//  PVector endvv = PVector.lerp(vv0, vv1, (b+1) * 1.0 / curves);

//  PVector m = PVector.lerp(startvv, endvv, 0.5);

//  bezier(startv.x, startv.y, m.x, m.y, m.x, m.y, endv.x, endv.y);
//}
//line(x0, y0, x1, y1);



//PVector TL = BL.copy().setMag(segLength).add(BL);
//PVector TR = BR.copy().setMag(segLength).add(BR);
//PVector TTL = TL.copy().setMag(segLength).add(TL);
//PVector TTR = TR.copy().setMag(segLength).add(TR);

//PVector lMid = PVector.lerp(TTL, TTR, 0.25);
//PVector rMid = PVector.lerp(TTL, TTR, 0.75);
//PVector mid = PVector.lerp(TTL, TTR, 0.5);

//PVector mid = PVector.lerp(
//  PVector.sub(TL, BL).add(TL),
//  PVector.sub(TR, BR).add(TR),
//  0.5);
