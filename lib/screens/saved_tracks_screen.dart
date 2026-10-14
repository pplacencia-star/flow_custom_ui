import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/playlist_service.dart';
import '../services/likes_repository.dart';
import '../services/audius_service.dart';
import '../services/music_player_service.dart';
import '../widgets/song_actions.dart';

class SavedTracksScreen extends StatelessWidget {
  final String? playlistId;
  final String title;
  final String? ownerId;
  final bool readOnly;
  const SavedTracksScreen({super.key, this.playlistId, required this.title, this.ownerId, this.readOnly = false});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF161224)),
    body: playlistId == null ? StreamBuilder<List<AudiusTrack>>(
      stream: LikesRepository.songs,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('No se pudieron cargar tus favoritos'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final tracks = snapshot.data!;
        if (tracks.isEmpty) return const Center(child: Text('Todavía no hay canciones', style: TextStyle(color: Colors.white)));
        return ListView.builder(itemCount: tracks.length, itemBuilder: (context, i) => _tile(context, tracks[i], null));
      },
    ) : StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(ownerId ?? FirebaseAuth.instance.currentUser!.uid).collection('playlists').doc(playlistId).collection('tracks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('No se pudieron cargar las canciones', style: TextStyle(color: Colors.white)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('Todavía no hay canciones', style: TextStyle(color: Colors.white)));
        return ListView.builder(itemCount: docs.length, itemBuilder: (context, i) {
          final track = PlaylistService.fromDocument(docs[i].data());
          return _tile(context, track, playlistId);
        });
      },
    ),
  );
  Widget _tile(BuildContext context, AudiusTrack track, String? playlistId) => ListTile(
    leading: track.artwork.isEmpty ? const Icon(Icons.music_note, color: Colors.white)
      : Image.network(track.artwork, width: 50, height: 50, fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.music_note, color: Colors.white)),
    title: Text(track.title, style: const TextStyle(color: Colors.white)),
    subtitle: Text(track.artist, style: const TextStyle(color: Colors.grey)),
    trailing: readOnly ? const Icon(Icons.play_arrow, color: Colors.white70) : playlistId == null ? SongActions(track: track) : IconButton(
      icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
      onPressed: () => PlaylistService.remove(playlistId, track.id)),
    onTap: () async {
      try { await MusicPlayerService.instance.playTrack(track); }
      catch (_) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo reproducir'))); }
    },
  );

}
