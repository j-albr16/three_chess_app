import 'package:flutter/semantics.dart';

class HttpExeption implements Exception{
  final String message;

  HttpExeption(this.message);

  @override
  String toString(){
    return message;
  }
}