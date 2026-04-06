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
ArrayList<Coin> coins;
//snowball spawn timing
int snowballTimer = 0;
int snowballInterval = 40;
float snowballSpeed = 6;
//coin spawn timing
int coinTimer = 0;
int coinInterval = 270;

int coinCount = 0;
int coinsToWin = 5;

boolean lost = false;
boolean won = false;

void setup() {
  size(800, 600);

  playerPos = new PVector(width/2, height/2);  // start player in center
  playerVel = new PVector(0, 0);
  playerAcc = new PVector(0, 0);

  snowballs = new ArrayList<Snowball>();
  coins = new ArrayList<Coin>();
}

void draw() {
  background(#C6F0FF); // light blue background color

  if (!lost && !won) {
    movePlayer();
    updateSnowballs();
    spawnSnowballs();
    updateCoins();
    spawnCoins();
    checkPlayerHit();
    checkWin();
  }

  displayCoins();
  // draw player
  noStroke();
  fill(#D189FF); // purple player
  ellipse(playerPos.x, playerPos.y, 40, 40);

  //display game over screen
  if (lost) {
    fill(255, 0, 0, 150);
    rect(0, 0, width, height);
    
    fill(255);
    text("Press R to Restart", width/2 - 40, height/2);
  }
  //display win screen
  if (won) {
    fill(0, 255, 0, 150);
    rect(0, 0, width, height);
    
    fill(255);
    text("Press R to Restart", width/2 - 40, height/2);
  }
}
//move player using wasd
void movePlayer() {
  playerAcc = new PVector(0, 0);

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
  for (int i = snowballs.size() - 1; i >= 0; i--) {
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

void updateCoins() {
  for (int i = coins.size() - 1; i >= 0; i--) {
    Coin c = coins.get(i);

    float d = dist(playerPos.x, playerPos.y, c.x, c.y);

    if (d < 20 + c.size/2) {
      coins.remove(i);
      coinCount++;
    }
  }
}

void spawnCoins() {
  coinTimer++;

  if (coinTimer >= coinInterval) {
    float x = random(30, width - 30);
    float y = random(30, height - 30);

    coins.add(new Coin(x, y));
    coinTimer = 0;
  }
}

void displayCoins() {
  for (int i = 0; i < coins.size(); i++) {
    Coin c = coins.get(i);
    c.display();
  }
}

//check collision
void checkPlayerHit() {
  for (int i = 0; i < snowballs.size(); i++) {
    Snowball s = snowballs.get(i);

    float d = dist(playerPos.x, playerPos.y, s.pos.x, s.pos.y);
    //game over is hit
    if (d < 20 + s.size/2) {
      lost = true;
    }
  }
}

void checkWin() {
  if (coinCount >= coinsToWin) {
    won = true;
  }
}

void restartGame() {
  playerPos = new PVector(width/2, height/2);
  playerVel = new PVector(0, 0);
  playerAcc = new PVector(0, 0);

  snowballs = new ArrayList<Snowball>();
  coins = new ArrayList<Coin>();

  snowballTimer = 0;
  coinTimer = 0;
  coinCount = 0;

  lost = false;
  won = false;
}

void keyPressed() {
  if (lost || won) {
    if (key == 'r') {
      restartGame();
    }
  } else {
    if (key == 'w') wPressed = true;
    if (key == 'a') aPressed = true;
    if (key == 's') sPressed = true;
    if (key == 'd') dPressed = true;
  }
}
void keyReleased() {
  if (key == 'w') wPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'd') dPressed = false;
}
