import com.hamoid.*;

ArrayList<PVector> listPV = new ArrayList();
ArrayList<Float> listTheta = new ArrayList();

float angleForRotation;
boolean isRecording = false;

VideoExport videoExport;

String words = "Hold fast to dreams" +
               "For if dreams die" +
               "Life is a broken-winged bird" +
               "That cannot fly." +
               "Hold fast to dreams" +
               "For when dreams go" +
               "Life is a barren field" +
               "Frozen with snow.";

void setup() {
  size(800, 800, P3D);
  noStroke();

  float x, y, z; 
  float r = 88; 
  float rdec = 0.995;
  float arcLength = 0.0;
  
  fill(0, 0, 0);
   
  for (int i=0; i<words.length(); i++) {
    float w = textWidth(words.charAt(i));
    arcLength += 3*w/2;
    float theta = PI + arcLength / r;    

    // x and z are the circle part
    x = r * cos(theta);
    y = map(i, 0, words.length(), -230, 230); 
    z = r * sin(theta);
    listPV.add(new PVector(x, y, z));
    listTheta.add(theta);
    r = r * rdec;
  }
  background(0); 

  // Some settings
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(20);
  
  textFont(createFont("Vera Sans Bitstream", 16, true));
  //print(PFont.list());
}

void draw() {
  background(255); 
  lights(); 

  translate(width/2, height/2); 
  rotateY(angleForRotation);
  int indexChar = 0;
  for (int index=0; index<listPV.size(); index++) {
    PVector pv = listPV.get(index);
    float theta = listTheta.get(index);
    pushMatrix(); 
    translate (pv.x, pv.y, pv.z); 
    //sphere(4);
    rotateY(theta + PI/4.0);
    text(words.charAt(indexChar),0,0);
    popMatrix();
    indexChar++;
  }

  angleForRotation+=.007; 
  
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
