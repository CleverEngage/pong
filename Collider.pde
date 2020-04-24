class Collider {
  float deadStartX;
  float deadEndX;
  float deadStartY;
  float deadEndY;
  PongTable pTable;
  Ball ball;
  Racket lRacket;
  Racket rRacket;
  float sizeFactor = 0.7;

  Collider(PongTable _pTable, Ball _ball, Racket _lRacket, Racket _rRacket) {
    pTable = _pTable;
    ball = _ball;
    lRacket = _lRacket;
    rRacket = _rRacket;
    calculateDeadZone();
  }

  void calculateDeadZone() {
    deadStartX = ((1 - sizeFactor) * width) * 0.5;
    deadEndX = width - deadStartX;
    deadStartY = ((1 - sizeFactor) * height) * 0.5;
    deadEndY = height - deadStartY;
  }

  boolean isBallInDeadZone() {
    return (ball.x >= deadStartX &&
      ball.x + ball.tWidth <= deadEndX &&
      ball.y >= deadStartY &&
      ball.y + ball.tHeight <= deadEndY);
  }

  void run() {
    if (isBallInDeadZone()) return;

    if (ball.speedX < 0) {
      lRacket.actIfBallCollide();
      pTable.leftEdge.actIfBallCollide(ball.x);
    } 

    if (ball.speedX > 0) {
      rRacket.actIfBallCollide();
      pTable.rightEdge.actIfBallCollide(ball.x + ball.tWidth);
    }

    if (ball.speedY < 0) {
      pTable.topEdge.actIfBallCollide(ball.y);
    }

    if (ball.speedY > 0) {
      pTable.bottomEdge.actIfBallCollide(ball.y + ball.tWidth);
    }
  }
}
