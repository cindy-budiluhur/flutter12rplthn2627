import 'package:flutter/material.dart';
import 'package:flutter12rplthn2627/models/song_model.dart';
import 'package:flutter12rplthn2627/widgets/song_card.dart';

class FavoritePage extends StatefulWidget {
  final List<Song> favoriteSongs;
  final void Function(Song)? onFavoriteToggle;

  const FavoritePage({
    super.key,
    required this.favoriteSongs,
    this.onFavoriteToggle,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Song> displaySongs;

  @override
  void initState() {
    super.initState();
    displaySongs = List.from(widget.favoriteSongs);
  }

  void _handleRemove(Song song) {
    setState(() {
      displaySongs.removeWhere((item) => item.id == song.id);
    });

    widget.onFavoriteToggle?.call(song);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Favorite Songs (${widget.favoriteSongs.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.favoriteSongs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada lagu favorit',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = widget.favoriteSongs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SongCard(
                    song: song,
                    isFavorite: true,
                    onFavoriteToggle: () => _handleRemove(song),
                  ),
                );
              },
            ),
    );
  }
}
