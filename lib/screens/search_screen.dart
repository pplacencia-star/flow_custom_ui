import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/mini_player.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  final List<Map<String, dynamic>> genres = const [
    {'title': 'Pop', 'color': Color(0xFFE91E63)},
    {'title': 'Hip-Hop', 'color': Color(0xFF8E24AA)},
    {'title': 'Rock', 'color': Color(0xFFE53935)},
    {'title': 'Electrónica', 'color': Color(0xFF00ACC1)},
    {'title': 'Reggaeton', 'color': Color(0xFFFB8C00)},
    {'title': 'Indie', 'color': Color(0xFF43A047)},
    {'title': 'Jazz', 'color': Color(0xFF3949AB)},
    {'title': 'Clásica', 'color': Color(0xFF5D4037)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buscar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: '¿Qué quieres escuchar?',
                      hintStyle: const TextStyle(color: AppColors.muted),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.muted,
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Explorar todo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      itemCount: genres.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: genre['color'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            genre['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
