import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/painting.dart' show decodeImageFromList;

import '../models/piece.dart';
import '../data/image_data.dart';

// zacharicha
class nothin{}

class ImageProv with ChangeNotifier{
  bool isLoaded = false;

  Map<PieceType, Map<PlayerColor,ui.Image>> _images;

  Map<PieceType, Map<PlayerColor,ui.Image>> get images{
    return {..._images};
  }

   ImageProv(){
    addImages();
  }

// load the image async and then draw with `canvas.drawImage(image, Offset.zero, Paint());`
  Future<ui.Image> loadImageAsset(String assetName) async {
    final data = await rootBundle.load(assetName);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  addImages(){
    _images = {};
    ImageData.assetPaths.entries.forEach((typeElement) {
      Map<PlayerColor, ui.Image> currColor = {};
      typeElement.value.entries.forEach((colorElement) {
        loadImageAsset(ImageData.assetPaths[typeElement.key][colorElement.key]).then((value) { currColor[colorElement.key] = value;
        });
      });
      _images[typeElement.key] = currColor;
    });
    isLoaded = true;
  }





}
