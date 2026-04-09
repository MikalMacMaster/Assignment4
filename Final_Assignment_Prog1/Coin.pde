class Coin {
  float x; // stores x position
  float y; // stores y position
  float size; // stores size 

  Coin(float startX, float startY) {  // constructor for making new coins 
    x = startX;  // set coin starting x position 
    y = startY;  // set coin starting y position 
    size = 18;   // set size
  }

  void display() {
    fill(255, 215, 0);  // fill gold 
    stroke(180, 140, 0); // outline brown
    ellipse(x, y, size, size); // draw circle at x and y with size
  }
}
