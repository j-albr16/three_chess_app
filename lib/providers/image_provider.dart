import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/piece.dart';
import '../data/image_data.dart';

// HGSDASD


class ImageProv with ChangeNotifier{
  Map<PieceType, Map<PlayerColor, ui.Image>> images = {};
  bool isImagesloaded = false;

  ImageProv(){
    init();
  }

  Future <Null> init() async {
    List tempImages = [];
    List piecT = [];
    List playC = [];
    images = {};
    Map pathStrings = ImageData.assetPaths;
    for(PieceType pieceType in pathStrings.keys.toList()){
      for(PlayerColor playerColor in pathStrings[pieceType].keys.toList()){
        final ByteData data = await rootBundle.load(ImageData.assetPaths[pieceType][playerColor]);
        tempImages.add(await loadImage(new Uint8List.view(data.buffer)));
        piecT.add(pieceType);
        playC.add(playerColor);
      }
    }
    for(int i = 0; i < piecT.length; i ++){
      Map<PlayerColor, ui.Image> colors = {};
      for(int j = 0; j < 3; j++){
        colors[playC[j]] = tempImages[i];
      }
      images[piecT[i]] = colors;
    }
    print(images.toString());

      isImagesloaded = true;
      notifyListeners();
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {

      return completer.complete(img);
    });
    return completer.future;
  }



}
