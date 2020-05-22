import com.hamoid.*;

color[] Colors;
float[] Coeffs;
float[] Radius;
float radius = 400.0/3.0 - 10;
float maxRadius = 400.0/3.0 - 10;
float minRadius = 20.0;
float coeff = 0.05;
float angle = 2;
float angleCoeff = 5;
boolean isRecording = false;

VideoExport videoExport;

void setup() {
  size(400,400);
  frameRate(10);
  
  Colors = new color[9];
  Coeffs = new float[9];
  Radius = new float[9];
  
  for(int i=0; i<9; i++) {
    Coeffs[i] = random(coeff, 2.0*coeff);
    Radius[i] = radius;
    Colors[i] = color(random(0,255),random(0,255),random(0,255));
  }
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(10);  
}

void draw() {
  background(255,255,0);
  stroke(127,127,0);
  strokeWeight(10);
  
  int index = 0;
  for(int i=0; i<3; i++) {
    for(int j=0; j<3; j++) {
      if (Radius[index] >= maxRadius) {
        Coeffs[index] = -Coeffs[index];
        Radius[index] = maxRadius;
      }
      
      if (Radius[index] <= minRadius) {
        Coeffs[index] = -Coeffs[index];
        Radius[index]= minRadius;
      }
      
      Radius[index] = Radius[index] * (1.0 + Coeffs[index]);
 
      fill(Colors[index]);
      circle((width/3.0)*i + width/6.0, (height/3.0)*j + height/6.0, Radius[index]);
      index = index + 1;
    }
  }
  
  stroke(0,0,0);
  noFill();
  angle = angle + angleCoeff;
  triangle(radius*cos(radians(angle))     + width/2.0, radius*sin(radians(angle))     + height / 2.0,
           radius*cos(radians(angle+120)) + width/2.0, radius*sin(radians(angle+120)) + height / 2.0,
           radius*cos(radians(angle-120)) + width/2.0, radius*sin(radians(angle-120)) + height / 2.0); 
  
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
