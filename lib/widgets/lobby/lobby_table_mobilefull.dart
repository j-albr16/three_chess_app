import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import '../../providers/game_provider.dart';
import '../../providers/lobby_provider.dart';
import '../../models/online_game.dart';

typedef void GameSelectCall(OnlineGame game);

class LobbyTable extends StatefulWidget {
  final GameProvider gameProvider;
  final LobbyProvider lobbyProvider;

  final GameSelectCall onGameTap;
  final List<ColumnType> selectedColumns;

  final double height;
  final double width;

  ThemeData theme;

  LobbyTable(
      {this.width = 1000,
      this.height = 1000,
      this.theme,
      this.lobbyProvider,
      this.gameProvider,
      this.onGameTap,
      this.selectedColumns});

  @override
  _LobbyTableState createState() => _LobbyTableState();
}

enum ColumnType {
  UserNames,
  UserName1,
  UserName2,
  AverageScore,
  Time,
  Mode,
  Fullness
}

typedef Widget ColumnCell(OnlineGame game);
typedef int GameCompare(OnlineGame game, OnlineGame game2);

class _LobbyTableState extends State<LobbyTable> {
  GameSelectCall onGameTap;
  List<OnlineGame> games;
  List<Widget> _columns;
  ScrollController _scrollController;

  BorderSide borderSide = BorderSide(width: 1, color: Colors.grey);
  List<ColumnType> _selectedColoumn;

  List<ColumnType> get selectedColoumn => _selectedColoumn;

  ColumnType _sortSelectedColumn;
  bool _ascending = false;

  ColumnType get sortSelectedColumn {
    return _sortSelectedColumn;
  }

  bool get ascending {
    return _ascending;
  }

  void set sortSelectedColumn(ColumnType type) {
    sortSelectedColumnOld = _sortSelectedColumn;
    _sortSelectedColumn = type;
  }

  void set ascending(bool newAsc) {
    ascendingOld = _ascending;
    _ascending = newAsc;
  }

  ColumnType sortSelectedColumnOld;
  bool ascendingOld;

