import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/mini_player.dart';
import '../services/audius_service.dart';
import '../services/music_player_service.dart';
import '../widgets/song_actions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<AudiusTrack> results = [];

  bool isSearching = false;
  bool hasSearched = false;

  String? searchError;

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

  Future<void> searchMusic(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        results = [];
        hasSearched = false;
        searchError = null;
      });
      return;
    }

    setState(() {
      isSearching = true;
      hasSearched = true;
      searchError = null;
    });

    try {
      final tracks = await AudiusService.searchTracks(query);

      if (!mounted) return;

      setState(() {
        results = tracks;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        searchError = 'No se pudieron cargar las canciones.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isSearching = false;
        });
      }
    }
  }

  Future<void> openGenre(String name) async {
    final genre = switch (name) {
      'Hip-Hop' => 'Hip-Hop/Rap',
      'Electrónica' => 'Electronic',
      'Clásica' => 'Classical',
      _ => name,
    };
    setState(() { isSearching = true; hasSearched = true; searchError = null; results = []; });
    try {
      final songs = name == 'Reggaeton'
          ? await AudiusService.searchTracks('reggaeton')
          : await AudiusService.trending(genre: genre);
      if (mounted) setState(() => results = songs);
    } catch (_) {
      if (mounted) setState(() => searchError = 'No se pudo cargar este género');
    } finally {
      if (mounted) setState(() => isSearching = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                    controller: searchController,
                    onSubmitted: searchMusic,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          hasSearched = false;
                          results = [];
                          searchError = null;
                        });
                      }
                    },
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

                  Text(
                    hasSearched ? 'Resultados' : 'Explorar todo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: isSearching
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD500F9),
                            ),
                          )
                        : searchError != null
                        ? Center(
                            child: Text(
                              searchError!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : hasSearched
                        ? buildResults()
                        : buildGenres(),
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

  Widget buildGenres() {
    return GridView.builder(
      itemCount: genres.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final genre = genres[index];

        return InkWell(
          onTap: () => openGenre(genre['title'] as String),
          borderRadius: BorderRadius.circular(10),
          child: Container(
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
          ),
        );
      },
    );
  }

  Widget buildResults() {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron canciones.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final track = results[index];

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 250 + (index % 7) * 65),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(offset: Offset(0, 15 * (1 - value)), child: child),
          ),
          child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: track.artwork.isNotEmpty
                ? Image.network(
                    track.artwork,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    // ignore: unnecessary_underscores
                    errorBuilder: (_, __, _) =>
                        const Icon(Icons.music_note, color: Colors.white),
                  )
                : const Icon(Icons.music_note, color: Colors.white),
          ),

          title: Text(track.title, style: const TextStyle(color: Colors.white)),

          subtitle: Text(
            track.artist,
            style: const TextStyle(color: Colors.grey),
          ),

          trailing: SongActions(track: track),

          onTap: () async {
            try {
              await MusicPlayerService.instance.playTrack(track);
            } catch (error) {
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No se pudo reproducir esta canción.'),
                ),
              );
            }
          },
        ),
        );
      },
    );
  }
}
