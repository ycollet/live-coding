int nb_points = 20;
PVector points[];

void setup() {
  size(800, 600);
  noStroke();
  colorMode(HSB);
  points = new PVector[nb_points];
  for (int i = 0; i < nb_points; i++) {
    points[i] = new PVector(random(width), random(height));
  }
  drawNoise();
}

void draw() {
  drawNoise();
}

float dist2(float x1, float y1, float x2, float y2) {
  return abs(x2 - x1 + y2 - y1);
}

void drawNoise() {
  //float rand = random(points);
  //rand.add(p5.Vector.random2D().mult(50))

  int res = 3;
  for (int x = 0; x < width; x += res) {
    for (int y = 0; y < height; y += res) {
      float close = 1000;
      PVector closeP;
      for (PVector p : points) {
        if (dist(x, y, p.x, p.y) < close) {
          close = dist(x, y, p.x, p.y);
          closeP = p;
        }
      }
      int col = 255;
      if (close < 75) col = 0;
      fill(close);
      rect(x, y, res, res);
    }
  }
}
