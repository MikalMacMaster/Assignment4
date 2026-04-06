class Coin {
  float x;
  float y;
  float size;

  Coin(float startX, float startY) {
    x = startX;
    y = startY;
    size = 18;
  }

  void display() {
    fill(255, 215, 0);
    stroke(180, 140, 0);
    ellipse(x, y, size, size);
  }
}
