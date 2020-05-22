import com.hamoid.*;

float shift = 0.0;
float delta_shift = 0.1;
boolean isRecording = false;

VideoExport videoExport;

void setup() {
  size(400, 400);
  frameRate(20);
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(20);  
}

void draw () {
  for(int x=0; x<width; x++) {
    for(int y=0; y<height; y++) {
      float value = sin(TWO_PI * 0.025 * shift);
      float a_coeff = map(value, -1.0, 1.0, 0.5, 1.0);
      float a_color = map(noise(x*0.02*a_coeff+shift, y*0.02*a_coeff+shift), 0.0, 1.0, 0, 255);
      float a_color_2 = map(value, -1.0, 1.0, 0, 155);
      set(x, y, color(a_color, 0, a_color_2));
    }
  }
  
  shift += delta_shift;
  
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
