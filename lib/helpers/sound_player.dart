import 'package:audioplayers/audioplayers.dart';
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
AudioPlayer _audioPlayer = AudioPlayer();


Future<void> playSound(Sound sound) async {
    // audio session needs to opened AND cosed
    int result = await _audioPlayer.play(soundLinks[sound], isLocal: true);
    if(result == 1){
      // succes
      print('Audio was Player');
    }
}
}
