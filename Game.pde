class Game {
  final int BALL_CAUGHT = 0;
  final int PLAYING = 1;

  int state;

  Scoring scoring;
  PongTable pongTable;
  float tableSizeFactor = 0.85;

  Racket lRacket;
  Racket rRacket;

  Ball ball;

  HumanPlayer player1;
  AIPlayer player2;

  Collider collider;

  Game() {
    scoring = new Scoring();

    ball = new Ball(height * 0.02, color(255, 255, 82));

    float tableWidth = width * tableSizeFactor;
    float tableHeight = height * tableSizeFactor;
    float tableX = (width - tableWidth) / 2;
    float tableY = (height - tableHeight) / 2;

    pongTable = new PongTable(this, tableX, tableY, tableWidth, tableHeight, ball);

    float racketWidth = width * 0.01;
    float racketHeight = height * 0.15;
    float racketSpacing = tableWidth * 0.45;
    float leftRacketX = tableX + (tableWidth - racketWidth) * 0.5 - racketSpacing;
    float rightRacketX = tableX + (tableWidth - racketWidth) * 0.5 + racketSpacing;
    float racketY = tableY + tableHeight * 0.5 - racketHeight * 0.5;

    lRacket = new Racket(leftRacketX, racketY, racketWidth, racketHeight, color(0, 255, 255), pongTable, ball, Racket.LEFT_SIDE);
    rRacket = new Racket(rightRacketX, racketY, racketWidth, racketHeight, color(0, 255, 255), pongTable, ball, Racket.RIGHT_SIDE);

    player1 = new HumanPlayer(lRacket, ball, pongTable);
    player2 = new AIPlayer(this, rRacket, ball, pongTable);

    determineFirstPlayer(player1, player2).catchBall();
    setGameState(BALL_CAUGHT);

    collider = new Collider(pongTable, ball, lRacket, rRacket);
  }

  void run() {
    ball.run();
    player2.run();
    collider.run();
    scoring.run();
  }

  void show() {
    pongTable.show();
    lRacket.show();
    rRacket.show();
    ball.show();
    scoring.show();
  }

  void onUpKeyPressed() {
    player1.onUpKeyPressed();
  }

  void onDownKeyPressed() {
    player1.onDownKeyPressed();
  }

  void onShiftUpKeyPressed() {
    player1.onShiftUpKeyPressed();
  }

  void onShiftDownKeyPressed() {
    player1.onShiftDownKeyPressed();
  }

  void onSpaceKeyReleased() {
    setGameState(PLAYING);
    player1.onSpaceKeyReleased();
  }

  Player determineFirstPlayer(Player player1, Player player2) {
    return random(1) > 0.5 ? player1 : player2;
  }

  void setGameState(int value) {
    state = value;
    player2.onGameStateChange(value);
  }

  void onAIPlayerStrikeBall() {
    setGameState(PLAYING);
  }

  void onRightPlayerScore() {
    blip.play();
    scoring.incrementRight();
    player1.catchBall();
    setGameState(BALL_CAUGHT);
  }

  void onLeftPlayerScore() {
    blip.play();
    scoring.incrementLeft();
    player2.catchBall();
    setGameState(BALL_CAUGHT);
  }
}
