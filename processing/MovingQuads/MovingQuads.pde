import oscP5.*;
import netP5.*;

final int nbQuads = 9; // 3 x 3
float[][] quadList;
float[][] quadDelta;
float[][] quadLimit;
int[][]   quadColor;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400, 400);
  frameRate(10);
  
  quadList  = new float[nbQuads][8];
  quadDelta = new float[nbQuads][8];
  quadLimit = new float[nbQuads][4];
  quadColor = new int[nbQuads][3];
  
  oscP5 = new OscP5(this,8060);
  myRemoteLocation = new NetAddress("127.0.0.1",8060);
  
  generate_init_quads();
}

void draw() {
  background(0);
  
  for(int i=0; i<nbQuads; i++) {
    move_quad();
    
    fill(quadColor[i][0],quadColor[i][1],quadColor[i][2]);
    quad(quadList[i][0], quadList[i][1], quadList[i][2], quadList[i][3], quadList[i][4], quadList[i][5], quadList[i][6], quadList[i][7]);
  }
}

void generate_init_quads() {
  float step_x = width / (2 * 3 + 1);
  float step_y = height / (2 * 3 + 1);
  float limit_x = width / 3;
  float limit_y = height / 3;
  float x1, y1, x2, y2;
  
  // Initialize speed
  for(int i=0; i<nbQuads; i++) {
    for(int j=0; j<8; j++) {
      quadDelta[i][j] = random(2,5);
    }
  }
  
  // Initialize colors
  for(int i=0; i<nbQuads; i++) {
    for(int j=0; j<3; j++) {
      //quadColor[i][j] = int(random(0,255));
      quadColor[i][j] = 127;
    }
  }
  
  // Initialize quads as equally spaced rectangles
  for(int i=0; i<3; i++) {
    for(int j=0; j<3; j++) {
      x1 = (2*j+1)*step_x;
      x2 = (2*j+2)*step_x;
      y1 = (2*i+1)*step_y;
      y2 = (2*i+2)*step_y;
      quadList[3*i+j][0] = x1; quadList[3*i+j][1] = y1;
      quadList[3*i+j][2] = x2; quadList[3*i+j][3] = y1;
      quadList[3*i+j][4] = x2; quadList[3*i+j][5] = y2;
      quadList[3*i+j][6] = x1; quadList[3*i+j][7] = y2;
      quadLimit[3*i+j][0] = i*limit_x;     // xmin
      quadLimit[3*i+j][1] = (i+1)*limit_x; // xmax
      quadLimit[3*i+j][2] = j*limit_y;     // ymin
      quadLimit[3*i+j][3] = (j+1)*limit_y; // ymax
    }
  }
}

