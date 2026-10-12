import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/mini_player.dart';

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

  final List<Map<String, String>> items = const [
    {
      'title': 'Noches violetas',
      'subtitle': 'Playlist • 24 canciones',
      'imageUrl': 'https://images.unsplash.com/photo-1608319917470-9d9179430f8d?auto=format&fit=crop&w=400&q=85',
      'type': 'playlist',
    },
    {
      'title': 'En tu órbita',
      'subtitle': 'Playlist • 32 canciones',
      'imageUrl': 'https://images.unsplash.com/photo-1565145368739-29e5a81be478?auto=format&fit=crop&w=400&q=85',
      'type': 'playlist',
    },
    {
      'title': 'The Weeknd',
      'subtitle': 'Artista • Siguiendo',
      'imageUrl': 'https://images.unsplash.com/photo-1576967402682-19976eb930f2?auto=format&fit=crop&w=700&q=85',
      'type': 'artist',
    },
  ];

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
                        onPressed: () {},
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
                    onTap: widget.onOpenPlaylist,
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
                    subtitle: const Text(
                      '128 canciones · Tu colección',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isArtist = item['type'] == 'artist';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          onTap: isArtist
                              ? widget.onOpenArtist
                              : widget.onOpenPlaylist,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isArtist ? 28 : 8,
                            ),
                            child: Image.network(
                              item['imageUrl']!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            item['subtitle']!,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.more_vert,
                            color: AppColors.muted,
                          ),
                        );
                      },
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
}
