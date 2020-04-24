class Scoring {
  PFont font;
  float leftX = width * 0.25;
  float leftY = height * 0.058;
  float rightX = width - leftX;
  float rightY = leftY;
  Score leftPlayer;
  Score rightPlayer;

  Scoring() {
    font = loadFont("BungeeInline-Regular-48.vlw");
    if (height <= 600) {
      textFont(font, 32);
    } else {
      textFont(font, 48);
    }

    leftPlayer = new Score(leftX, leftY);
    rightPlayer = new Score(rightX, rightY);
  }

  void incrementLeft() {
    leftPlayer.incrementPoints();
  }

  void incrementRight() {
    rightPlayer.incrementPoints();
  }

  void run() {
    leftPlayer.run();
    rightPlayer.run();
  }

  void show() {
    leftPlayer.show();
    rightPlayer.show();
  }

  class Score {
    float x;
    float y;
    int pPoints = -1;
    int points = 0;
    int pAlpha = 0;
    int alpha = 255;
    int step = 10;

    Score(float _x, float _y) {
      x = _x;
      y = _y;
    }

    void setCrossFadeAlpha() {
      pAlpha = 255;
      alpha = 0;
    }

    void incrementPoints() {
      ++pPoints;
      ++points;
      setCrossFadeAlpha();
    }

    void run() {
      if (pAlpha > 0) {
        pAlpha -= step;
        constrain(pAlpha, 0, 255);
      }

      if (alpha < 255) {
        alpha += step;
        constrain(alpha, 0, 255);
      }
    }

    void show() {
      fill(254, 255, 26, pAlpha);
      text(pPoints, x, y);

      fill(254, 255, 26, alpha);
      text(points, x, y);
    }
  }
}
