class AIPlayer extends Player { //<>//
  final static int BALL_CAUGHT = 0;
  final static int MOVE_RACKET = 1;
  final static int MOVE_BALL = 2;
  final static int STRIKE = 3;
  final static int PLAYING = 4;
  final static int WAITING = 5;

  Game context;
  int playState;
  float racketTargetY = 0;
  float ballHitPositionX = 0;
  float ballHitPositionY = 0;
  float pBallSpeedX;
  float pBallSpeedY;
  boolean isRandomRacketTargetYSet = false;
  float ballTargetY = 0;
  boolean isRandomBallTargetYSet = false;
  Timer timer;

  AIPlayer(Game _context, Racket racket, Ball ball, PongTable table) {
    super(racket, ball, table);
    context = _context;
    saveBallSpeed();
    timer = new Timer();
  }

  void saveBallSpeed() {
    pBallSpeedX = ball.speedX;
    pBallSpeedY = ball.speedY;
  }

  boolean isBallMoveTowardRacket() {
    return ball.speedX > 0;
  }

  boolean isBallSpeedChanged() {
    return ball.speedX != pBallSpeedX || ball.speedY != pBallSpeedY;
  }

  boolean isRacketWithinTarget() {
    return racketTargetY >= racket.y && racketTargetY <= racket.y + racket.tHeight;
  }

  boolean isBallWillHitRacketSide() {
    return !(ballHitPositionX == -1 && ballHitPositionY == -1);
  }

  boolean isBallWillHitTopRightHalfEdge() {
    float x1 = ball.px;
    float y1 = ball.py;
    float x2 = ball.x;
    float y2 = ball.y;
    float x3 = table.topEdge.x + table.topEdge.tWidth * 0.5;
    float y3 = table.topEdge.y + table.topEdge.tHeight;
    float x4 = table.topEdge.x + table.topEdge.tWidth;
    float y4 = table.topEdge.y + table.topEdge.tHeight;

    PVector hitPoint = TwoLinesIntersection.ICast(x1, y1, x2, y2, x3, y3, x4, y4);

    if (hitPoint == null) return false;

    return hitPoint.x >= x3 & hitPoint.x <= x4;
  }

  boolean isBallWillHitBottomRightHalfEdge() {
    float x1 = ball.px;
    float y1 = ball.py;
    float x2 = ball.x;
    float y2 = ball.y;
    float x3 = table.bottomEdge.x + table.bottomEdge.tWidth * 0.5;
    float y3 = table.bottomEdge.y;
    float x4 = table.bottomEdge.x + table.bottomEdge.tWidth;
    float y4 = table.bottomEdge.y;

    PVector hitPoint = TwoLinesIntersection.ICast(x1, y1, x2, y2, x3, y3, x4, y4);

    if (hitPoint == null) return false;

    return hitPoint.x >= x3 & hitPoint.x <= x4;
  }

  boolean isRacketMoveRequired() {
    return isRacketWithinTarget() == false;
  } 

  void calculateAndSetBallHitPosition() {
    float x1 = ball.px;
    float y1 = ball.py;
    float x2 = ball.x;
    float y2 = ball.y;

    float x3 = racket.x;
    float y3 = table.rightEdge.y;
    float x4 = racket.x;
    float y4 = table.bottomEdge.y;

    PVector hitPosition = TwoLinesIntersection.ICast(x1, y1, x2, y2, x3, y3, x4, y4);

    if (hitPosition == null) {
      ballHitPositionX = -1;
      ballHitPositionY = -1;
      return;
    }

    ballHitPositionX = hitPosition.x;
    ballHitPositionY = hitPosition.y;
  }  

  void setTargetYToBallHitPosition() {
    racketTargetY = ballHitPositionY;

    //  add randomness on racket position
    if (ballHitPositionY < racket.y) {
      racketTargetY -= random(racket.tHeight);
    } else if (ballHitPositionY > racket.y + racket.tHeight) {
      racketTargetY += racket.tHeight - random(racket.tHeight);
    } else {
      racketTargetY += random(racket.tHeight) * (random(1) > 0.5 ? 1 : -1);
    }

    racketTargetY = constrain(racketTargetY, table.rightEdge.y, table.bottomEdge.y);
  }

