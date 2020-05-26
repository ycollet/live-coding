// https : // opengameart.org/content/low-poly-biplane
 
import peasy.*;
import com.hamoid.*;
 
PeasyCam camera;
PShape s0, s;
boolean isRecording = false;

VideoExport videoExport;
 
void setup() {
  size(1400, 900, P3D);
  frameRate(10);
  // The file must be in the data folder
  // of the current sketch to load successfully
  s0 = loadShape("biplane.obj"); 
  s = loadShape("biplane.obj"); 
 
  // apply its texture 
  PImage img1 = loadImage("diffuse_512.png"); 
  s0.setTexture(img1);
  s.setTexture(img1);
 
  s0.scale(20);
  s.scale(20);
  
  camera = new PeasyCam(this, 0, 0, 0, 50);
  
  background(0);
  frameRate(20);
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(20);  
}
 
void draw() {
  background(0);
  ambientLight(255,255,255);
  float amp = 0.1 * (1 + sin(TWO_PI * frameCount / 100.0));
  for(int j = 0; j < s.getChildCount(); j++) {
    for (int i = 0; i < s.getChild(j).getVertexCount(); i++) {
      PVector v = s0.getChild(j).getVertex(i);
      v.x += random(-amp, amp);
      v.y += random(-amp, amp);
      s.getChild(j).setVertex(i, v);
    }
  }

  shape(s, 0, 0);
  
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
