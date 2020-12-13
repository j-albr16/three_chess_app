import 'package:flutter_sound/flutter_sound.dart';

enum Sound {
  Capture, LowTime, Move, SocialNotify
}

const Map<Sound, String> soundLinks = {
  Sound.Capture : '../../assets/sound/favs/Capture.mp3',
  Sound.LowTime :  '../../assets/sound/favs/LowTime.mp3',
  Sound.Move :  '../../assets/sound/favs/Move.mp3',
  Sound.SocialNotify :  '../../assets/sound/favs/SocialNotify.mp3',
};

class Sounds {
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();


void playSound(Sound sound, Function callback) async {
    // audio session needs to opened AND cosed
    _myPlayer.openAudioSession().then((_) async {
      await _myPlayer.startPlayer(
        codec: Codec.mp3,
        fromURI: soundLinks[sound],
        whenFinished: () {
          _myPlayer.stopPlayer();
          _myPlayer.closeAudioSession();
          _myPlayer = null;
          return callback();
        },
      );
    });
  }
}
