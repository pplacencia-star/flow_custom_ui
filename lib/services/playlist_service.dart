import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'audius_service.dart';
import 'likes_repository.dart';

class PlaylistService {
  static final _db = FirebaseFirestore.instance;
  static String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Inicia sesión para guardar música');
    return user.uid;
  }

  static CollectionReference<Map<String, dynamic>> get playlists =>
      _db.collection('users').doc(uid).collection('playlists');
  static CollectionReference<Map<String, dynamic>> get likes =>
      _db.collection('users').doc(uid).collection('likes');

  static Map<String, dynamic> trackData(AudiusTrack t) => {
    'id': t.id, 'title': t.title, 'artist': t.artist,
    'artwork': t.artwork, 'addedAt': FieldValue.serverTimestamp(),
  };

  static Future<void> create(String name) async {
    if (name.trim().isEmpty) throw ArgumentError('Escribe un nombre');
    await playlists.add({'name': name.trim(), 'isPublic': false,
      'createdAt': FieldValue.serverTimestamp()});
  }

  static Future<void> add(String playlistId, AudiusTrack track) =>
      playlists.doc(playlistId).collection('tracks').doc(track.id).set(trackData(track));

  static Future<void> remove(String playlistId, String trackId) =>
      playlists.doc(playlistId).collection('tracks').doc(trackId).delete();

  static Stream<bool> liked(String trackId) => LikesRepository.liked(trackId);

  static Future<void> toggleLike(AudiusTrack track) => LikesRepository.toggle(track);

  static AudiusTrack fromDocument(Map<String, dynamic> d) => AudiusTrack(
    id: d['id']?.toString() ?? '',
    title: d['title']?.toString() ?? 'Sin título',
    artist: d['artist']?.toString() ?? 'Artista desconocido',
    artwork: d['artwork']?.toString() ?? '',
  );
}
