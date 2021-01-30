// import 'package:audioplayers/audioplayers.dart';
// import 'package:three_chess/helpers/notWebError.dart' if (dart.library.js) "package:three_chess/helpers/jsSound.dart";
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_sound/flutter_sound.dart';

enum Sound { Capture, LowTime, Move, SocialNotify, Check }

const Map<Sound, String> soundLinks = {
  Sound.Capture: ('sound/favs/Capture.mp3'),
  Sound.LowTime: 'sound/favs/LowTime.mp3',
  Sound.Move: 'sound/favs/Move.mp3',
  Sound.SocialNotify: 'sound/favs/SocialNotify.mp3',
};

class Sounds {
  static final Map<Sound, Audio> soundAudio = {
    Sound.Capture: Audio('assets/sound/favs/Capture.mp3'),
    Sound.LowTime:  Audio('assets/sound/favs/LowTime.mp3'),
    Sound.Move:  Audio('assets/sound/favs/Move.mp3'),
    Sound.SocialNotify:  Audio('assets/sound/favs/SocialNotify.mp3'),
  };

  static playSound(Sound sound){
    AssetsAudioPlayer.playAndForget(soundAudio[sound]);
  }

}
