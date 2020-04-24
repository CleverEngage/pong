/** Programmed by Abdullah Al-Sabbagh - 4/7/2020
 ** 
 ** ~~ YouTube ~~
 ** Coding Challenge #67: Pong!: https://youtu.be/IIrC5Qcb2G4
 ** Pong in JavaScript (using ES6): https://youtu.be/ju09womACpQ
 ** Pong & Object Oriented Programming - Computerphile : https://youtu.be/KyTUN6_Z9TM
 ** Coding Challenge #145: 2D Raycasting: https://youtu.be/TOEi6T2mtHo
 ** ~~ Wikipedia ~~
 ** Pong: https://en.wikipedia.org/wiki/Pong
 ** Table tennis: https://en.wikipedia.org/wiki/Table_tennis
 ** Line–line intersection: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
 **/

/**
 ** This game features the sound effect (named "beep" in the game) "pong" by n_audioman, 
 ** available under a Creative Commons Attribution 3.0 Unported (CC BY 3.0) license.
 ** License: https://creativecommons.org/licenses/by/3.0/
 ** Sound effect: https://freesound.org/s/273766/
 
 ** This game features the sound effect (named "bounce" in the game) "pong30" by n_audioman, 
 ** available under a Creative Commons Attribution 3.0 Unported (CC BY 3.0) license.
 ** License: https://creativecommons.org/licenses/by/3.0/
 ** Sound effect: https://freesound.org/s/273470/
 
 ** This game features the sound effect (named "blip" in the game) "blip2" by Greenhourglass, 
 ** available under a Creative Commons CC0 1.0 Universal (CC0 1.0) Public Domain Dedication license.
 ** License: https://creativecommons.org/publicdomain/zero/1.0/
 ** Sound effect: https://freesound.org/s/159378/
 **/


import processing.sound.*;

final static int SPACE = 32;
boolean isShiftPressed = false;
boolean isValidKeyPressed = false;

Game game;
SoundFile beep;  // plays when the ball strikes by the racket
SoundFile blip;  // plays when any player score 
SoundFile bounce;  // plays when ball bounce

void setup() {
  size(800, 600);
  //size(1200, 800);
  //fullScreen();

  game = new Game();
  beep = new SoundFile(this, "sounds/beep.wav");
  blip = new SoundFile(this, "sounds/blip.wav");
  bounce = new SoundFile(this, "sounds/bounce.wav");
}

void draw() {
  background(51);

  if (keyPressed) {
    onKeyPressed();
  }

  game.run();
  game.show();
}

void onKeyPressed() {
  if (isKeyValid() == false)  return;

  if (isShiftPressed == true && isValidKeyPressed == true && keyCode == UP) {
    game.onShiftUpKeyPressed();
  } else if (isShiftPressed == true && isValidKeyPressed == true && keyCode == DOWN) {
    game.onShiftDownKeyPressed();
  } else if (isShiftPressed == false && isValidKeyPressed == true && keyCode == UP) {
    game.onUpKeyPressed();
  } else if (isShiftPressed == false && isValidKeyPressed == true && keyCode == DOWN) {
    game.onDownKeyPressed();
  }
}


void keyPressed() {
  if (isKeyValid() == false)  return;

  if (keyCode == SHIFT) {
    setShiftKeyPressed(true);
  } else {
    setValidKeyPressed(true);
  }
}

void keyReleased() {
  if (isKeyValid() == false)  return;

  if (keyCode == SHIFT) {
    setShiftKeyPressed(false);
  } else if (key == SPACE) {
    setValidKeyPressed(false);
    game.onSpaceKeyReleased();
  } else {
    setValidKeyPressed(false);
  }
}

boolean isKeyValid() {
  if (key == CODED && (keyCode == UP || keyCode == DOWN || keyCode == SHIFT)) {
    return true;
  } else if ( key == SPACE) {
    return true;
  }

  return false;
}

void setShiftKeyPressed(boolean value) {
  if (isShiftPressed != value) {
    isShiftPressed = value;
  }
}

void setValidKeyPressed(boolean value) {
  if (isValidKeyPressed != value) {
    isValidKeyPressed = value;
  }
}
