PVector playerPos;  // player position
PVector playerVel;  // player velocity
PVector playerAcc;  // player acceleration

//movement settings
float accelAmount = 0.12;  // how strongly the player speeds up when moving
float maxSpeed = 3;  // fastest speed player can move
float friction = 0.98;  // how much the player slows down each frame

//key inputs, stores weather each key is being held down
boolean wPressed;
boolean aPressed;
boolean sPressed;
boolean dPressed;

ArrayList<Snowball> snowballs;  // a list that holds all snowball objects
ArrayList<Coin> coins;   // a list that holds all coin objects

//snowball spawn timing
int snowballTimer = 0;  // starts a timer for snowball spawning, begins at 0
int snowballInterval = 40;  // how often snowballs spawn (every 40 frames)
float snowballSpeed = 6;  // how fast snowballs move

//coin spawn timing
int coinTimer = 0;  // starts timer for coin spawning
int coinInterval = 270;  // how often coins spawn (every 270 frames)

int coinCount = 0;  // how many coins the player has collected
int coinsToWin = 5;  // how many coins the player needs to win

// tracks whether the player has won or lost
boolean lost = false;
boolean won = false;

void setup() {
  size(800, 600);  // set window size

  playerPos = new PVector(width/2, height/2);  // start player in center
  playerVel = new PVector(0, 0);    // player spawns with no movement
  playerAcc = new PVector(0, 0);   // player starts with no acceleration

  snowballs = new ArrayList<Snowball>();   // creates empty snowball list
  coins = new ArrayList<Coin>();   // creates empty coin list
}

