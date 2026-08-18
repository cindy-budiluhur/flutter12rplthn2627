import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Song? _currentSong;

  AudioPlayerProvider() {
    _player.playerStateStream.listen((_) {
      notifyListeners();
    });
  }

  AudioPlayer get player => _player;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;

  Future<void> playSong(Song song) async {
    // Jika lagu yang sama masih diputar, tidak perlu setUrl ulang
    if (_currentSong?.id == song.id) {
      // Jika lagunya sedang di-pause, kita play lagi
      if (!_player.playing) await _player.play();
      return;
    }

    try {
      _currentSong = song;
      if (song.audioUrl.startsWith('http://') || song.audioUrl.startsWith('https://')) {
        await _player.setUrl(song.audioUrl);
      } else {
        final assetPath = song.audioUrl.startsWith('assets/')
            ? song.audioUrl.replaceFirst('assets/', '')
            : song.audioUrl;
        await _player.setAsset(assetPath);
      }
      await _player.play();
      
      // Notify setelah URL di-set dan play dipanggil, agar UI update
      notifyListeners(); 
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void togglePlayPause() {
    _player.playing ? _player.pause() : _player.play();
    notifyListeners();
  }

  Future<void> stopSong() async {
    await _player.stop();
    _currentSong = null;
    notifyListeners();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
