import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/album_card.dart';
import '../widgets/mini_player.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onOpenPlaylist;
  final VoidCallback? onOpenArtist;

  const HomeScreen({super.key, this.onOpenPlaylist, this.onOpenArtist});

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
      backgroundColor: const Color(0xFF0D0B14),
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

                  const Text(
                    'Escuchado recientemente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        AlbumCard(
                          title: 'Midnight Memories',
                          artist: 'Cyberwave',
                          imageUrl: 'https://picsum.photos/200?random=1',
                        ),
                        AlbumCard(
                          title: 'Neon Nights',
                          artist: 'Luna Beats',
                          imageUrl: 'https://picsum.photos/200?random=2',
                        ),
                        AlbumCard(
                          title: 'Synthwave Dreams',
                          artist: 'Retro Horizon',
                          imageUrl: 'https://picsum.photos/200?random=3',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Recomendados para ti',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        AlbumCard(
                          title: 'Cosmic Journey',
                          artist: 'Astra',
                          imageUrl: 'https://picsum.photos/200?random=4',
                        ),
                        AlbumCard(
                          title: 'Ethereal Echoes',
                          artist: 'Solaris',
                          imageUrl: 'https://picsum.photos/200?random=5',
                        ),
                      ],
                    ),
                  ),
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
