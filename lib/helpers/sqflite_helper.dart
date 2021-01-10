import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

const List<String> createTableQueries= [
  'CREATE TABLE settings(id INTEGER);',
  'CREATE TABLE finished_games()'
];

enum ThemeColors {Purple, Blue, Cyan}

Map<ThemeColors, Color> colorInterface = {
  ThemeColors.Purple : Colors.purpleAccent,
};

class DBHelper{

static String getInitQuery(){
  String query = '';
  createTableQueries.forEach((query) { 
    query += query;
  });
}

static Future<sql.Database>getDB() async {
  final pathDB= await sql.getDatabasesPath();
  return sql.openDatabase(path.join(pathDB , '3chess.db'), 
  onCreate: (db, version) => db.execute(getInitQuery()), version: 1);
}

static Future<void> insert(String table, Map<String, Object> data) async {
  final db = await DBHelper.getDB();
  db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
} 

static Future<List<Map<String, dynamic>>> getData(String table) async {
  final db = await DBHelper.getDB();
  db.query(table);
}

}