class PongTable {
  Game context;
  Thing pTable;
  Thing tableNet;
  TableEdge topEdge;
  TableEdge rightEdge;
  TableEdge bottomEdge;
  TableEdge leftEdge;


  PongTable(Game _context, float x, float y, float tWidth, float tHeight, Ball ball) {
    context = _context;
    float edgeStrokeWeight = height * 0.0083;
    pTable = new Thing(x, y, tWidth, tHeight, color(255, 50));
    tableNet = new Thing(pTable.x + pTable.tWidth * 0.5 - edgeStrokeWeight * 0.5, pTable.y, edgeStrokeWeight, pTable.tHeight, color(200, 200));
    topEdge = new TableEdge(context, pTable.x, pTable.y, pTable.tWidth, edgeStrokeWeight, color(255, 200), TableEdge.TOP_EDGE, ball);
    rightEdge = new TableEdge(context, pTable.x + pTable.tWidth - edgeStrokeWeight, pTable.y, edgeStrokeWeight, pTable.tHeight, color(255, 0, 0, 200), TableEdge.RIGHT_EDGE, ball);
    bottomEdge = new TableEdge(context, pTable.x, pTable.y + pTable.tHeight - edgeStrokeWeight, pTable.tWidth, edgeStrokeWeight, color(255, 200), TableEdge.BOTTOM_EDGE, ball);
    leftEdge = new TableEdge(context, pTable.x, pTable.y, edgeStrokeWeight, pTable.tHeight, color(255, 0, 0, 200), TableEdge.LEFT_EDGE, ball);
  }

  void show() {
    pTable.show();
    tableNet.show();
    topEdge.show();
    bottomEdge.show();
    rightEdge.show();
    leftEdge.show();
  }
}