void draw() {
  background(#C6F0FF); // light blue background color

  if (!lost && !won) {   // only run the main game systems if the player has not lost and has not won
    movePlayer();    // moves the player
    updateSnowballs();  // updates and displays snow balls
    spawnSnowballs();   // checks if it is time to spawn new snowball
    updateCoins();      // checks if the player has collected any coins
    spawnCoins();      // checks if it is time to spawn new coin
    checkPlayerHit();  // checks if a snowball touched the player
    checkWin();       // checks if the player has collected enough coins to win
  }

  displayCoins();   // draw all coins on screen

  // draw player
  noStroke();
  fill(#D189FF); // purple player
  ellipse(playerPos.x, playerPos.y, 40, 40);  // draw the player as a circle at player x and y with a width and height of 40

  if (lost) {   // check if player has lost
    fill(255, 0, 0, 150);  // set a semi transparent red colour
    rect(0, 0, width, height);  // draw a red rectangle over the whole screen

    fill(255);  // white text colour
    text("Press R to Restart", width/2 - 40, height/2);  // displays restart text near the center of the screen
  }

  if (won) {  // check if the player has won
    fill(0, 255, 0, 150);   // set a semi transparent green colour
    rect(0, 0, width, height);  // draw a green rectangle over the whole screen

    fill(255);  // white colour for text
    text("Press R to Restart", width/2 - 40, height/2);  // display restart text near the center of the screen
  }
}

//move player using wasd
void movePlayer() {   // handle player movement
  playerAcc = new PVector(0, 0);  // reset acceleration to zero at the start of every frame
  if (wPressed) playerAcc.y = -1; // if w is pressed acceleration goes upward
  if (sPressed) playerAcc.y = 1;  // if s is pressed acceleration goes downward
  if (aPressed) playerAcc.x = -1; // if a is pressed acceleration goes left
  if (dPressed) playerAcc.x = 1;  // if d is pressed acceleration goes right

  if (playerAcc.mag() > 0) {  // checks if the player is trying to move
    playerAcc.normalize();  // makes movement directions have a length of 1, stops diagonal movement from being faster
    playerAcc.mult(accelAmount);  // scales acceleration to movement strength
  }

  playerVel.add(playerAcc);  // adds acceleration into velocity so player speeds up in chosen direction
  playerVel.limit(maxSpeed); // stops velocity from going over max speed
  playerVel.mult(friction);  // multiply velocity by friction to slow the player down each frame
  playerPos.add(playerVel);  // add velocity into position to move the player

  // keep player inside the screen
  if (playerPos.x < 20) {  // checks if player went too far left
    playerPos.x = 20;  // pushes the player back inside screen
    playerVel.x = 0;   // stops sideways movement so player does not keep pushing into the wall
  }
  if (playerPos.x > width - 20) {  // checks if player went too far right
    playerPos.x = width - 20;  // keeps player inside the screen
    playerVel.x = 0;   // stops horizontal movement at wall
  }
  if (playerPos.y < 20) {  // checks if player went too far up
    playerPos.y = 20;   // keeps player inside screen
    playerVel.y = 0;    // stops vertical movement at wall
  }
  if (playerPos.y > height - 20) {  // checks if player went too far down
    playerPos.y = height - 20;     // keeps player inside screen
    playerVel.y = 0;      // stops vertical movement at wall
  }
}

void updateSnowballs() {   // updates every snowball
  for (int i = snowballs.size() - 1; i >= 0; i--) {   // loops through the snowball list backwards
    Snowball s = snowballs.get(i);    // gets a snowball and stores it in s
    s.update();     // moves the snowball
    s.display();    // draws the snowball

    if (s.offScreen()) {  // checks if the snowball is off screen
      snowballs.remove(i); // removes it
    }
  }
}

//spawn snowballs from edges
void spawnSnowballs() {  // snowball spawning function
  snowballTimer++;      // adds 1 to the snowball timer every frame

  if (snowballTimer >= snowballInterval) {  // checks if enough time has passed to spawn snowball
   // variables for snowballs position
    float x = 0;
    float y = 0;
    float edge = 10;  // small offset from screen edge

    int side = int(random(4));  // picks random side of screen
    PVector dir;  // variable for direction the snowball moves

    if (side == 0) {   // if side zero spawn on left side
      x = edge;  // set x near left edge
      y = random(edge, height - edge);   // pick random position along that side
      dir = new PVector(1, random(-1, 1));  // create a direction that mostly points right with slight random vertical angle
    } else if (side == 1) {   // if the side is 1 spawn on right side
      x = width - edge;   // set x near right edge
      y = random(edge, height - edge);  // random y position
      dir = new PVector(-1, random(-1, 1));  // direction mostly pointing left
    } else if (side == 2) {  // if side is 2 spawn at top
      x = random(edge, width - edge);  // random x position
      y = edge;  // set y near top edge
      dir = new PVector(random(-1, 1), 1);  // direction mostly points down
    } else {    // if it is not 0, 1, or 2 then spawn at bottom
      x = random(edge, width - edge);  // random x position
      y = height - edge;   // set y near bottom
      dir = new PVector(random(-1, 1), -1);   // direction that mostly points up
    }

    dir.normalize();  // direction vector length equal to 1, all snowballs move consistently before speed is applied
    dir.mult(snowballSpeed);  // scales direction vector by speed

    snowballs.add(new Snowball(x, y, dir));  // create new snowball and add it to list
    snowballTimer = 0;   // reset timer after spawning
  }
}

void updateCoins() {    // coin update function
  for (int i = coins.size() - 1; i >= 0; i--) {   // loops through the coin list backwards
    Coin c = coins.get(i);    // get one coin from the list

    float d = dist(playerPos.x, playerPos.y, c.x, c.y);  // find distance from player to coin

    if (d < 20 + c.size/2) {  // if player circle and coin circle are touching
      coins.remove(i);  // remove the coin
      coinCount++;   // adds 1 to player coin count
    }
  }
}

void spawnCoins() {  // coin spawning function
  coinTimer++;   // adds 1 to the coin timer every frame

  if (coinTimer >= coinInterval) {   // check if enough time has passed to spawn coin
    float x = random(30, width - 30);  // random x position away from edges
    float y = random(30, height - 30);  // random y position away

    coins.add(new Coin(x, y));  // creates new coin at position and adds to list
    coinTimer = 0;    // reset timer after spawning
  }
}

void displayCoins() {   // function to draw coins
  for (int i = 0; i < coins.size(); i++) {   // loops through every coin in list
    Coin c = coins.get(i);  // gets one coin from list
    c.display();   // draws that coin
  }
}

//check collision
void checkPlayerHit() {   // function to check if player is hit
  for (int i = 0; i < snowballs.size(); i++) {  // loops through every snowball
    Snowball s = snowballs.get(i);   // gets one snowball from list

    float d = dist(playerPos.x, playerPos.y, s.pos.x, s.pos.y);  // finds distance between player and snowball
  
    if (d < 20 + s.size/2) {  // checks if touching
      lost = true;  // if they touch player loses
    }
  }
}

void checkWin() {  // win check function
  if (coinCount >= coinsToWin) {   // check if player has enough coins to win
    won = true;  // sets game state to win
  }
}

void restartGame() {  // restart function
  playerPos = new PVector(width/2, height/2);  // move player to center
  playerVel = new PVector(0, 0);   // reset velocity
  playerAcc = new PVector(0, 0);    // reset acceleration

  snowballs = new ArrayList<Snowball>();  // clear old snowballs by making empty list
  coins = new ArrayList<Coin>();   // clear old coins

  snowballTimer = 0;  // reset timer
  coinTimer = 0;   // reset timer
  coinCount = 0;  // reset coin count
  // turn of both game end states
  lost = false;
  won = false;
}

void keyPressed() {    // runs when a key is pressed
  if (lost || won) {   // checks if game is over
    if (key == 'r') {  // if r key is pressed after game ends
      restartGame();   // restarts the game
    }
  } else {  // if game is not over
   // set the movement key boolean to true so the player moves that direction
    if (key == 'w') wPressed = true;
    if (key == 'a') aPressed = true;
    if (key == 's') sPressed = true;
    if (key == 'd') dPressed = true;
  }
}
void keyReleased() {  // runs when key is released
  // turn the movement boolean off when key is released, stops the direction of movement
  if (key == 'w') wPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'd') dPressed = false;
}
