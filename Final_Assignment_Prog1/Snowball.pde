//snowball object
class Snowball {
  PVector pos;
  PVector vel;
  float size;

  Snowball(float x, float y, PVector startVel) {
    pos = new PVector(x, y);
    vel = new PVector(startVel.x, startVel.y);
    size = random(20, 80);
  }
//move snowball
  void update() {
    pos.add(vel);
  }
//draw snowball
  void display() {
    fill(255);
    stroke(180);
    ellipse(pos.x, pos.y, size, size);
  }
  //remove snowballs when they go off screen
    boolean offScreen() {
    if (pos.x < -size || pos.x > width + size || pos.y < -size || pos.y > height + size) {
      return true;
    } else {
      return false;
    }
  }
}
