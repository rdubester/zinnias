void setup() {
  size(800, 800, P2D);
  background(0);
}

PVector[][][] points;

float t = 0;
float tstep = 0.005;

void draw() {
  
  loadPixels();
  float step = 0.01;
  float xoff = 0;
  for(int i = 0; i < width; i++){
    float yoff = 0;
    for(int j = 0; j < height; j++){
      float n = noise(xoff, yoff, 0.04*sin(TAU*t) + 0.1*cos(TAU*t));
      color cl = #FFFFFB;
      color cd = #0530F1;
      pixels[height * i + j] = lerpColor(cl, cd, n);
      yoff += step;
    }
    xoff += step ;
  }
  updatePixels();
  
  t += tstep;
  t %= 1.0;

  translate(width/2, height/2);
  scale(1.5);

  int circles = 4;
  int lines = 6;
  float dtheta = TAU / lines;
  float r = 20;
  float l = 60;
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
        float n = 1.4* sin(2 * TAU * (t - rad / 100 - (cos(rprop * 5))));
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
  
  color[] colors = {color(0), #EA0BA3, #6236CD, color(255)};
  stroke(0);

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
        PVector perp = mid.copy().rotate(-HALF_PI).setMag((a / (float) as) * 30);
        mid.add(TL);
        mid.add(perp);
        float cmag = BL.mag() / 300;
        //println(cmag);
        stroke(0);
        
        push();
        //translate(mid.x, mid.y);
        //PVector dir = PVector.mult(perp,2);
        //translate(dir.x, dir.y);
        //scale(1);

        color fl = lerpColors(colors, (float) a / arcs, false);
        //color fd = color(red(fl) - 10, green(fl) - 80, blue(fl) - 80);
        //color f = lerpColor(fl, fd, 0.8 * BL.x * BL.y / (width  * height));
        fill(fl);
        
        //fill(f);
        beginShape();
        stroke(fl);
        if(a == as - 1) {
          noStroke();
          noFill(); 
        }
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
        pop();
      }
    }
    //noLoop();
  }
  noStroke();
  for(int i = 0; i < 500; i++) {
    float x = 0.12*i*sin(137.5 * i);
    float y = 0.12*i*cos(137.5 * i);
    color[] bud_colors = {#CC7314, #FFE482, #FFA03B};
    stroke(#CC7314, 100);
    fill(lerpColors(bud_colors, i / 500.0, false));
    circle(x,y,10);
  }
  
  for(int i = 0; i < 50; i++) {
    float x = 0.33*i*sin(137.5 * i);
    float y = 0.33*i*cos(137.5 * i);
    color[] bud_colors = {#C08208, color(255), #C08208};
    fill(lerpColors(bud_colors, i / 50.0, false));
    circle(x,y,5);
  }
}
