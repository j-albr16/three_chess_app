import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as image;

import '../models/enums.dart';
import '../data/image_data.dart';

// HGSDASD


class ImageProv with ChangeNotifier{
  Map<PieceKey, ui.Image> images = {};
  bool isImagesLoaded = false;
  ui.Size size = ui.Size(55,57);

  ImageProv(){
    init();
  }

  Future <Null> init() async {


    images = {};
    Map pathStrings = ImageData.assetPaths;

    for(MapEntry<PieceKey, String> assetEntry in pathStrings.entries.toList()){
        final ByteData data = await rootBundle.load(assetEntry.value);
        images[assetEntry.key] =  await loadImage(data);
    }
      isImagesLoaded = true;
    notifyListeners();
  }

  Future<ui.Image> loadImage(ByteData img) async {
    image.Image baseSizeImage = image.decodeImage(img.buffer.asUint8List());
    image.Image resizeImage = image.copyResize(baseSizeImage, height: size.height.toInt(), width: size.width.toInt());
    ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }



}
