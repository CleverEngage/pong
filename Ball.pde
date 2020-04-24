class Ball extends Thing {
  float px = 0;
  float py = 0;
  float speedX = 0;
  float speedY = 0;

  Ball(float size, color eColor) {
    super(0, 0, size, size, eColor);
  }

  void resetSpeed() {
    speedX = 0;
    speedY = 0;
  }

  void setPosition(float _x, float _y) {
    px = x;
    py = y;
    x = _x;
    y = _y;
  }

  void setPositionNoHistory(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void setYNoHistory(float value) {
    y = value;
  }

  void moveYBy(float value) {
    y += value;
  }

  void run() {
    px = x;
    py = y;
    x += speedX;
    y += speedY;
  }

  void strike(float strikeStrength, float angleFactor) {
    speedX = strikeStrength;
    speedY = angleFactor;
  }

  float calculateNewSpeedX(float strikeStrength) {
    return strikeStrength + random(3);
  }

  float calculateNewSpeedY(float angleFactor) {
    return angleFactor;
  }

  void onLeftRacketCollide(float strikeStrength, float angleFactor) {
    beep.play();
    speedX = calculateNewSpeedX(strikeStrength);
    speedY = calculateNewSpeedY(angleFactor);
  }

  void onRightRacketCollide(float strikeStrength, float angleFactor) {
    beep.play();
    speedX = -1 * calculateNewSpeedX(strikeStrength);
    speedY = calculateNewSpeedY(angleFactor);
  }

  void onTopEdgeCollide() {
    bounce.play();
    speedY *= -1;
  }

  void onBottomEdgeCollide() {
    bounce.play();
    speedY *= -1;
  }
}
