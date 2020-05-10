// forum.processing.org/two/discussion/13189/a-better-way-to-fade
// GoToLoop (2015-Oct-22)
 
static final int FPS = 10, FADE = 030;
PGraphics fader;
 
void setup() {
  size(600, 400, JAVA2D);
  frameRate(FPS);
  imageMode(CORNER);
 
  fader = createGraphics(width, height, JAVA2D);
  fader.smooth(4);
  fader.beginDraw();
  fader.strokeWeight(5);
  fader.stroke(-1);
 
  mousePressed();
}
 
void draw() {
  image(fader, 0, 0);
 
  fader.beginDraw();
  fader.pushStyle();
  fader.noStroke();
  fader.fill(0, FADE);
  fader.rect(0, 0, width, height);
  fader.popStyle();
  fader.endDraw();
}
 
void mousePressed() {
  fader.beginDraw();
  fader.fill((color) random(#000000));
  fader.ellipse(width>>1, height>>1, width*3/4, height*3/4);
  fader.endDraw();
}
 
void keyPressed() {
  if (key == ENTER | key == RETURN)  fader.save(dataPath(nf(frameCount, 4) + ".png"));
  else                               mousePressed();
}
