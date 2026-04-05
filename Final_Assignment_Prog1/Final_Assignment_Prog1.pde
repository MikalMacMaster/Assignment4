PVector playerPos;  // player position
PVector playerVel;  // player velocity
PVector playerAcc;  // player acceleration
//movement settings
float accelAmount = 0.12;
float maxSpeed = 4;
float friction = 0.98;
//key inputs
boolean wPressed;
boolean aPressed;
boolean sPressed;
boolean dPressed;

void setup() {
  size(800, 600);

  playerPos = new PVector(width/2, height/2);  // start player in center
  playerVel = new PVector(0, 0);
  playerAcc = new PVector(0, 0);
}

void draw() {
  background(#A5FBFF); // light blue background color

  movePlayer();

  // draw player
  noStroke();
  fill(#0036A0); // dark blue player 
  ellipse(playerPos.x, playerPos.y, 40, 40);
}
//move player using wasd
void movePlayer() {
  playerAcc.set(0, 0);

  if (wPressed) playerAcc.y = -1;
  if (sPressed) playerAcc.y = 1;
  if (aPressed) playerAcc.x = -1;
  if (dPressed) playerAcc.x = 1;

  if (playerAcc.mag() > 0) {
    playerAcc.normalize();
    playerAcc.mult(accelAmount);
  }

  playerVel.add(playerAcc);
  playerVel.limit(maxSpeed);
  playerVel.mult(friction);
  playerPos.add(playerVel);
}

void keyPressed() {
  if (key == 'w') wPressed = true;
  if (key == 'a') aPressed = true;
  if (key == 's') sPressed = true;
  if (key == 'd') dPressed = true;
}

void keyReleased() {
  if (key == 'w') wPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'd') dPressed = false;
}
