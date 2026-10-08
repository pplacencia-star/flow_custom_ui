import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/mini_player.dart';

class PlaylistScreen extends StatefulWidget {
  final VoidCallback onBack;
  const PlaylistScreen({super.key, required this.onBack});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool isLiked = false;
  bool isDownloaded = false;
  bool isShuffle = false;
  bool isPlaying = true;

  final List<Map<String, String>> tracks = const [
    {
      'title': 'After Hours',
      'artist': 'The Weeknd',
      'time': '6:01',
      'img': 'https://images.unsplash.com/photo-1576967402682-19976eb930f2?auto=format&fit=crop&w=700&q=85',
    },
    {
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'time': '3:20',
      'img': 'https://images.unsplash.com/photo-1576967402682-19976eb930f2?auto=format&fit=crop&w=700&q=85',
    },
    {
      'title': 'Save Your Tears',
      'artist': 'The Weeknd',
      'time': '3:35',
      'img': 'https://images.unsplash.com/photo-1576967402682-19976eb930f2?auto=format&fit=crop&w=700&q=85',
    },
    {
      'title': 'Starboy',
      'artist': 'The Weeknd, Daft Punk',
      'time': '3:50',
      'img': 'https://images.unsplash.com/photo-1583795483972-8dc136f36e53?auto=format&fit=crop&w=400&q=85',
    },
    {
      'title': 'Die For You',
      'artist': 'The Weeknd',
      'time': '4:20',
      'img': 'https://images.unsplash.com/photo-1583795483972-8dc136f36e53?auto=format&fit=crop&w=400&q=85',
    },
    {
      'title': 'One Of The Girls',
      'artist': 'The Weeknd, JENNIE',
      'time': '4:04',
      'img': 'https://images.unsplash.com/photo-1608319917470-9d9179430f8d?auto=format&fit=crop&w=400&q=85',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra Superior
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: widget.onBack,
                      ),
                      const Text(
                        'HECHA PARA TI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: AppColors.muted,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Portada Grande
                  Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A148C), Color(0xFF1A237E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1608319917470-9d9179430f8d?auto=format&fit=crop&w=400&q=85',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.35),
                            ),
                          ),
                          const Positioned(
                            left: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'noches',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'violetas.',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'VIOLET SELECTS — VOL. 01',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: AppColors.muted,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Detalles
                  const Text(
                    'TU BANDA SONORA DESPUÉS DEL SOL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.muted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Noches violetas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cuando el mundo se apaga, la música sigue.',
                    style: TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'violet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        ' · 24 canciones, 1 h 32 min',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Acciones y Botón Play
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? AppColors.accent : Colors.white,
                            ),
                            onPressed: () => setState(() => isLiked = !isLiked),
                          ),
                          IconButton(
                            icon: Icon(
                              isDownloaded
                                  ? Icons.check_circle
                                  : Icons.download_for_offline_outlined,
                              color: isDownloaded
                                  ? AppColors.accent
                                  : Colors.white,
                            ),
                            onPressed: () =>
                                setState(() => isDownloaded = !isDownloaded),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.shuffle,
                              color: isShuffle
                                  ? AppColors.accent
                                  : Colors.white,
                            ),
                            onPressed: () =>
                                setState(() => isShuffle = !isShuffle),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(isPlaying ? 'Pausar' : 'Play'),
                        onPressed: () => setState(() => isPlaying = !isPlaying),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Lista de Canciones
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final item = tracks[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                item['img']!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          item['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          item['artist']!,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item['time']!,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.more_vert,
                              color: AppColors.muted,
                              size: 18,
                            ),
                          ],
                        ),
                      );
                    },
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
}
