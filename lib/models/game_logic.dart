import 'dart:math';

import 'package:flutter_minesweeper/helper/index_helper.dart';
import 'package:flutter_minesweeper/models/field.dart';

class Game {
  int _rowCount;
  int get rowCount => _rowCount;
  int _columnCount;
  int get columnCount => _columnCount;

  int get size => rowCount * columnCount;
  int _mineCount;

  GameState currentState = GameState.running;

  List<List<Field>> fields;

  Game(this._rowCount, this._columnCount, this._mineCount) {
    List<int> mineIndices = _generateRandomUniqueMineIndices(_mineCount);

    fields = List.generate(rowCount, (_) => List(columnCount));

    for (var row = 0; row < rowCount; row++) {
      for (var column = 0; column < columnCount; column++) {
        fields[row][column] = Field();
        fields[row][column].numberOfMinesAround =
            _getNumberOfMinesAround(row, column, mineIndices);
        fields[row][column].isMined = mineIndices.contains(
            IndexHelper.coordinate2DAsIndex(row, column, columnCount));
      }
    }
  }

  /// generates a list of the length of [numberOfMines] of random and unique indexes within the range of [size]
  List<int> _generateRandomUniqueMineIndices(int numberOfMines) {
    List<int> mineIndices = List();
    Random rnd = Random();

    while (mineIndices.length != numberOfMines) {
      int mineIndex = rnd.nextInt(size - 1);
      if (!mineIndices.contains(mineIndex)) mineIndices.add(mineIndex);
    }

    return mineIndices;
  }

  /// gets the number of mines in the neighbourhood of [row] & [column] by a one dimensional index list of [mineIndices]
  int _getNumberOfMinesAround(int row, int column, List<int> mineIndices) {
    int result = 0;
    List<Point> neighbours = _getNeighbourIndices(row, column);

    for (var i = 0; i < neighbours.length; i++) {
      if (mineIndices.contains(IndexHelper.coordinate2DAsIndex(
          neighbours[i].x, neighbours[i].y, columnCount))) result++;
    }

    return result;
  }

  /// gets a list of the neighbour coordinates of the given [row] & [column]
  List<Point> _getNeighbourIndices(int row, int column) {
    List<Point> neighbours = List();

    bool hasColumnLeft = column > 0;
    bool hasColumnRight = column < (columnCount - 1);
    bool hasRowAbove = row > 0;
    bool hasRowBelow = row < (rowCount - 1);

    // top middle
    if (hasRowAbove) neighbours.add(Point(row - 1, column));

    // top right
    if (hasRowAbove && hasColumnRight)
      neighbours.add(Point(row - 1, column + 1));

    // middle right
    if (hasColumnRight) neighbours.add(Point(row, column + 1));

    // bottom right
    if (hasRowBelow && hasColumnRight)
      neighbours.add(Point(row + 1, column + 1));

    // bottom middle
    if (hasRowBelow) neighbours.add(Point(row + 1, column));

    // bottom left
    if (hasRowBelow && hasColumnLeft)
      neighbours.add(Point(row + 1, column - 1));

    // middle left
    if (hasColumnLeft) neighbours.add(Point(row, column - 1));

    // top left
    if (hasRowAbove && hasColumnLeft)
      neighbours.add(Point(row - 1, column - 1));

    return neighbours;
  }

  /// clears a field by a given [row] & [column]
  GameState clearField(int row, int column) {
    if (fields[row][column].isCleared) return currentState;

    if (fields[row][column].isMined) {
      fields[row][column].isCleared = true;
      currentState = GameState.lost;
    } else {
      _openFieldsRecursive(row, column);
    }

    if (_fieldsLeftToWin() == 0) currentState = GameState.won;

    if (currentState != GameState.running) _clearAll();

    return currentState;
  }

  /// method to clear unmined & uncleared neighbours recursive
  void _openFieldsRecursive(int row, int column) {
    if (!fields[row][column].isMined && !fields[row][column].isCleared) {
      List<Point> neighbourIndexes = _getNeighbourIndices(row, column);
      for (var i = 0; i < neighbourIndexes.length; i++) {
        fields[row][column].isCleared = true;
        if (fields[row][column].numberOfMinesAround < 1)
          // open more fields
          _openFieldsRecursive(neighbourIndexes[i].x, neighbourIndexes[i].y);
      }
    }
  }

  /// determines how many flields are left that need to be cleared
  int _fieldsLeftToWin() {
    int left = 0;

    for (var row = 0; row < rowCount; row++) {
      for (var column = 0; column < columnCount; column++) {
        if (!fields[row][column].isCleared && !fields[row][column].isMined)
          left++;
      }
    }

    return left;
  }

  /// clears all [Field]s in [fields]
  void _clearAll() {
    for (var row = 0; row < rowCount; row++) {
      for (var column = 0; column < columnCount; column++) {
        fields[row][column].isCleared = true;
      }
    }
  }
}

enum GameState {
  running,
  won,
  lost,
}
