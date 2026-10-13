import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unnecessary_import
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/audius_service.dart';
import '../services/playlist_service.dart';

class SongActions extends StatelessWidget {
  final AudiusTrack track;
  const SongActions({super.key, required this.track});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      StreamBuilder<bool>(
        stream: PlaylistService.liked(track.id),
        builder: (context, snapshot) => IconButton(
          tooltip: 'Me gusta',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              snapshot.data == true ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(snapshot.data == true),
              color: snapshot.data == true
                  ? const Color(0xFFD500F9)
                  : Colors.grey,
            ),
          ),
          onPressed: () async {
            try {
              await PlaylistService.toggleLike(track);
            } catch (error) {
              if (context.mounted) _message(context, _friendlyError(error));
            }
          },
        ),
      ),
      IconButton(
        tooltip: 'Añadir a playlist',
        icon: const Icon(Icons.playlist_add, color: Colors.white),
        onPressed: () => _selectPlaylist(context),
      ),
    ],
  );

  static String _friendlyError(Object error) {
    if (FirebaseAuth.instance.currentUser == null)
      // ignore: curly_braces_in_flow_control_structures
      return 'Inicia sesión para guardar música';
    if (error is FirebaseException) {
      if (error.code == 'permission-denied')
        // ignore: curly_braces_in_flow_control_structures
        return 'Firestore rechazó el acceso. Revisa las reglas de seguridad.';
      if (error.code == 'unavailable')
        // ignore: curly_braces_in_flow_control_structures
        return 'Sin conexión con Firestore. Comprueba Internet.';
      return 'Error de Firebase (${error.code}): ${error.message ?? ''}';
    }
    return 'No se pudo guardar: $error';
  }

  static void _message(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          backgroundColor: const Color(0xFF7445E5),
        ),
      );

  Future<void> _selectPlaylist(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF161224),
      builder: (sheetContext) => StreamBuilder(
        stream: PlaylistService.playlists.snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError)
            // ignore: curly_braces_in_flow_control_structures
            return Center(
              child: Text(
                _friendlyError(snapshot.error!),
                style: const TextStyle(color: Colors.white),
              ),
            );
          if (!snapshot.hasData)
            // ignore: curly_braces_in_flow_control_structures
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty)
            // ignore: curly_braces_in_flow_control_structures
            return const Center(
              child: Text(
                'Crea primero una playlist en Biblioteca',
                style: TextStyle(color: Colors.white),
              ),
            );
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: const Icon(Icons.queue_music, color: Color(0xFFD500F9)),
              title: Text(
                docs[i].data()['name']?.toString() ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () async {
                try {
                  await PlaylistService.add(docs[i].id, track);
                  if (!sheetContext.mounted) return;
                  Navigator.pop(sheetContext);
                  if (context.mounted)
                    // ignore: curly_braces_in_flow_control_structures
                    _message(context, '¡Canción añadida a la playlist!');
                } catch (_) {
                  if (sheetContext.mounted)
                    // ignore: curly_braces_in_flow_control_structures
                    _message(
                      sheetContext,
                      'No se pudo guardar la canción. Comprueba Firestore.',
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
