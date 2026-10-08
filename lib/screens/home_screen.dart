import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/album_card.dart';
import '../widgets/mini_player.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenPlaylist;
  final VoidCallback onOpenArtist;

  const HomeScreen({
    super.key,
    required this.onOpenPlaylist,
    required this.onOpenArtist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TU MÚSICA, TU MOMENTO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.1,
                              ),
                              children: [
                                TextSpan(text: 'Buenas noches,\nAlex'),
                                TextSpan(
                                  text: '.',
                                  style: TextStyle(color: AppColors.accent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.accent,
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Greeting Tabs
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: const Text(
                          'Para ti',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Descubrir',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Recent Grid (2 Columnas)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildGridItem(
                        'Noches violetas',
                        'https://images.unsplash.com/photo-1608319917470-9d9179430f8d?auto=format&fit=crop&w=400&q=85',
                        onOpenPlaylist,
                      ),
                      _buildGridItem(
                        'En tu órbita',
                        'https://images.unsplash.com/photo-1565145368739-29e5a81be478?auto=format&fit=crop&w=400&q=85',
                        onOpenPlaylist,
                      ),
                      _buildGridItem(
                        'The Weeknd',
                        'https://images.unsplash.com/photo-1576967402682-19976eb930f2?auto=format&fit=crop&w=700&q=85',
                        onOpenArtist,
                      ),
                      _buildLikesGridItem('Tus Me Gusta', onOpenPlaylist),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Escuchado recientemente
                  _buildSectionHeader('Escuchado recientemente'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onOpenArtist,
                          child: const AlbumCardWidget(
                            title: 'After Hours',
                            subtitle: 'The Weeknd',
                            imageUrl: 'https://images.unsplash.com/photo-1576967402682-19976eb930f2?auto=format&fit=crop&w=700&q=85',
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: onOpenPlaylist,
                          child: const AlbumCardWidget(
                            title: 'Noches violetas',
                            subtitle: 'Hecha para desconectar',
                            imageUrl: 'https://images.unsplash.com/photo-1608319917470-9d9179430f8d?auto=format&fit=crop&w=400&q=85',
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: onOpenPlaylist,
                          child: const AlbumCardWidget(
                            title: 'En tu órbita',
                            subtitle: 'Tu universo sonoro',
                            imageUrl: 'https://images.unsplash.com/photo-1565145368739-29e5a81be478?auto=format&fit=crop&w=400&q=85',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recomendado para ti
                  _buildSectionHeader('Recomendado para ti'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        AlbumCardWidget(
                          title: 'Indie after dark',
                          subtitle: 'Un poco de magia',
                          imageUrl: 'https://images.unsplash.com/photo-1565145368739-29e5a81be478?auto=format&fit=crop&w=400&q=85',
                        ),
                        SizedBox(width: 12),
                        AlbumCardWidget(
                          title: 'Late night drive',
                          subtitle: 'Sin un destino',
                          imageUrl: 'https://images.unsplash.com/photo-1608319917470-9d9179430f8d?auto=format&fit=crop&w=400&q=85',
                        ),
                        SizedBox(width: 12),
                        AlbumCardWidget(
                          title: 'Deep focus',
                          subtitle: 'Encuentra tu ritmo',
                          imageUrl: 'https://images.unsplash.com/photo-1583795483972-8dc136f36e53?auto=format&fit=crop&w=400&q=85',
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Ver todo',
            style: TextStyle(color: AppColors.accent, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(String title, String imageUrl, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1425),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Image.network(
                imageUrl,
                width: 44,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesGridItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1425),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E24AA), Color(0xFFD81B60)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
