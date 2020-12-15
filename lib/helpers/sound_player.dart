import 'package:audioplayers/audio_cache.dart';
import 'dart:js' as js;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum Sound { Capture, LowTime, Move, SocialNotify, Check }

const Map<Sound, String> soundLinks = {
  Sound.Capture: 'sound/favs/Capture.mp3',
  Sound.LowTime: 'sound/favs/LowTime.mp3',
  Sound.Move: 'sound/favs/Move.mp3',
  Sound.SocialNotify: 'sound/favs/SocialNotify.mp3',
};

class Sounds {
  static final _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  static Future<void> playSound(Sound sound) async {
    // audio session needs to opened AND cosed
    if (kIsWeb) {
      js.context.callMethod('playAudio', [soundLinks[sound]]);
    } else {
      await _audioPlayer.play(soundLinks[sound],
          isLocal: true, stayAwake: true);
    }
  }
}
