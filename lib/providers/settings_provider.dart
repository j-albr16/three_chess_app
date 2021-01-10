import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';


class Settings with ChangeNotifier {
  Map<String,Object> settings = {};
  Map<String,Object> themeData = {};
  Directory dir;
  String settingsFileName = 'settings.json';
  String themeFileName = 'theme.json';

  Future<Map<String,Object>> getFileContent(String fileName) async {
    print('Getting Settings JSON File');
    Directory dir  = await getDir();
    File file = new File(dir.path + '/' + fileName);
    bool fileExists = await file.exists();
    if (fileExists) {
      Map<String,Object> fileContent = json.decode(file.readAsStringSync());
      return fileContent;
    } else {
      // ToDO make File with standard settings and Temes // Fetch settigns from server
    }
  }

  Future<Directory> getDir() async {
    if (dir == null) {
      dir = await getApplicationDocumentsDirectory();
    }
    return dir;
  }

  void createFile(
      Map<String,Object> content, Directory dir, String fileName) {
    print('Creating JSON Settings FIle');
    File file = new File(dir.path + '/' + fileName);
    file.createSync();
    file.writeAsStringSync(json.encode(content));
  }

  
  void changeFile(Map<String,Object> contentChanges,
      Map<String,Object> content, String fileName) async {
    print('Changing File');
    contentChanges.forEach((key, value) {
      content[key] = value;
    });
    Directory dir = await getDir();
    File file = new File(dir.path + '/' + fileName);
    await file.writeAsString(json.encode(content));
  }
}
