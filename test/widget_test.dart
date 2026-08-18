import 'package:flutter_test/flutter_test.dart';
import 'package:flutter12rplthn2627/models/song_model.dart';

void main() {
  test('Sample songs list contains valid songs and unique IDs', () {
    expect(sampleSongs.isNotEmpty, true);
    final ids = sampleSongs.map((s) => s.id).toSet();
    expect(ids.length, sampleSongs.length);
  });

  test('Song playlist navigation wraps around correctly', () {
    final playlist = sampleSongs;
    int currentIndex = 0;

    // Next
    currentIndex = (currentIndex + 1) % playlist.length;
    expect(currentIndex, 1);

    // Previous from 0 wraps to end
    currentIndex = 0;
    currentIndex = (currentIndex - 1 + playlist.length) % playlist.length;
    expect(currentIndex, playlist.length - 1);
  });
}

