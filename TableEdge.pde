class TableEdge extends Thing {
  Game context;
  final static int TOP_EDGE = 0;
  final static int RIGHT_EDGE = 1;
  final static int BOTTOM_EDGE = 2;
  final static int LEFT_EDGE = 3;
  int side;
  Ball ball;

  TableEdge(Game _context, float x, float y, float tWidth, float tHeight, color eColor, int _side, Ball _ball) {
    super(x, y, tWidth, tHeight, eColor);
    context = _context;
    side = _side;
    ball = _ball;
  }

  void actIfBallCollide(float value) {
    switch (side) {
    case LEFT_EDGE:
      if (value <= x + tWidth) {
        context.onRightPlayerScore();
      }
      break;
    case RIGHT_EDGE:
      if (value >= x) {
        context.onLeftPlayerScore();
      }
      break;
    case TOP_EDGE:
      if (value <= y + tHeight) {
        PVector collidePoint = 
          TwoLinesIntersection.IPoint(ball.px, ball.py, ball.x, ball.y, x, y + tHeight, x + tWidth, y + tHeight);
        if (collidePoint == null) {
          println("NPE: collidePoint - No lines intersection between ball and edge");
          return;
        }

        ball.setPositionNoHistory(collidePoint.x, collidePoint.y);
        ball.onTopEdgeCollide();
      }
      break;
    case BOTTOM_EDGE:
      if (value >= y) {
        PVector collidePoint = 
          TwoLinesIntersection.IPoint(ball.px, ball.py, ball.x, ball.y, x, y - ball.tHeight, x + tWidth, y - ball.tHeight);
        if (collidePoint == null) {
          println("NPE: collidePoint - No lines intersection between ball and edge");
          return;
        }

        ball.setPositionNoHistory(collidePoint.x, collidePoint.y);
        ball.onBottomEdgeCollide();
      }
      break;
    }
  }
}
