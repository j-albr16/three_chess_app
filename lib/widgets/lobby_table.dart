import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:three_chess/models/game.dart';

class LobbyTable extends StatefulWidget {
  List<Game> games;

  LobbyTable({@required this.games});
  @override
  _LobbyTableState createState() => _LobbyTableState();
}

class _LobbyTableState extends State<LobbyTable> {
  bool sort = false;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
            label: Text("Spieler 1"),
            numeric: false,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              mergeSort(widget.games,
                  end: widget.games.length,
                  compare: (Game game, Game game2) => game.player[0].user.userName.compareTo(game2.player[0].user.userName));
            }),
        DataColumn(
            label: Text("1. Wertung"),
            numeric: true,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              mergeSort(widget.games,
                  end: widget.games.length,
                  compare: (Game game, Game game2) => game.player[0].user.score.compareTo(game2.player[0].user.score));
            }),
        DataColumn(
            label: Text("Spieler 2"),
            numeric: false,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                String username1 = game.player[1]?.user.userName ?? "";
                String username2 = game2.player[1]?.user.userName ?? "";
                return username1.compareTo(username2);
              });
            }),
        DataColumn(
            label: Text("2. Wertung"),
            numeric: true,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              mergeSort(widget.games, end: widget.games.length, compare: (Game game, Game game2) {
                int score1 = game.player[1]?.user.score ?? "";
                int score2 = game2.player[1]?.user.score ?? "";
                return score1.compareTo(score2);
              });
            }),
        DataColumn(
            label: Text("Zeit"),
            numeric: true,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              mergeSort(
                widget.games,
                end: widget.games.length,
                //compare: (Game game, Game game2) => game..compareTo(game2.player[0].user.score)
              );
            }),
        DataColumn(label: Text("Modus")),
      ],
      rows: [],
    );
  }
}
