import 'dart:math';

class IndexHelper {
  /// converts a two dimensional index ([row]], [column]) to a one dimensional index
  static int coordinate2DAsIndex(int row, int column, int columnCount) {
    return columnCount * row + column;
  }

  /// converts a one dimensional index into a two dimensional index ([Point])
  static Point indexAsCoordinate2D(int index, int columnCount) {
    return Point((index / columnCount).floor(), index % columnCount);
  }
}
