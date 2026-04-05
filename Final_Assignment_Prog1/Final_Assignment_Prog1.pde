PVector playerPos;  // player position
PVector playerVel;  // player velocity
PVector playerAcc;  // player acceleration

void setup() {
  size(800, 600);

  playerPos = new PVector(width/2, height/2);  // start player in center
  playerVel = new PVector(0, 0);
  playerAcc = new PVector(0, 0);
}

void draw() {
  background(220, 240, 255); // light blue background color
 // draw player
  noStroke();
  fill(50, 100, 255);
  ellipse(playerPos.x, playerPos.y, 40, 40);
}
