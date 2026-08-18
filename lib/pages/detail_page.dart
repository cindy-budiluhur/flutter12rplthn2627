import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_player_provider.dart';

class DetailPage extends StatefulWidget {
  final Song song;
  final List<Song>? playlist;
  final int initialIndex;

  const DetailPage({
    super.key,
    required this.song,
    this.playlist,
    this.initialIndex = 0,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int _currentIndex;

  List<Song> get _playlist =>
      (widget.playlist != null && widget.playlist!.isNotEmpty)
          ? widget.playlist!
          : sampleSongs;

  Song get _currentSong {
    if (_playlist.isNotEmpty &&
        _currentIndex >= 0 &&
        _currentIndex < _playlist.length) {
      return _playlist[_currentIndex];
    }
    return widget.song;
  }

  @override
  void initState() {
    super.initState();
    final songIndex = _playlist.indexWhere((s) => s.id == widget.song.id);
    _currentIndex = songIndex != -1
        ? songIndex
        : (widget.initialIndex >= 0 && widget.initialIndex < _playlist.length
            ? widget.initialIndex
            : 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioPlayerProvider>().playSong(_currentSong);
    });
  }

  void _playNext() {
    if (_playlist.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    });
    context.read<AudioPlayerProvider>().playSong(_currentSong);
  }

  void _playPrevious() {
    if (_playlist.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    });
    context.read<AudioPlayerProvider>().playSong(_currentSong);
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioPlayerProvider>();
    final player = audioProvider.player;
    final song = _currentSong;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            const Text('Now Playing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (_playlist.length > 1)
              Text(
                '${_currentIndex + 1} of ${_playlist.length}',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Hero(
              tag: 'cover_${song.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  song.coverUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(song.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(song.artist, style: TextStyle(fontSize: 15, color: Colors.grey[400])),
            const Spacer(),

            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final durationSec = (player.duration?.inSeconds.toDouble() ?? 0.0);
                final maxDuration = durationSec > 0 ? durationSec : 1.0;

                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble().clamp(0.0, maxDuration),
                      max: maxDuration,
                      activeColor: const Color(0xFF6366F1),
                      inactiveColor: Colors.white10,
                      onChanged: (v) => audioProvider.seek(Duration(seconds: v.toInt())),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(position.toString().split('.').first, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          Text((player.duration ?? Duration.zero).toString().split('.').first, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, size: 36, color: Colors.white),
                  onPressed: _playlist.length > 1 ? _playPrevious : null,
                ),
                const SizedBox(width: 20),
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF6366F1),
                      child: IconButton(
                        icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 34, color: Colors.white),
                        onPressed: audioProvider.togglePlayPause,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, size: 36, color: Colors.white),
                  onPressed: _playlist.length > 1 ? _playNext : null,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}