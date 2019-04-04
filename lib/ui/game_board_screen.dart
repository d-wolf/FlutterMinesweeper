import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/helper/index_helper.dart';
import 'package:flutter_minesweeper/models/game_logic.dart';
import 'package:flutter_minesweeper/models/scoped_app_model.dart';
import 'package:flutter_minesweeper/ui/game_settings_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class GameBoardScreen extends StatefulWidget {
  GameBoardScreen();

  @override
  _GameBoardScreenState createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedAppModel>(
        builder: (context, child, scopedAppModel) {
      var screenWidth = MediaQuery.of(context).size.width;
      var size = screenWidth / scopedAppModel.currentGame.columnCount;
      final double border = 1.0;

      return Scaffold(
          appBar: AppBar(
            title: Text('Minesweeper'),
            actions: <Widget>[
              MaterialButton(
                child: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onPressed: () {
                  setState(() {
                    scopedAppModel.startNewGame();
                  });
                },
              ),
              MaterialButton(
                child: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GameSettingsScreen()));
                },
              )
            ],
          ),
          body: GridView.count(
            crossAxisCount: scopedAppModel.currentGame.columnCount,
            children: List.generate(scopedAppModel.currentGame.size, (index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: border, color: Colors.grey[600]),
                ),
                child: GestureDetector(
                  onTapUp: (x) {
                    Point p = IndexHelper.indexAsCoordinate2D(
                        index, scopedAppModel.currentGame.columnCount);
                    _onTapUpField(p.x, p.y, scopedAppModel);
                  },
                  child: Container(
                    width: size - (2 * border),
                    height: size - (2 * border),
                    child: _drawFieldByIndex(index, scopedAppModel),
                  ),
                ),
              );
            }),
          ));
    });
  }

  void _onTapUpField(int row, int column, ScopedAppModel scopedAppModel) {
    GameState state;
    setState(() {
      state = scopedAppModel.currentGame.clearField(row, column);
    });

    switch (state) {
      case GameState.won:
        _showDialogWon();
        break;
      case GameState.lost:
        _showDialogLost();
        break;
      default:
    }
  }

  _drawFieldByIndex(int index, ScopedAppModel scopedAppModel) {
    Point p = IndexHelper.indexAsCoordinate2D(
        index, scopedAppModel.currentGame.columnCount);

    // show standard uncleared field
    if (!scopedAppModel.currentGame.fields[p.x][p.y].isCleared) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.grey),
        ),
        child: Container(
          color: Colors.grey[200],
        ),
      );
    }

    // show cleared field
    if (!scopedAppModel.currentGame.fields[p.x][p.y].isMined &&
        scopedAppModel.currentGame.fields[p.x][p.y].isCleared) {
      var numberOfMinesAround =
          scopedAppModel.currentGame.fields[p.x][p.y].numberOfMinesAround;
      return Container(
        child: numberOfMinesAround != 0
            ? Center(
                child: Text(
                  '$numberOfMinesAround',
                  style:
                      TextStyle(color: _getColorByNumber(numberOfMinesAround)),
                ),
              )
            : Container(),
      );
    }

    // show mined field
    if (scopedAppModel.currentGame.fields[p.x][p.y].isMined &&
        scopedAppModel.currentGame.fields[p.x][p.y].isCleared) {
      return Center(child: Text('💣'));
    }
  }

  void _showDialogWon() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('You won!',
                      style:
                          TextStyle(fontSize: 50.0, color: Colors.grey[600])),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '🎉',
                      style: TextStyle(fontSize: 50.0),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _showDialogLost() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('You lost!',
                      style:
                          TextStyle(fontSize: 50.0, color: Colors.grey[600])),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('👹', style: TextStyle(fontSize: 50.0)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Color _getColorByNumber(int number) {
    switch (number) {
      case 1:
        return Colors.blue[200];
        break;
      case 2:
        return Colors.green[200];
        break;
      case 3:
        return Colors.red[200];
        break;
      case 4:
        return Colors.blue[400];
        break;
      case 5:
        return Colors.green[400];
        break;
      case 6:
        return Colors.red[400];
        break;
      case 7:
        return Colors.blue[600];
        break;
      case 8:
        return Colors.green[600];
        break;
      default:
        return Colors.red[600];
    }
  }
}
