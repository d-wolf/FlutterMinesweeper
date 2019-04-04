import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/models/scoped_app_model.dart';
import 'package:flutter_minesweeper/ui/game_board_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(
    ScopedModel<ScopedAppModel>(model: new ScopedAppModel(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: GameBoardScreen(),
    );
  }
}
