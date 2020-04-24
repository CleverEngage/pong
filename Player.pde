class Player {
  Racket racket;
  Ball ball;
  PongTable table;
  boolean isBalCaught = false;
  float ballDisplacement = height * 0.003;

  Player(Racket _racket, Ball _ball, PongTable _table) {
    racket = _racket;
    ball = _ball;
    table = _table;
  }

  void moveRacketUp() {
    racket.moveUp();

    if (isBalCaught) constrainBallAndSaveRelPos();
  }

  void moveRacketDown() {
    racket.moveDown();

    if (isBalCaught) constrainBallAndSaveRelPos();
  }

  void moveBallUp() {
    ball.moveYBy(-ballDisplacement);
    constrainBallAndSaveRelPos();
  }

  void moveBallDown() {
    ball.moveYBy(ballDisplacement);
    constrainBallAndSaveRelPos();
  }

  void constrainBallAndSaveRelPos() {
    float topLimit = table.topEdge.y + table.topEdge.tHeight;
    float topRacketLimit = racket.y - ball.tHeight + 2;
    float bottomLimit = table.bottomEdge.y - ball.tHeight;
    float bottomRacketLimit = racket.y + racket.tHeight - 2;

    if (ball.y < topLimit) {
      ball.y = topLimit;
    }

    if (ball.y > bottomLimit) {
      ball.y = bottomLimit;
    }

    if (ball.y < topRacketLimit) {
      ball.y = topRacketLimit;
    }

    if (ball.y > bottomRacketLimit) {
      ball.y = bottomRacketLimit;
    }

    racket.saveBallRelPos();
  }

  void strikeBall() {
    isBalCaught = false;
    racket.strike();
  }

  void catchBall() {
    isBalCaught = true;
    float x = racket.x + (racket.side == Racket.LEFT_SIDE ? racket.tWidth : -ball.tWidth);
    float y = racket.y + (racket.tHeight - ball.tHeight) * 0.5;
    ball.setPosition(x, y);
    ball.resetSpeed();
    racket.syncBallPostion(true);
  }
}
