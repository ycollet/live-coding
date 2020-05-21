import com.hamoid.*;

final int NB_CIRCLES = 20;
float deltaCircle;
float sizeCircle;
float x_pos = 100;
float y_pos = 100;
float delta_x = getRand();
float delta_y = getRand();
float diam_pos = 100;
VideoExport videoExport;

void setup() {
  size(400, 400);
  frameRate(10);
  deltaCircle = width / NB_CIRCLES;
  sizeCircle = 0.9 * deltaCircle;
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(10);  
  videoExport.startMovie();
}

void draw() {
  background(127);
  move_circle();
  for(int i=0; i<NB_CIRCLES+1; i++) {
    for(int j=0; j<NB_CIRCLES+1; j++) {
      float x_tmp = i*deltaCircle;
      float y_tmp = j*deltaCircle;
      noStroke();
      float diameter = circle_distance(x_tmp, y_tmp);
      if (i==0 || j==0 || i==NB_CIRCLES || j==NB_CIRCLES) fill(0);
      circle(x_tmp, y_tmp, diameter);
    }
  }
  
  // Save a frame!
  videoExport.saveFrame();
}

float circle_distance(float x, float y) {
  float res = sqrt(pow(x - x_pos, 2) + pow(y - y_pos, 2));
  if (res < diam_pos / 2.0) {
    fill(255, 0, 0);
    return map(res, 0, diam_pos/2, 0, sizeCircle);
  } else {
    fill(255);
    return sizeCircle;
  }
}

int sign(float f) {
  if (f==0) return (0);
  return (int(f/abs(f)));
}

float getRand() {
  return random(5, 15);
}

void move_circle() {
  float bound = diam_pos / 2.0;
  x_pos = x_pos + delta_x;
  y_pos = y_pos + delta_y;
  
  if (x_pos < bound) {
    x_pos = bound;
    delta_x = - sign(delta_x)*getRand();
  }
  
  if (y_pos < bound) {
    y_pos = bound;
    delta_y = - sign(delta_y)*getRand();
  }
  
  if (x_pos > width - bound) {
    x_pos = width - bound;
    delta_x = - sign(delta_x)*getRand();
  }
  
  if (y_pos > height - bound) {
    y_pos = height - bound;
    delta_y = - sign(delta_y)*getRand();
  }
}
