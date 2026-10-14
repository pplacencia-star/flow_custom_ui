import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_theme.dart';
import '../widgets/mini_player.dart';
import '../services/playlist_service.dart';
import 'saved_tracks_screen.dart';

class LibraryScreen extends StatefulWidget {
  final VoidCallback onOpenPlaylist;
  final VoidCallback onOpenArtist;

  const LibraryScreen({
    super.key,
    required this.onOpenPlaylist,
    required this.onOpenArtist,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String selectedFilter = 'Listas';

  Future<void> createPlaylist() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('Nueva playlist', style: TextStyle(color: Colors.white)),
      content: TextField(controller: controller, autofocus: true, style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(hintText: 'Nombre de la playlist')),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Crear'))],
    ));
    controller.dispose();
    if (name == null || name.trim().isEmpty) return;
    try { await PlaylistService.create(name); }
    catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo crear la playlist'))); }
  }

  void openSaved({String? id, required String name}) => Navigator.push(context,
    MaterialPageRoute(builder: (_) => SavedTracksScreen(playlistId: id, title: name)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'Tu Biblioteca'),
                            TextSpan(
                              text: '.',
                              style: TextStyle(color: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: createPlaylist,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Listas', 'Artistas', 'Álbumes', 'Descargados']
                          .map((chip) {
                            final isSelected = selectedFilter == chip;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(chip),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedFilter = chip;
                                  });
                                },
                                selectedColor: AppColors.accent,
                                backgroundColor: AppColors.card,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tus Me Gusta
                  ListTile(
                    onTap: () => openSaved(name: 'Tus Me Gusta'),
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.likesGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    title: const Text(
                      'Tus Me Gusta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: StreamBuilder(stream: PlaylistService.likes.snapshots(), builder: (context, snapshot) => Text('${snapshot.data?.docs.length ?? 0} canciones · Tu colección', style: const TextStyle(color: AppColors.muted, fontSize: 12))),
                  ),

                  const SizedBox(height: 12),
                  Expanded(child: StreamBuilder(
                    stream: PlaylistService.playlists.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const Center(child: Text('Inicia sesión para ver tus playlists', style: TextStyle(color: Colors.white)));
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      final docs = snapshot.data!.docs;
                      return ListView.builder(itemCount: docs.length, itemBuilder: (context, i) {
                        final doc = docs[i];
                        final name = doc.data()['name']?.toString() ?? 'Playlist';
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 4),
                          onTap: () => openSaved(id: doc.id, name: name),
                          leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(
                            width: 56, height: 56, color: AppColors.card,
                            child: const Icon(Icons.queue_music, color: AppColors.accent))),
                          title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: const Text('Playlist', style: TextStyle(color: AppColors.muted)),
                          trailing: IconButton(
                            tooltip: doc.data()['isPublic'] == true ? 'Hacer privada' : 'Compartir públicamente',
                            icon: Icon(doc.data()['isPublic'] == true ? Icons.public : Icons.lock_outline,
                              color: doc.data()['isPublic'] == true ? AppColors.accent : AppColors.muted),
                            onPressed: () async {
                              final current = doc.data()['isPublic'] == true;
                              try {
                                await PlaylistService.playlists.doc(doc.id).update({'isPublic': !current});
                                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(current ? 'Playlist privada' : 'Playlist pública: visible en tu perfil')));
                              } on FirebaseException catch (e) {
                                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo cambiar la privacidad: ${e.message ?? e.code}')));
                              }
                            },
                          ),
                        );
                      });
                    },
                  )),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: MiniPlayerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
