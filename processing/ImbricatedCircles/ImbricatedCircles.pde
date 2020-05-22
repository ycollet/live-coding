import com.hamoid.*;

float[] radiusList;
int nbRadius = 10;
float coeff = 10;
boolean isRecording = false;

VideoExport videoExport;

void initializeRadius() {
  radiusList[0] = 10;
  radiusList[1] = width;
  for(int i=2; i<nbRadius; i++) {
    radiusList[i] = random(0,width);
  }
  radiusList = reverse(sort(radiusList));
}

void setup () {
  size(600,600);
  frameRate(10);
  radiusList = new float[nbRadius];
  
  initializeRadius();
  
  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(10);  
}

void draw() {
  background(127);

  for(int i=0; i<nbRadius; i++) {
    //if (i%2==0) fill(0);
    //else fill(255);
    fill(random(255),random(255),random(255));
    
    circle(width/2, height/2, radiusList[i]);
  }
  
  for(int i=1; i<nbRadius-1; i++) {
    float noise1 = 1; //random(-0.1,1);
    float noise2 = 1; //random(-0.1,1);
    if ((i==1) || (i==nbRadius-1)) {
      noise1 = abs(noise1);
      noise2 = abs(noise2);
    }
    radiusList[i] = radiusList[i] + noise1 * coeff / (abs(radiusList[i] - radiusList[i-1])) - noise2 * coeff / (abs(radiusList[i+1] - radiusList[i]));
  }
  radiusList[nbRadius-1] = 10;
  radiusList[0] = width/2;
  radiusList = reverse(sort(radiusList));
  
  // Save a frame!
  if (isRecording) {
    videoExport.saveFrame();
  }
}

void mouseClicked() {
  initializeRadius();
  print("Reinitializing radius\n");
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