  void setTargetYToTopHalf() {
    racketTargetY = random(table.rightEdge.y, table.rightEdge.y + table.rightEdge.tHeight * 0.5);
    racketTargetY = constrain(racketTargetY, table.rightEdge.y, table.bottomEdge.y);
  }

  void setTargetYToBottomHalf() {
    racketTargetY = random(table.rightEdge.y + table.rightEdge.tHeight * 0.5, table.bottomEdge.y);
    racketTargetY = constrain(racketTargetY, table.rightEdge.y, table.bottomEdge.y);
  }

  void moveRacketToTarget() {
    if (racketTargetY < racket.y) {
      moveRacketUp();
    } else if (racketTargetY > racket.y + racket.tHeight) {
      moveRacketDown();
    }
  }

  void setRandomRacketTargetY() {
    racketTargetY = random(table.rightEdge.y, table.bottomEdge.y);
  }

  void setRandomBallTargetY() {
    ballTargetY = random(racket.y, racket.y + racket.tHeight);
  }

  boolean isBallMoveRequired() {
    return isBallWithinTarget() == false;
  }

  boolean isBallWithinTarget() {
    return ballTargetY >= ball.y && ballTargetY <= ball.y + ball.tHeight;
  }

  void moveBallToTarget() {
    if (ballTargetY < ball.y) {
      moveBallUp();
    } else if (ballTargetY > ball.y + ball.tHeight) {
      moveBallDown ();
    }
  }

  void onGameStateChange(int state) {
    if (state == context.BALL_CAUGHT) {
      playState = isBalCaught == true ? BALL_CAUGHT : WAITING;
    } else if (state == context.PLAYING) {
      playState = PLAYING;
    }
  }

  void setTimer() {
    timer.setMillisIntervalFor(300);
  }

  boolean isTimerEnd() {
    return timer.offDelay() == false;
  }

  void run() {
    switch(playState) {
    case BALL_CAUGHT:
      setTimer();
      playState = MOVE_RACKET;
      break;

    case MOVE_RACKET:
      if (isTimerEnd() == false) return;

      if (isRandomRacketTargetYSet == false) {
        setRandomRacketTargetY();
        isRandomRacketTargetYSet = true;
      }
      if (isRacketMoveRequired()) {
        moveRacketToTarget();
      } else {
        isRandomRacketTargetYSet = false;
        setTimer();
        playState = MOVE_BALL;
      }
      break;

    case MOVE_BALL:
      if (isTimerEnd() == false) return;

      if (isRandomBallTargetYSet == false) {
        setRandomBallTargetY();
        isRandomBallTargetYSet = true;
      }

      if (isBallMoveRequired()) {
        moveBallToTarget();
      } else {
        isRandomBallTargetYSet = false;
        setTimer();
        playState = STRIKE;
      }
      break;

    case STRIKE:
      if (isTimerEnd() == false) return;

      strikeBall();
      context.onAIPlayerStrikeBall();
      break;

    case PLAYING:
      if (isBallSpeedChanged()) {
        saveBallSpeed();

        if (isBallMoveTowardRacket()) {
          calculateAndSetBallHitPosition();

          if (isBallWillHitRacketSide()) {
            setTargetYToBallHitPosition();
          } else {
            if (isBallWillHitTopRightHalfEdge()) {
              setTargetYToTopHalf();
            } else if (isBallWillHitBottomRightHalfEdge()) {
              setTargetYToBottomHalf();
            }
          }
        }
      }

      if (isRacketMoveRequired() && isBallMoveTowardRacket()) {
        moveRacketToTarget();
      }
      break;

    case WAITING:
    default:
      return;
    }
  }
}
