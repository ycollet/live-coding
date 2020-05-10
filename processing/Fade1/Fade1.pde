PGraphics canvas;
 
void setup() {
  size(400, 400);
  canvas = createGraphics(width, height);
}
 
void draw() {
  background(200, 0, 0);
 
  fadeGraphics(canvas, 2);
 
  canvas.beginDraw();
  canvas.rect(mouseX, mouseY, 10, 10);
  canvas.endDraw();
 
  image(canvas, 0, 0);
}

void fadeGraphics(PGraphics c, int fadeAmount) {
  c.beginDraw();
  c.loadPixels();
 
  // iterate over pixels
  for (int i =0; i<c.pixels.length; i++) {
 
    // get alpha value
    int alpha = (c.pixels[i] >> 24) & 0xFF ;
 
    // reduce alpha value
    alpha = max(0, alpha-fadeAmount);
 
    // assign color with new alpha-value
    c.pixels[i] = alpha<<24 | (c.pixels[i]) & 0xFFFFFF ;
  }
 
  canvas.updatePixels();
  canvas.endDraw();
}
