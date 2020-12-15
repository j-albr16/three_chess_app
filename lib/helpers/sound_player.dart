import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

enum Sound { Capture, LowTime, Move, SocialNotify }

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
    await _audioPlayer.play(soundLinks[sound], isLocal: true, stayAwake: true);
  }
}
