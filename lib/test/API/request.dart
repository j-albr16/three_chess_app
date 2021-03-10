import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:three_chess/models/enums.dart';

class Request {
  static get({String url, Method method}) async {
    final rawData = await http.get(url);

    final Map<String, dynamic> data = json.decode(rawData.body);
    _printRawData(data);
    return data;
  }

  static post({String url, Map<String, dynamic> body, Method method}) async {
    final String jsonBody = json.encode(body);

    final rawData = await http.post(url,
        body: jsonBody, headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> data = json.decode(rawData.body);
    _printRawData(data);
    return data;
  }

  static void _printRawData(Map<String, dynamic> data) {
    print('-' * 200);
    _recursivePrint(data, 0);
  }

  static void _recursivePrint(Map data, int tabIndex) {
    // _cleanPrintOrder(data);
    data.forEach((key, value) {
      if (value is Map) {
        print('\t' * tabIndex + '$key :\n');
        _recursivePrint(value, tabIndex + 1);
      } else {
        print('\t' * tabIndex + '$key : $value \n');
      }
    });
  }

  static void _cleanPrintOrder(Map data) {
    data.forEach((key, value) {
      if (value is Map) {
        data.remove(key);
        if(value.isEmpty){
          data[key] = '{}';
        } else {
          data[key] = value;
        }
      }
    });
  }
}
