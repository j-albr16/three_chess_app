import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';


import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as image;

import '../models/piece.dart';
import '../data/image_data.dart';

// HGSDASD


class ImageProv with ChangeNotifier{
  Map<PieceType, Map<PlayerColor, ui.Image>> images = {};
  bool isImagesloaded = false;
  ui.Size size = ui.Size(55,57);

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
        tempImages.add(await loadImage(data));
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

  Future<ui.Image> loadImage(ByteData img) async {
    image.Image baseSizeImage = image.decodeImage(img.buffer.asUint8List());
    image.Image resizeImage = image.copyResize(baseSizeImage, height: size.height.toInt(), width: size.width.toInt());
    ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }



}
