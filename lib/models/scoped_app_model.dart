import 'package:flutter_minesweeper/models/game_logic.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopedAppModel extends Model {
  Game currentGame;

  int rowsCountSetting = 9;
  int columnCountSetting = 9;
  int mineCountSetting = 10;

  ScopedAppModel() {
    currentGame = Game(rowsCountSetting, columnCountSetting, mineCountSetting);
  }

  void startNewGame() {
    currentGame = Game(rowsCountSetting, columnCountSetting, mineCountSetting);
  }
}
