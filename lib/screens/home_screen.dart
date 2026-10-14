import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/album_card.dart';
import '../widgets/mini_player.dart';
import '../services/audius_service.dart';
import '../services/music_player_service.dart';
import '../widgets/song_actions.dart';
import 'premium_screen.dart';
import '../widgets/nova_glass.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenPlaylist;
  final VoidCallback? onOpenArtist;

  const HomeScreen({super.key, this.onOpenPlaylist, this.onOpenArtist});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Map<String, Future<List<AudiusTrack>>> _genres;
  @override
  void initState() {
    super.initState();
    _genres = {
      'Pop': AudiusService.trending(genre: 'Pop'),
      'Rock': AudiusService.trending(genre: 'Rock'),
      'Hip-Hop': AudiusService.trending(genre: 'Hip-Hop/Rap'),
      'Electrónica': AudiusService.trending(genre: 'Electronic'),
      'Reggaeton': AudiusService.searchTracks('reggaeton'),
      'Indie': AudiusService.trending(genre: 'Indie'),
      'Jazz': AudiusService.trending(genre: 'Jazz'),
      'Clásica': AudiusService.trending(genre: 'Classical'),
    };
  }

  Widget _featured() => FutureBuilder<List<AudiusTrack>>(
    future: _genres['Pop'],
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
      final track = snapshot.data!.first;
      return Padding(padding: const EdgeInsets.only(bottom: 26), child: NovaGlass(
        radius: 28, child: InkWell(onTap: () => MusicPlayerService.instance.playTrack(track),
          child: SizedBox(height: 220, child: Stack(fit: StackFit.expand, children: [
            if (track.artwork.isNotEmpty) Image.network(track.artwork, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFF392053))),
            const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220A0717), Color(0xF20C0718)]))),
            Positioned(left: 20, right: 20, bottom: 18, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('EN ÓRBITA · DESTACADO', style: TextStyle(color: Color(0xFFE9B9FF), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 11)),
                const SizedBox(height: 8),
                Text(track.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w900)),
                Text(track.artist, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                const Row(children: [Icon(Icons.play_circle_fill, color: Colors.white), SizedBox(width: 8), Text('Escuchar ahora', style: TextStyle(color: Colors.white))]),
              ])),
          ]))),
      ));
    },
  );

  Widget musicSection(String genre) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [const Icon(Icons.auto_awesome, size: 17, color: Color(0xFFCD8CFF)), const SizedBox(width: 8), Text(genre, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)), const Spacer(), const Icon(Icons.chevron_right, color: Colors.white54)]),
      const SizedBox(height: 12),
      SizedBox(height: 190, child: FutureBuilder<List<AudiusTrack>>(
        future: _genres[genre],
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator(color: Color(0xFFD500F9)));
          if (snapshot.hasError) return const Text('No se pudo cargar este género', style: TextStyle(color: Colors.grey));
          final tracks = snapshot.data ?? [];
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tracks.length,
            itemBuilder: (context, i) {
              final t = tracks[i];
              return SizedBox(width: 156, child: Column(children: [
                Expanded(child: AlbumCard(title: t.title, artist: t.artist, imageUrl: t.artwork,
                  onTap: () async { try { await MusicPlayerService.instance.playTrack(t); } catch (_) {
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo reproducir')));
                  } })),
                SizedBox(height: 36, child: SongActions(track: t)),
              ]));
            },
          );
        },
      )),
      const SizedBox(height: 24),
    ],
  );

  String _getUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Usuario';

    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!.split(' ').first;
    }

    if (user.email != null && user.email!.contains('@')) {
      final emailName = user.email!.split('@').first;
      return emailName[0].toUpperCase() + emailName.substring(1);
    }

    return 'Usuario';
  }

  @override
  Widget build(BuildContext context) {
    final userName = _getUserDisplayName();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 90.0,
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/icon/app_icon.png', width: 52, height: 52)),
                          const SizedBox(width: 12),
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BIENVENIDO',
                            style: TextStyle(
                              color: Color(0xFFD500F9),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Buenas noches, $userName',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF161224),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                                    const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PremiumScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7445E5), Color(0xFFD500F9)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.workspace_premium,
                              color: Colors.white, size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hazte Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'MX\$49 al mes (modo de prueba)',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _featured(),
                  const Text('Explora tu universo', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 16),
                  for (final genre in _genres.keys) musicSection(genre),
                ],
              ),
            ),

            const Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
