class Thing extends Position {
  float tWidth;
  float tHeight;
  color eColor;

  Thing(float x, float y, float _tWidth, float _tHeight, color _eColor) {
    super(x, y);
    tWidth = _tWidth;
    tHeight = _tHeight;
    eColor = _eColor;
  }

  void show() {
    noStroke();
    fill(eColor);
    rect(x, y, tWidth, tHeight);
  }
}
