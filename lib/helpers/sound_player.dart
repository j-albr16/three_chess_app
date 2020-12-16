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

  // AssetsAudioPlayer _assetsAudioPlayer;
  //
  // Future<void> loadSounds() async {
  //   _assetsAudioPlayer = AssetsAudioPlayer();
  //   _assetsAudioPlayer.open(Audio(soundLinks[Sound.Capture]));
  //   // await soundLinks.forEach((key, value) async{
  //   //   await loadedSounds.putIfAbsent(key,() {
  //   //     AssetsAudioPlayer _assetsAudioPlayer = new AssetsAudioPlayer();
  //   //    _assetsAudioPlayer.open(Audio(
  //   //       value
  //   //     ));
  //   //     return _assetsAudioPlayer;
  //   //   });
  //   // });
  // }
  //
  // Future<void> playSound(Sound sound) async {
  //   try {
  //     await _assetsAudioPlayer.play();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // FlutterSound _flutterSound;

  // Future<FlutterSoundPlayer> initAudioSession() async {
  //   _flutterSound = new FlutterSound();
  //   return _flutterSound.thePlayer.openAudioSession(
  //     category: SessionCategory.playAndRecord,
  //     mode: SessionMode.modeDefault,
  //     focus: AudioFocus.requestFocusAndKeepOthers,
  //   );
  // }

  // Future<void> playSound(Sound sound, Function whenFinishedCallback) async {
  //   _flutterSound.thePlayer.startPlayer(
  //     codec: Codec.mp3,
  //     fromURI: soundLinks[sound],
  //     whenFinished: whenFinishedCallback,
  //   );
  // }

  // Future<void> disposeAudioSession() async {
  //   await _flutterSound.thePlayer.closeAudioSession();
  //   _flutterSound = null;
  // }
}
