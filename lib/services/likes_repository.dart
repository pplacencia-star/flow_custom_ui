import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audius_service.dart';

/// Favoritos locales por cuenta: funcionan incluso sin conexión a Firestore.
/// Al volver a abrir la aplicación se intenta sincronizar con Firebase.
class LikesRepository {
  static final _updates = StreamController<void>.broadcast();
  static Map<String, Map<String, dynamic>> _items = {};
  static String? _loadedUid;
  static Future<void>? _loading;

  static String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Debes iniciar sesión');
    return user.uid;
  }

  static String _key(String uid) => 'music_nova_likes_v2_$uid';

  static Future<void> initialize() async {
    final uid = _uid;
    if (_loadedUid == uid) return;
    if (_loading != null) await _loading;
    if (_loadedUid == uid) return;
    final completer = Completer<void>();
    _loading = completer.future;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(uid));
      final parsed = raw == null ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
      _items = parsed.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
      _loadedUid = uid;
      _updates.add(null);
      // Se evita bloquear la interfaz cuando Firestore no está disponible.
      unawaited(_syncFromRemote(uid));
    } finally {
      completer.complete();
      _loading = null;
    }
  }

  static Future<void> _persist(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(uid), jsonEncode(_items));
    _updates.add(null);
  }

  static Map<String, dynamic> _data(AudiusTrack track) => {
    'id': track.id, 'title': track.title,
    'artist': track.artist, 'artwork': track.artwork,
  };

  static Future<void> toggle(AudiusTrack track) async {
    await initialize();
    final uid = _uid;
    final wasLiked = _items.containsKey(track.id);
    if (wasLiked) { _items.remove(track.id); }
    else { _items[track.id] = _data(track); }
    await _persist(uid);
    // Guardar en el dispositivo tiene prioridad; no mostrar error de red
    // por una acción que ya se realizó correctamente de forma local.
    unawaited(_writeRemote(uid, track.id, !wasLiked, _data(track)));
  }

  static Future<void> _writeRemote(String uid, String id, bool liked, Map<String, dynamic> data) async {
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(uid).collection('likes').doc(id);
      if (liked) { await ref.set({...data, 'addedAt': FieldValue.serverTimestamp()}); }
      else { await ref.delete(); }
    } catch (_) {
      // Se mantiene el favorito local y se reintentará al iniciar de nuevo.
    }
  }

  static Future<void> _syncFromRemote(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('likes').get(const GetOptions(source: Source.server)).timeout(const Duration(seconds: 5));
      if (_loadedUid != uid) return;
      for (final doc in snapshot.docs) {
        _items.putIfAbsent(doc.id, () => Map<String, dynamic>.from(doc.data())..remove('addedAt'));
      }
      await _persist(uid);
      for (final entry in _items.entries) {
        await _writeRemote(uid, entry.key, true, entry.value);
      }
    } catch (_) {
      // Firestore no disponible: la biblioteca local continúa funcionando.
    }
  }

  static Stream<bool> liked(String id) async* {
    await initialize();
    yield _items.containsKey(id);
    yield* _updates.stream.map((_) => _items.containsKey(id));
  }

  static Stream<List<AudiusTrack>> get songs async* {
    await initialize();
    yield _tracks();
    yield* _updates.stream.map((_) => _tracks());
  }

  static List<AudiusTrack> _tracks() => _items.values.map((d) => AudiusTrack(
    id: d['id']?.toString() ?? '',
    title: d['title']?.toString() ?? 'Sin título',
    artist: d['artist']?.toString() ?? 'Artista desconocido',
    artwork: d['artwork']?.toString() ?? '',
  )).toList().reversed.toList();
}
