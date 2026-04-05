PVector playerPos;  // player position
PVector playerVel;  // player velocity
PVector playerAcc;  // player acceleration
//movement settings
float accelAmount = 0.12;
float maxSpeed = 3;
float friction = 0.98;
//key inputs
boolean wPressed;
boolean aPressed;
boolean sPressed;
boolean dPressed;

ArrayList<Snowball> snowballs;
//snowball spawn timing
int snowballTimer = 0;
int snowballInterval = 90;
float snowballSpeed = 5;

void setup() {
  size(800, 600);

  playerPos = new PVector(width/2, height/2);  // start player in center
  playerVel = new PVector(0, 0);
  playerAcc = new PVector(0, 0);
  
  snowballs = new ArrayList<Snowball>();
}

void draw() {
  background(#C6F0FF); // light blue background color

  movePlayer();
  updateSnowballs();
  spawnSnowballs();
  
  // draw player
  noStroke();
  fill(#D189FF); // purple player 
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

// keep player inside the screen
  if (playerPos.x < 20) {
    playerPos.x = 20;
    playerVel.x = 0;
  }
  if (playerPos.x > width - 20) {
    playerPos.x = width - 20;
    playerVel.x = 0;
  }
  if (playerPos.y < 20) {
    playerPos.y = 20;
    playerVel.y = 0;
  }
  if (playerPos.y > height - 20) {
    playerPos.y = height - 20;
    playerVel.y = 0;
  }
}

void updateSnowballs() {
  for (int i = 0; i < snowballs.size(); i++) {
    Snowball s = snowballs.get(i);
    s.update();
    s.display();
    
     if (s.offScreen()) {  //remove snowballs when they go off screen
      snowballs.remove(i);
    }
  }
}
//spawn snowballs from edges
void spawnSnowballs() {
  snowballTimer++;

  if (snowballTimer >= snowballInterval) {
    float x = 0;
    float y = 0;
    float edge = 10;

    int side = int(random(4));
    PVector dir;

    if (side == 0) {
      x = edge;
      y = random(edge, height - edge);
      dir = new PVector(1, random(-1, 1));
    } else if (side == 1) {
      x = width - edge;
      y = random(edge, height - edge);
      dir = new PVector(-1, random(-1, 1));
    } else if (side == 2) {
      x = random(edge, width - edge);
      y = edge;
      dir = new PVector(random(-1, 1), 1);
    } else {
      x = random(edge, width - edge);
      y = height - edge;
      dir = new PVector(random(-1, 1), -1);
    }

    dir.normalize();
    dir.mult(snowballSpeed);

    snowballs.add(new Snowball(x, y, dir));
    snowballTimer = 0;
  }
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
