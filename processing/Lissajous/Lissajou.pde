import com.hamoid.*;

float x0, y0;
float x1, y1;
float tmin = 0, tmax=TWO_PI;
int nb_points = 255;
float dt = (tmax - tmin) / nb_points;
int delta_size = 10;
boolean isRecording = false;

VideoExport videoExport;

float func_x(float t) {
  return map(2*cos(2*t)*sin(3*t)*cos(4*t), -2, 2, delta_size, 400 - delta_size);
}

float func_y(float t) {
  return map(2*sin(t)*sin(4*t)*sin(3*t), -2, 2, delta_size, 400 - delta_size);
}

void setup() {
  frameRate(20);
  size(400, 400);
  x0 = func_x(tmin);
  y0 = func_y(tmin);
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(20);  
}

void draw() {
  float color_start = frameCount % 255;
  float color_index = 0;
  background(255);
  translate(width/2, height/2);
  rotate(map(color_start, 0, 255, 0, TWO_PI));
  translate(-width/2, -height/2);
  for(float t=tmin; t<=tmax; t+=dt) {
    color_index = map(t, tmin, tmax, 0, 255) + color_start;
    if (color_index > 255) {
      color_index = color_index % 255;
    }
    x1 = func_x(t);
    y1 = func_y(t);
    strokeWeight(8);
    stroke(255 - color_index, color_index / 2, color_index);
    line(x0, y0, x1, y1);
    x0 = x1;
    y0 = y1;
  }
  
  // Save a frame!
  if (isRecording) {
    videoExport.saveFrame();
  }
}

void keyReleased() {
  if (key=='r') {
    if (isRecording) {
      println("Stop recording");
      videoExport.endMovie();
      isRecording = false;
    } else {
      println("Start recording");
      videoExport.startMovie();
      isRecording = true;
    }
  }
}