void move_quad() {
  for(int i=0; i<nbQuads; i++) {
    for(int j=0; j<8; j++) {
      quadList[i][j] += quadDelta[i][j];
    }
    
    for(int j=0; j<4; j++) {
      // x
      if (quadList[i][2*j] < quadLimit[i][0]) {
        quadList[i][2*j]  = quadLimit[i][0];
        quadDelta[i][2*j] = - quadDelta[i][2*j];
      }
      
      if (quadList[i][2*j] > quadLimit[i][1]) {
        quadList[i][2*j]  = quadLimit[i][1];
        quadDelta[i][2*j] = - quadDelta[i][2*j];
      }
      
      // y
      if (quadList[i][2*j+1] < quadLimit[i][2]) {
        quadList[i][2*j+1]  = quadLimit[i][2];
        quadDelta[i][2*j+1] = - quadDelta[i][2*j+1];
      }
      
      if (quadList[i][2*j+1] > quadLimit[i][3]) {
        quadList[i][2*j+1]  = quadLimit[i][3];
        quadDelta[i][2*j+1] = - quadDelta[i][2*j+1];
      }
    }
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/processing/Q1")==true) {
    println("OSC: /processing/Q1 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    println("OSC: message /processing/Q1 ");
    theOscMessage.printData();
    quadColor[0][0] = theOscMessage.get(0).intValue();
    quadColor[0][1] = theOscMessage.get(1).intValue();
    quadColor[0][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q2")==true) {
    println("OSC: /processing/Q2 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[1][0] = theOscMessage.get(0).intValue();
    quadColor[1][1] = theOscMessage.get(1).intValue();
    quadColor[1][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q3")==true) {
    println("OSC: /processing/Q3 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[2][0] = theOscMessage.get(0).intValue();
    quadColor[2][1] = theOscMessage.get(1).intValue();
    quadColor[2][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q4")==true) {
    println("OSC: /processing/Q4 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[3][0] = theOscMessage.get(0).intValue();
    quadColor[3][1] = theOscMessage.get(1).intValue();
    quadColor[3][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q5")==true) {
    println("OSC: /processing/Q5 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[4][0] = theOscMessage.get(0).intValue();
    quadColor[4][1] = theOscMessage.get(1).intValue();
    quadColor[4][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q6")==true) {
    println("OSC: /processing/Q6 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[5][0] = theOscMessage.get(0).intValue();
    quadColor[5][1] = theOscMessage.get(1).intValue();
    quadColor[5][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q7")==true) {
    println("OSC: /processing/Q7 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[6][0] = theOscMessage.get(0).intValue();
    quadColor[6][1] = theOscMessage.get(1).intValue();
    quadColor[6][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q8")==true) {
    println("OSC: /processing/Q8 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[7][0] = theOscMessage.get(0).intValue();
    quadColor[7][1] = theOscMessage.get(1).intValue();
    quadColor[7][2] = theOscMessage.get(2).intValue();
  }
  if (theOscMessage.checkAddrPattern("/processing/Q9")==true) {
    println("OSC: /processing/Q9 received - " + theOscMessage.get(0).intValue() + " " + theOscMessage.get(1).intValue() + " " + theOscMessage.get(2).intValue());
    quadColor[8][0] = theOscMessage.get(0).intValue();
    quadColor[8][1] = theOscMessage.get(1).intValue();
    quadColor[8][2] = theOscMessage.get(2).intValue();
  }
}

boolean inQuad(float[] P, float x_test, float y_test) {
  float S1, S2, S3, S4;
  float d_a, d_b, d_c, S;
  // x1   y1   x2   y2   x3   y3   x4   y4
  // P[0] P[1] P[2] P[3] P{4] P[5] P[6] P[7]
  //   surf  = 0.5 *   |  (x1   - x3)   * (y2   - y4)|   +  |  (x2   - x4)   * (y1   - y3)|
  float surf = 0.5 * (abs((P[0] - P[4]) * (P[3] - P[7])) + abs((P[2] - P[6]) * (P[1] - P[4])));
  // Compute triangle surface via Heron formula
  d_a = dist(x_test, y_test, P[0], P[1]);
  d_b = dist(P[0], P[1], P[2], P[3]);
  d_c = dist(P[2], P[3], x_test, y_test);
  S = 0.5 * (d_a + d_b + d_c);
  S1 = sqrt(S * (S - d_a) * (S - d_b) * (S - d_c));

  d_a = dist(x_test, y_test, P[2], P[3]);
  d_b = dist(P[2], P[3], P[4], P[5]);
  d_c = dist(P[4], P[5], x_test, y_test);
  S = 0.5 * (d_a + d_b + d_c);
  S2 = sqrt(S * (S - d_a) * (S - d_b) * (S - d_c));

  d_a = dist(x_test, y_test, P[4], P[5]);
  d_b = dist(P[4], P[5], P[6], P[7]);
  d_c = dist(P[6], P[7], x_test, y_test);
  S = 0.5 * (d_a + d_b + d_c);
  S3 = sqrt(S * (S - d_a) * (S - d_b) * (S - d_c));

  d_a = dist(x_test, y_test, P[6], P[7]);
  d_b = dist(P[6], P[7], P[0], P[1]);
  d_c = dist(P[0], P[1], x_test, y_test);
  S = 0.5 * (d_a + d_b + d_c);
  S4 = sqrt(S * (S - d_a) * (S - d_b) * (S - d_c));

  boolean result = (abs(surf - (S1 + S2 + S3 + S4)) < 1e-1);
  
  return result;
}
