class Racket extends Thing { //<>//
  final static int UP_DIRECTION = -1;
  final static int DOWN_DIRECTION = 1;
  final static int LEFT_SIDE = 0;
  final static int RIGHT_SIDE = 1;
  int side;
  float racketSpeed = height * 0.016;
  PongTable pTable;
  float topTableEdge;
  float bottomTableEdge;
  Ball ball;
  float ballSyncRelativeY = 0;
  boolean isBallSync = false;
  float minStrikeStrength = height * 0.009;
  float maxStrikeStrength = height * 0.03;

  Racket(float x, float y, float tWidth, float tHeight, color eColor, PongTable table, Ball _ball, int _side) {
    super(x, y, tWidth, tHeight, eColor);
    pTable = table;
    ball = _ball;
    topTableEdge = pTable.topEdge.y + pTable.topEdge.tHeight;
    bottomTableEdge = pTable.bottomEdge.y - tHeight;
    side = _side;
  }

  void move(int direction) {
    if (isRacketOnEdges(direction)) return;

    float displacement = racketSpeed * direction;
    y = constrain(y + displacement, topTableEdge, bottomTableEdge);

    if (isBallSync == true) {
      ball.setYNoHistory(y + ballSyncRelativeY);
    }
  }

  void moveUp() {
    move(UP_DIRECTION);
  }

  void moveDown() {
    move(DOWN_DIRECTION);
  }

  void strike() {
    beep.play();
    syncBallPostion(false);
    float strikeStrength = calculateStrikeStrength() * (side == RIGHT_SIDE ? -1 : 1);
    float angleFactor = calculateAngleFactor();
    ball.strike(strikeStrength, angleFactor);
  }

  float calculateRacketBallCenter() {
    return y + tHeight * 0.5 - ball.y - ball.tHeight * 0.5;
  }

  float calculateStrikeStrength() {
    float racketBallCenterAbs = abs(calculateRacketBallCenter());
    float strikeStrength = map(racketBallCenterAbs, 0, tHeight * 0.5, minStrikeStrength, maxStrikeStrength);
    strikeStrength = constrain(strikeStrength, minStrikeStrength, maxStrikeStrength);
    return strikeStrength;
  }

  float calculateAngleFactor() {
    return -calculateRacketBallCenter() / 5;
  }

  boolean isRacketOnEdges(int direction) {
    return ((y == topTableEdge && direction ==  UP_DIRECTION) || (y == bottomTableEdge && direction ==  DOWN_DIRECTION));
  }

  void syncBallPostion(boolean value) {
    isBallSync = value;

    if (value == true) saveBallRelPos();
  }

  void saveBallRelPos() {
    ballSyncRelativeY = ball.y - y;
  }

  void actIfBallCollide() {
    boolean ballYInRange = (ball.y >= y && ball.y <= y + tHeight) ||
      (ball.y + ball.tHeight >= y && ball.y + ball.tHeight <= y + tHeight);

    if (ballYInRange == false) return;

    float strikeStrength = calculateStrikeStrength();
    float angleFactor = calculateAngleFactor();

    switch (side) {
    case LEFT_SIDE:
      if (ball.x <= x + tWidth && ball.px >= x) {
        PVector collidePoint = 
          TwoLinesIntersection.IPoint(ball.px, ball.py, ball.x, ball.y, x + tWidth, y, x + tWidth, y + tHeight);
        if (collidePoint == null) {
          println("NPE: collidePoint - No lines intersection between ball and racket");
          return;
        }

        ball.setPositionNoHistory(collidePoint.x, collidePoint.y);
        ball.onLeftRacketCollide(strikeStrength, angleFactor);
      }
      break;
    case RIGHT_SIDE:
      if (ball.x + ball.tWidth >= x && ball.px <= x) {
        PVector collidePoint = 
          TwoLinesIntersection.IPoint(ball.px + ball.tWidth, ball.py, ball.x + ball.tWidth, ball.y, x - ball.tWidth, 0, x - ball.tWidth, height);
        if (collidePoint == null) {
          println("NPE: collidePoint - No lines intersection between ball and racket");
          return;
        }

        ball.setPositionNoHistory(collidePoint.x, collidePoint.y);
        ball.onRightRacketCollide(strikeStrength, angleFactor);
      }
      break;
    }
  }
}
