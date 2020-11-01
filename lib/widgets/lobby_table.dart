import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:three_chess/models/game.dart';
import 'dart:core';

typedef void GameSelectCall(Game game);

class LobbyTable extends StatefulWidget {
  List<Game> games;
  GameSelectCall onGameTap;

  LobbyTable({@required this.games, @required this.onGameTap, Key key}) : super(key: key);

  @override
  LobbyTableState createState() => LobbyTableState();
}

enum ColumnType { UserName1, UserName2, AverageScore, Time, Mode, Fullness }

class LobbyTableState extends State<LobbyTable> {
  bool isSettingsMode = false;

  bool sort = false;
  List<ColumnType> selectedColoumn;
  List<Widget> get selectedColoumnWidgets {
    print("im looking it up again");
    return selectedColoumn
        .map((e) => ListTile(
              key: ValueKey(columnHeader[e]),
              title: Text(columnHeader[e]),
            ))
        .toList();
  }

  Map<ColumnType, String> columnHeader = {
    ColumnType.UserName1: "Player 1",
    ColumnType.UserName2: "Player 2",
    ColumnType.AverageScore: "Average Score",
    ColumnType.Time: "Time",
    ColumnType.Mode: "Mode",
    ColumnType.Fullness: "x/3",
  };

  @override
  void initState() {
    selectedColoumn = ColumnType.values;
    super.initState();
  }

  void goIntoSettingsMode() {
    setState(() {
      isSettingsMode = true;
    });
  }

  void goIntoLobbyMode() {
    setState(() {
      isSettingsMode = false;
    });
  }

  List<Widget> getCellChilds(Game game) {
    String user(int i) {
      if (i < game.player.length) {
        return game.player[i]?.user.userName ?? "";
      }
      return "";
    }

    String score(int i) {
      if (i < game.player.length) {
        return game.player[i]?.user.score.toString() ?? "";
      }
      return "";
    }

    List<Widget> result = [];
    for (ColumnType type in selectedColoumn) {
      switch (type) {
        case ColumnType.UserName1:
          result.add(Row(children: [
            Text(user(0)),
            Expanded(child: Container()),
            Align(
              child: Text(score(0)),
              alignment: Alignment.centerRight,
            )
          ]));
          break;
        case ColumnType.UserName2:
          result.add(Row(children: [
            Text(user(1)),
            Expanded(child: Container()),
            Align(
              child: Text(score(1)),
              alignment: Alignment.centerRight,
            )
          ]));
          break;
        case ColumnType.AverageScore:
          int averageScore = 0;
          for (int i = 0; i < game.player.length; i++) {
            averageScore += game.player[i].user.score;
          }
          averageScore = averageScore ~/ game.player.length;
          result.add(Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text("~" + averageScore.toString()),
            ),
          ));
          break;
        case ColumnType.Time:
          result.add(Text(((game.time - (game.time % 60)) / 60).toString() +
              ":" +
              (game.time % 60).toString() +
              " + " +
              game.increment.toString()));
          break;
        case ColumnType.Mode:
          result.add(Text(game.isRated ? "Rated" : "Unrated"));
          break;
        case ColumnType.Fullness:
          result.add(Text(game.player.length.toString() + "/3"));
          break;
      }
    }
    return result;
  }

  List<DataColumn> getColoumnChilds() {
    List<DataColumn> result = [];
    for (ColumnType type in selectedColoumn) {
      switch (type) {
        case ColumnType.UserName1:
          result.add(DataColumn(
              label: Text(columnHeader[ColumnType.UserName1]),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                ascending = !sort;
                mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                  if (ascending) {
                    return game.player[0].user.userName.compareTo(game2.player[0].user.userName);
                  }
                  return game2.player[0].user.userName.compareTo(game.player[0].user.userName);
                });
              }));
          break;
        case ColumnType.UserName2:
          result.add(DataColumn(
              label: Text(columnHeader[ColumnType.UserName2]),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });

                ascending = !sort;
                mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                  String username1 = game.player.length > 1 ? game.player[1]?.user.userName ?? "" : "";
                  String username2 = game2.player.length > 1 ? game2.player[1]?.user.userName ?? "" : "";
                  if (ascending) {
                    return username1.compareTo(username2);
                  }
                  return username2.compareTo(username1);
                });
              }));
          break;
        case ColumnType.AverageScore:
          result.add(DataColumn(
              label: Text(columnHeader[ColumnType.AverageScore]),
              numeric: true,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                ascending = !sort;
                mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                  int averageScore1 = 0;
                  for (int i = 0; i < game.player.length; i++) {
                    averageScore1 += game.player[i].user.score;
                  }
                  averageScore1 = averageScore1 ~/ game.player.length;
                  int averageScore2 = 0;
                  for (int i = 0; i < game2.player.length; i++) {
                    averageScore2 += game2.player[i].user.score;
                  }
                  averageScore2 = averageScore2 ~/ game2.player.length;
                  if (ascending) {
                    return averageScore1.compareTo(averageScore2);
                  }
                  return averageScore2.compareTo(averageScore1);
                });
              }));
          break;
        case ColumnType.Time:
          result.add(DataColumn(
              label: Text(columnHeader[ColumnType.Time]),
              numeric: true,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                ascending = !sort;
                mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                  if (ascending) {
                    return (game.time + game.increment * 38).compareTo(game2.time + game2.increment * 38);
                  }
                  return (game2.time + game2.increment * 38).compareTo(game.time + game.increment * 38);
                });
              }));
          break;
        case ColumnType.Mode:
          result.add(DataColumn(
              label: Text(columnHeader[ColumnType.Mode]),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                ascending = !sort;
                mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                  if (game.isRated && !game2.isRated) {
                    return ascending ? 1 : -1;
                  } else if (game.isRated == game2.isRated) {
                    return 0;
                  } else if (!game.isRated && game2.isRated) {
                    return ascending ? -1 : 1;
                  }
                });
              }));
          break;
        case ColumnType.Fullness:
          result.add(DataColumn(
              label: Text(columnHeader[ColumnType.Fullness]),
              numeric: true,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                ascending = !sort;
                mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                  if (ascending) {
                    return (game.player.length).compareTo(game2.player.length);
                  }
                  return (game2.player.length).compareTo(game.player.length);
                });
              }));
          break;
      }
    }
    return result;
  }

  // void _updateSelected(int oldI, int newI) {
  //   if (oldI < newI) {
  //     newI -= 1;
  //   }

  //   final ColumnType element = selectedColoumn.removeAt(oldI);
  //   selectedColoumn.insert(newI, element);
  // }

  // Widget editSettings() {
  //   return ReorderableListView(
  //     children: selectedColoumnWidgets,
  //     onReorder: (oldI, newI) => setState(() => _updateSelected(oldI, newI)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      sortAscending: sort,
      columns: getColoumnChilds(),
      rows: widget.games.map((game) {
        return DataRow(
            onSelectChanged: (_) {
              widget.onGameTap(game);
            },
            cells: getCellChilds(game).map((info) => DataCell(info)).toList());
      }).toList(),
    );
  }
}

class longPressDataColoum extends DataColumn {
  longPressDataColoum(
      // @required this.label,
      // this.tooltip,
      // this.numeric = false,
      // this.onSort,
      );
}
