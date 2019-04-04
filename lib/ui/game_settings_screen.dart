import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/models/scoped_app_model.dart';
import 'package:scoped_model/scoped_model.dart';

class GameSettingsScreen extends StatefulWidget {
  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  double _rowCountSetting = 1.0;
  double _columnCountSetting = 1.0;
  double _mineCountSetting = 1.0;

  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedAppModel>(
        builder: (context, child, scopedAppModel) {
      if (!_isInitialized) {
        _isInitialized = true;
        _rowCountSetting = scopedAppModel.rowsCountSetting.toDouble();
        _columnCountSetting = scopedAppModel.columnCountSetting.toDouble();
        _mineCountSetting = scopedAppModel.mineCountSetting.toDouble();
      }

      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            MaterialButton(
              child: Icon(
                Icons.check,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              onPressed: () {
                scopedAppModel.rowsCountSetting = _rowCountSetting.toInt();
                scopedAppModel.columnCountSetting = _columnCountSetting.toInt();
                scopedAppModel.mineCountSetting = _mineCountSetting.toInt();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _getDifficultyIndocator(),
              Text(
                'Rows: ${_rowCountSetting.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Slider(
                  min: 1.0,
                  max: 10.0,
                  value: _rowCountSetting,
                  onChanged: (double newVal) {
                    if (newVal * _columnCountSetting < 2) return;
                    setState(() {
                      if ((newVal * _columnCountSetting) - 1 <
                          _mineCountSetting) {
                        _mineCountSetting = (newVal * _columnCountSetting) - 1;
                      }
                      _rowCountSetting = newVal;
                    });
                  }),
              Text(
                'Columns: ${_columnCountSetting.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Slider(
                  min: 1.0,
                  max: 10.0,
                  value: _columnCountSetting,
                  onChanged: (double newVal) {
                    if (newVal * _rowCountSetting < 2) return;
                    setState(() {
                      if ((newVal * _rowCountSetting) - 1 < _mineCountSetting) {
                        _mineCountSetting = (newVal * _rowCountSetting) - 1;
                      }
                      _columnCountSetting = newVal;
                    });
                  }),
              Text(
                'Mines: ${_mineCountSetting.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Slider(
                  min: 1.0,
                  max: (_columnCountSetting * _rowCountSetting) - 1,
                  value: _mineCountSetting,
                  onChanged: (double newVal) {
                    setState(() {
                      _mineCountSetting = newVal;
                    });
                  }),
            ],
          ),
        ),
      );
    });
  }

  double _getDifficultyInPercent() {
    double minMineCount = 1;
    double maxMineCount =
        ((_columnCountSetting * _rowCountSetting) - 1) - minMineCount;
    return _mineCountSetting * 100 / maxMineCount;
  }

  Widget _getDifficultyIndocator() {
    double difficultyInPercent = _getDifficultyInPercent();
    TextStyle style = TextStyle(fontSize: 80.0, color: Colors.grey[600]);

    if (difficultyInPercent >= 80)
      return Column(
        children: <Widget>[
          Text(
            '😱',
            style: style,
          ),
          Text(
            'Hard',
            style: style,
          )
        ],
      );
    if (difficultyInPercent >= 30)
      return Column(
        children: <Widget>[
          Text(
            '😲',
            style: style,
          ),
          Text(
            'Medium',
            style: style,
          )
        ],
      );
    return Column(
      children: <Widget>[
        Text(
          '😎',
          style: style,
        ),
        Text(
          'Easy',
          style: style,
        )
      ],
    );
  }
}
