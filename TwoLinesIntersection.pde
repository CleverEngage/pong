static class TwoLinesIntersection {

  static PVector IPoint(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    float denominator = CalculateDenominator(x1, y1, x2, y2, x3, y3, x4, y4);

    if (denominator == 0) return null;

    float px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denominator;
    float py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denominator;

    return new PVector(px, py);
  }

  static PVector ICast(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    float denominator = CalculateDenominator(x1, y1, x2, y2, x3, y3, x4, y4);

    if (denominator == 0) return null;

    //float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator;
    float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator;

    if (u >= 0f && u <= 1f) {
      float px = x3 + u * (x4 - x3);
      float py = y3 + u * (y4 - y3);
      return new PVector(px, py);
    }

    return null;
  }

  static float CalculateDenominator(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    return (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  }
}
