import com.hamoid.*;
import peasy.*;

float x0, y0, z0;
float x1, y1, z1;
float tmin = 0, tmax=TWO_PI;
int nb_points = 255;
float dt = (tmax - tmin) / nb_points;
int delta_size = 10;
boolean isRecording = false;

VideoExport videoExport;
PeasyCam camera;

float func_x(float t) {
  return map(2*cos(2*t)*sin(3*t)*cos(4*t), -2, 2, delta_size, 400 - delta_size);
}

float func_y(float t) {
  return map(2*sin(t)*sin(4*t)*sin(3*t), -2, 2, delta_size, 400 - delta_size);
}

float func_z(float t) {
  return map(2*cos(4*t)*sin(2*t)*sin(8*t), -2, 2, delta_size, 400 - delta_size);
}

void setup() {
  frameRate(20);
  size(400, 400, P3D);
  x0 = func_x(tmin);
  y0 = func_y(tmin);
  z0 = func_z(tmin);
  
  camera = new PeasyCam(this, width/2, height/2, 0, 800);
  camera.setMinimumDistance(50);
  camera.setMaximumDistance(1000);
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(20);  
}

void draw() {
  float color_start = frameCount % 255;
  float color_index = 0;
  lights();
  background(255);
  translate(width/2, height/2, 0);
  rotate(map(color_start, 0, 255, 0, TWO_PI));
  translate(-width/2, -height/2, 0);
  for(float t=tmin; t<=tmax; t+=dt) {
    color_index = map(t, tmin, tmax, 0, 255) + color_start;
    if (color_index > 255) {
      color_index = color_index % 255;
    }
    x1 = func_x(t);
    y1 = func_y(t);
    z1 = func_z(t);
    strokeWeight(8);
    stroke(255 - color_index, color_index / 2, color_index);
    line(x0, y0, z0, x1, y1, z1);
    x0 = x1;
    y0 = y1;
    z0 = z1;
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
