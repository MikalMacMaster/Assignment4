//snowball object
class Snowball {
  PVector pos;  // stores snowball position 
  PVector vel;  // stores velocity
  float size;   // stores size

  Snowball(float x, float y, PVector startVel) {  // constructor runs when new snowball is created 
    pos = new PVector(x, y);  // set snowballs starting position
    vel = new PVector(startVel.x, startVel.y);  // copies starting velocity into snowballs own velocity
    size = random(20, 100);  // random size between 20 and 100
  }
//move snowball
  void update() {
    pos.add(vel);  // adds velocity to position to move
  }
//draw snowball
  void display() {
    fill(255);  // fill white
    stroke(180);  // outline grey
    ellipse(pos.x, pos.y, size, size);  // draw as circle at its position using size
  }
 
    boolean offScreen() {  // function that checks if the snowball is outside of screen
    if (pos.x < -size || pos.x > width + size || pos.y < -size || pos.y > height + size) {  // checks if snowball is beyond any of the screen edges
      return true;  // if its outside return true
    } else {  // if its still inside 
      return false;  // return false 
    }
  }
}