  double rowHeigth = 60;
  double rowHeaderHeigth = 60;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) => loadWidgets(Theme.of(context)));
    loadWidgets(widget.theme);
    _loadComparisons();
    _selectedColoumn = List.from(widget.selectedColumns, growable: true) ??
        List.from(ColumnType.values, growable: true);
    _scrollController = ScrollController()
      ..addListener(() => _scrollListener());
    onGameTap = widget.onGameTap;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _resort() {
    if (sortSelectedColumnOld != null && ascendingOld != null) {
      _sortGames(sortSelectedColumnOld, ascendingOld);
    }
    _sortGames(sortSelectedColumn, ascending);
  }

  _resortAndUpdate(List<OnlineGame> newGames) {
    games = List.from(newGames, growable: true);

    if (sortSelectedColumnOld != null && ascendingOld != null) {
      _sortGames(sortSelectedColumnOld, ascendingOld);
    }
    _sortGames(sortSelectedColumn, ascending);
  }

  Map<ColumnType, GameCompare> gameComparison;

  GameCompare switchCompare(bool doSwitch, GameCompare gameCompare) {
    if (doSwitch) {
      return (OnlineGame game2, OnlineGame game1) => gameCompare(game2, game1);
    } else {
      return gameCompare;
    }
  }

  void _loadComparisons() {
    gameComparison = {
      ColumnType.UserNames: (OnlineGame game, OnlineGame game2) {
        return 0;
      },
      ColumnType.UserName1: (OnlineGame game, OnlineGame game2) {
        return game.player[0].user.userName
            .compareTo(game2.player[0].user.userName);
      },
      ColumnType.UserName2: (OnlineGame game, OnlineGame game2) {
        String username1 =
            game.player.length > 1 ? game.player[1]?.user.userName ?? "" : "";
        String username2 =
            game2.player.length > 1 ? game2.player[1]?.user.userName ?? "" : "";
        return username1.compareTo(username2);
      },
      ColumnType.AverageScore: (OnlineGame game, OnlineGame game2) {
        return _avgScore(game).compareTo(_avgScore(game2));
      },
      ColumnType.Time: (OnlineGame game, OnlineGame game2) {
        return (game.time + game.increment * 38)
            .compareTo(game2.time + game2.increment * 38);
      },
      ColumnType.Mode: (OnlineGame game, OnlineGame game2) {
        if (game.isRated && !game2.isRated) {
          return 1;
        } else if (game.isRated == game2.isRated) {
          return 0;
        } else if (!game.isRated && game2.isRated) {
          return -1;
        }
        return 0;
      },
      ColumnType.Fullness: (OnlineGame game, OnlineGame game2) {
        return (game.player.length).compareTo(game2.player.length);
      },
    };
  }

  String _user(int i, OnlineGame game) {
    if (i < game.player.length) {
      return game.player[i]?.user.userName ?? "";
    }
    return "";
  }

  String _score(int i, OnlineGame game) {
    if (i < game.player.length) {
      return game.player[i]?.user.score.toString() ?? "";
    }
    return "";
  }

  int _avgScore(OnlineGame game) {
    int averageScore = 0;
    for (int i = 0; i < game.player.length; i++) {
      averageScore +=
          game.player[i]?.user?.score ?? 1; //TODO Shouldnt need null aware
    }
    if (game.player.length == 0) {
      return 0;
    }
    return averageScore ~/ game.player.length;
  }

  _sortGames(ColumnType ctype, bool ascending) {
    if (ctype != null) {
      if (!ascending) {
        mergeSort(games, end: games.length, compare: gameComparison[ctype]);
      } else {
        mergeSort(games,
            end: games.length,
            compare: (OnlineGame game, OnlineGame game2) =>
                gameComparison[ctype](game2, game));
      }
    }
    setState(() {
      _columns = selectedColoumn.map((e) => orderColumn(e)).toList();
    });
  }

  void _onHeaderTap(ColumnType ctype) {
    if (sortSelectedColumn != ctype) {
      ascending = true;
      sortSelectedColumn = ctype;
      _sortGames(ctype, ascending);
    } else {
      ascending = !ascending;
      _sortGames(ctype, ascending);
    }
  }

  //########################################################################
  // v Code for Design

  Map<ColumnType, String> columnHeader = {
    ColumnType.UserNames: "Players",
    ColumnType.UserName1: "Player 1",
    ColumnType.UserName2: "Player 2",
    ColumnType.AverageScore: "Avg. Score",
    ColumnType.Time: "Time",
    ColumnType.Mode: "Mode",
    ColumnType.Fullness: "x/3",
  };

  Map<ColumnType, double> columnFlex = {
    ColumnType.UserNames: 3,
    ColumnType.UserName1: 1,
    ColumnType.UserName2: 1,
    ColumnType.AverageScore: 3,
    ColumnType.Time: 2,
    ColumnType.Mode: 3,
    ColumnType.Fullness: 1,
  };

  Widget getHeader(ColumnType type, ThemeData theme) {
    return Center(
        child: Text(columnHeader[type],
            style: theme.textTheme.subtitle1.copyWith(
                fontSize:
                    16))); // TODO GestureDetector for sorting TODO I DONT THINK SO ANYMORE
  }

  Widget orderColumn(ColumnType e) {
    return Container(
        //decoration: BoxDecoration(border: Border(left: borderSide, right: borderSide)),
        key: ValueKey(0),
        child: Column(children: getColumnChilds(e)));
  }

  Map<ColumnType, ColumnCell> columnWidget;

  void loadWidgets(ThemeData theme) {
    columnWidget = {
      ColumnType.UserNames: (OnlineGame game) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Spacer(),
                Text(_user(0, game), style: theme.textTheme.bodyText1),
                Spacer(),
                Align(
                  child:
                      Text(_score(0, game), style: theme.textTheme.bodyText1),
                  alignment: Alignment.centerRight,
                ),
                Spacer()
              ]),
              Row(children: [
                Spacer(),
                Text(_user(1, game), style: theme.textTheme.bodyText1),
                Spacer(),
                Align(
                  child:
                      Text(_score(1, game), style: theme.textTheme.bodyText1),
                  alignment: Alignment.centerRight,
                ),
                Spacer()
              ]),
            ],
          ),
      ColumnType.UserName1: (OnlineGame game) => Row(children: [
            Spacer(),
            Text(_user(0, game), style: theme.textTheme.bodyText1),
            Spacer(),
            Align(
              child: Text(_score(0, game), style: theme.textTheme.bodyText1),
              alignment: Alignment.centerRight,
            ),
            Spacer()
          ]),
      ColumnType.UserName2: (OnlineGame game) => Row(children: [
            Spacer(),
            Text(_user(1, game), style: theme.textTheme.bodyText1),
            Spacer(),
            Align(
              child: Text(_score(1, game), style: theme.textTheme.bodyText1),
              alignment: Alignment.centerRight,
            ),
            Spacer()
          ]),
      ColumnType.AverageScore: (OnlineGame game) => Center(
            child: Text("~" + _avgScore(game).toString(),
                style: theme.textTheme.bodyText1),
          ),
      ColumnType.Time: (OnlineGame game) => Center(
          child: Text(
              ((game.time - (game.time % 60)) / 60).toString() +
                  ":" +
                  (game.time % 60).toString() +
                  " + " +
                  game.increment.toString(),
              style: theme.textTheme.bodyText1)),
      ColumnType.Mode: (OnlineGame game) => Center(
          child: Text(game.isRated ? "Rated" : "Unrated",
              style: theme.textTheme.bodyText1)),
      ColumnType.Fullness: (OnlineGame game) => Center(
          child: Text(game.player.length.toString() + "/3",
              style: theme.textTheme.bodyText1)),
    };
  }

  double getWidth(ColumnType type) {
    return ((widget.width /
            columnFlex.entries
                .where((element) => selectedColoumn.contains(element.key))
                .toList()
                .map((e) => e.value)
                .toList()
                .fold(0, (previousValue, element) => previousValue + element)) *
        columnFlex[type]);
  }

  Widget wrapCell({ColumnType type, Widget child}) {
    return Container(
        decoration:
            BoxDecoration(border: Border(top: borderSide, bottom: borderSide)),
        child: SizedBox(
            height: rowHeigth,
            width: getWidth(type),
            child: Padding(
                padding: EdgeInsets.only(left: 17, right: 17), child: child)));
  }

  Widget wrapHeaderCell({ColumnType type, Widget child}) {
    return Container(
      decoration:
          BoxDecoration(border: Border(top: borderSide, bottom: borderSide)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onHeaderTap(type),
        child: SizedBox(
          height: rowHeigth,
          width: getWidth(type),
          child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: sortSelectedColumn != type
                  ? child
                  : Stack(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                                !ascending
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: Colors.lightBlue,
                                size: 10)),
                        Center(child: child)
                      ],
                    )),
        ),
      ),
    );
  }

  //########################################################################
  //Putting it together

  List<Widget> getColumnChilds(ColumnType type, {bool noHeader = false}) {
    List<Widget> result = [];
    if (!noHeader) {
      result.add(wrapHeaderCell(
        type: type,
        child: getHeader(type, Theme.of(context)),
      ));
    }
    for (OnlineGame game in games) {
      result.add(wrapCell(
        type: type,
        child: columnWidget[type](game),
      ));
    }
    return result;
  }

  Widget backgroundTable(ThemeData theme) {
    List<Widget> rowColumns = [];
    for (ColumnType ctype in selectedColoumn) {
      rowColumns.add(Column(
        children: List.generate(
            games.length,
            (index) => (rowColumns.isEmpty && index == 0)
                ? IgnorePointer(
                    child: wrapHeaderCell(type: ctype, child: Container()),
                  )
                : wrapCell(type: ctype, child: Container())),
      ));
    }
    return Row(
      children: rowColumns,
    );
  }

  Widget foregroundTable(ThemeData theme) {
    List<Widget> columnRows = [];
    columnRows.add(IgnorePointer(
        child: Container(
      width: widget.width,
      height: rowHeaderHeigth,
      color: Colors.transparent,
    )));
    for (int i = 0; i < games.length; i++) {
      columnRows.add(InkWell(
          onTap: () {
            print(games[i].id);
            onGameTap(games[i]);
          },
          child: Container(
            width: widget.width,
            height: rowHeigth,
            color: Colors.transparent,
          )));
    }
    return Column(
      children: columnRows,
    );
  }

  bool _canReorder = true;
  bool _isDragging = false;

  _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      _canReorder = true;
    } else if (_isDragging) {
      _scrollController.jumpTo(0.0);
    } else {
      _canReorder = false;
    }
  }

  Widget whenScrollingTable() {
    return Row(
        children: selectedColoumn
            .map((e) => Column(children: getColumnChilds(e, noHeader: true)))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    games = widget.lobbyProvider?.lobbyGames
            ?.where((element) => element.player.length < 3)
            ?.toList() ??
        [];

    _resort();

    void _onReorder(int oldIndex, int newIndex) {
      _isDragging = false;
      setState(() {
        ColumnType type = _selectedColoumn.removeAt(oldIndex);

        Widget child = _columns.removeAt(oldIndex);

        _selectedColoumn.insert(newIndex, type);
        _columns.insert(newIndex, child);
      });
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Stack(children: [
            backgroundTable(theme),
            //!_canReorder ? whenScrollingTable() : ReorderableRow(
            ReorderableRow(
              buildDraggableFeedback: (context, constraints, child) {
                _isDragging = true;
                return Material(
                  child: ConstrainedBox(constraints: constraints, child: child),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                );
              },
              draggingWidgetOpacity: 0.1,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _columns,
              onReorder: _onReorder,
              onNoReorder: (_) => _isDragging = false,
              scrollController: _scrollController,
            ),
            foregroundTable(theme),
          ]),
        ),
      ),
      /* if(!_canReorder) IgnorePointer(
            child: Stack(
              children: [
                Container(color: Colors.red, height: rowHeaderHeigth, width: widget.width,),
                Align(alignment: AlignmentDirectional.topCenter ,child: Row(children: selectedColoumn.map((e) => wrapHeaderCell(
                  type: e,
                  child: getHeader(e))).toList(),
              ),
              )],
            ),
          ),
      ]),*/
    );
  }
}
