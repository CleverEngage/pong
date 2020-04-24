class HumanPlayer extends Player {

  HumanPlayer(Racket racket, Ball ball, PongTable table) {
    super(racket, ball, table);
  }

  void onUpKeyPressed() {
    moveRacketUp();
  }

  void onDownKeyPressed() {
    moveRacketDown();
  }

  void onShiftUpKeyPressed() {
    if (isBalCaught) moveBallUp();
  }

  void onShiftDownKeyPressed() {
    if (isBalCaught) moveBallDown();
  }

  void onSpaceKeyReleased() {
    if (isBalCaught) strikeBall();
  }
}
