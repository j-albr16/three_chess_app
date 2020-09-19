import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/piece.dart';
import '../data/image_data.dart';



class ImageProv with ChangeNotifier{
  bool isLoaded = false;

  Map<PieceType, Map<PlayerColor, ui.Image>> _images = {

  };

  Map<PieceType, Map<PlayerColor,ui.Image>> get images{
    return {..._images};
  }

  // ImageProv(){
  //   addImages();
  // }

  addImages(){
    ImageData.assetPaths.entries.forEach((typeElement) {
      typeElement.value.entries.forEach((colorElement) {
        loadUiImage(colorElement.value).then((value) => _images[typeElement.key][colorElement.key] = value);
      });
    });
  }


  // Future<ui.Image> loadUiImage(String imageAssetPath) async {
  //   widgets.Image widgetsImage = widgets.Image.asset(imageAssetPath);
  //   Completer<ui.Image> completer = Completer<ui.Image>();
  //   widgetsImage.image
  //       .resolve(widgets.ImageConfiguration(size: ui.Size(10, 10)))
  //       .addListener(widgets.ImageStreamListener((widgets.ImageInfo info, bool _){
  //     completer.complete(info.image);
  //   }));
  //   return completer.future;
  // }

  Future <ui.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final image = await loadImage(new Uint8List.view(data.buffer));
    return image;
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      isLoaded = true;
      notifyListeners();
      return completer.complete(img);
    });
    return completer.future;
  }


}
