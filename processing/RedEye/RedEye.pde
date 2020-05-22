import com.hamoid.*;

float x_min = -TWO_PI;
float x_max = TWO_PI;
float y_min = -TWO_PI;
float y_max = TWO_PI;
float phi = 0;
float delta_phi = 0.1;
boolean isRecording = false;

VideoExport videoExport;

void setup () {
  size(400,400);
  frameRate(20);
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(20);  
}

void draw() {
  background(0);
  for (int x=0; x < width; x++) {
    for (int y=0; y < height; y++) {
      float a_x = map(x, 0, width, -TWO_PI, TWO_PI);
      float a_y = map(y, 0, width, -TWO_PI, TWO_PI);
      float ang = sqrt(a_x*a_x + a_y*a_y);
      float value = cos (ang + phi) * exp(-ang/3) + noise(a_x*0.75, a_y*0.75);
      float a_color = map(value, -1.0, 1.0, 0, 255);
      set(x, y, color(a_color, 0, 0));
    }
  }
  
  phi += delta_phi;
  
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
