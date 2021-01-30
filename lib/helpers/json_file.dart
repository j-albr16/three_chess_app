import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

enum JsonFiles { LocalGame, AnalyzeGame }

const Map<JsonFiles, String> fileNameInterface = {
  JsonFiles.AnalyzeGame: 'analyze-game.json',
  JsonFiles.LocalGame: 'local-game.json',
};

class JsonFile {
  final JsonFiles fileKey;

  JsonFile({this.fileKey});

  String get fileName {
    print('Getting Filename');
    return fileNameInterface[fileKey];
  }

  Future<String> get path async {
    print('Getting Path');
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      return dir.path;
    } catch (error) {
      throw ('Error while getting Path. Error: ' + error);
    }
  }

  Future<File> get getFile async {
    print('Getting File');
    try {
      return new File(await path + '/' + fileName);
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> get jsonMap async {
    print('Retrieving JSON Data from File');
    try {
      File jsonFile = await getFile;
      bool fileExists = await jsonFile.exists();
      if (!fileExists) {
        throw ('File does not Exist');
      }
      String content = await jsonFile.readAsString();
      return json.decode(content);
    } catch (error) {
      throw ('Error while getting JSON Data from File. Error: ' + error);
    }
  }

  Future<void> writeFile(Map<String, String> jsonContent) async {
    print('Writing File');
    try {
      File jsonFile = await getFile;
      bool fileExists = await jsonFile.exists();
      final String encodedContent = json.encode(jsonContent);
      if (fileExists) {
        print('File Exists');
        await jsonFile.writeAsString(encodedContent);
      } else {
        print('File does not exist');
        await jsonFile.create();
        await jsonFile.writeAsString(encodedContent);
      }
    } catch (error) {
      throw ('Error while Writing File. Error: ' + error);
    }
  }
}