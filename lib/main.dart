import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MusicNovaApp());
}

class MusicNovaApp extends StatelessWidget {
  const MusicNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music-Nova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const NavigationScreen(),
    );
  }
}

class MusicItem {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;

  MusicItem({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
  });
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final YoutubeExplode _yt = YoutubeExplode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  MusicItem? _currentSong;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;

  final List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
  }

  Future<void> _playSong(MusicItem song) async {
    try {
      if (mounted) setState(() => _isLoadingAudio = true);

      await _audioPlayer.stop();

      // Extracción directa de YouTube usando cliente de YouTube Music / Web
      final manifest = await _yt.videos.streamsClient.getManifest(
        song.id,
        ytClients: [YoutubeApiClient.mweb, YoutubeApiClient.android],
      );

      // Obtener el stream de audio solo con bitrate alto
      final audioStreamInfo = manifest.audioOnly.withHighestBitrate();
      final streamUrl = audioStreamInfo.url.toString();

      if (streamUrl.isNotEmpty) {
        // Enviar cabeceras completas para autenticar la conexión con YouTube Music
        await _audioPlayer.setUrl(
          streamUrl,
          headers: {
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
            'Origin': 'https://music.youtube.com',
            'Referer': 'https://music.youtube.com/',
          },
        );

        await _audioPlayer.play();

        if (mounted) {
          setState(() {
            _isLoadingAudio = false;
            _isPlaying = true;
          });
        }
      } else {
        throw Exception("No se pudo obtener el stream directo.");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAudio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al reproducir: $e'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _searchHistory.removeWhere(
        (item) => item.toLowerCase() == query.toLowerCase(),
      );
      _searchHistory.insert(0, query);
    });
  }

  void _removeFromHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
  }

  @override
  void dispose() {
    _yt.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        yt: _yt,
        currentSong: _currentSong,
        isPlaying: _isPlaying,
        onPlaySong: _playSong,
        onTogglePlayPause: _togglePlayPause,
      ),
      SearchScreen(
        yt: _yt,
        currentSong: _currentSong,
        isPlaying: _isPlaying,
        onPlaySong: _playSong,
        onTogglePlayPause: _togglePlayPause,
        searchHistory: _searchHistory,
        onAddToHistory: _addToHistory,
        onRemoveFromHistory: _removeFromHistory,
      ),
      const LibraryScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music-Nova'),
        backgroundColor: Colors.deepPurple.shade900,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: screens[_currentIndex]),
          if (_currentSong != null)
            Container(
              color: const Color(0xFF282828),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Image.network(
                    _currentSong!.thumbnailUrl,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.music_note, size: 40),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentSong!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currentSong!.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isLoadingAudio
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E1E),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Biblioteca',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
        ],
      ),
    );
  }
}

Future<List<MusicItem>> fetchMusicSearchResults(
  String query,
  YoutubeExplode yt,
) async {
  if (kIsWeb) {
    try {
      final url = Uri.parse(
        'https://pipedapi.kavin.rocks/search?q=$query&filter=music_songs',
      );
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final items = data['items'] as List?;
        if (items != null) {
          return items
              .map((item) {
                final urlStr = item['url'] ?? '';
                final videoId = urlStr.contains('v=')
                    ? urlStr.split('v=').last
                    : '';
                return MusicItem(
                  id: videoId,
                  title: item['title'] ?? 'Sin título',
                  author: item['uploaderName'] ?? 'Artista',
                  thumbnailUrl:
                      item['thumbnail'] ??
                      'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
                );
              })
              .where((song) => song.id.isNotEmpty)
              .toList();
        }
      }
    } catch (_) {}
  }

  final searchList = await yt.search.search('$query music');
  return searchList.map((video) {
    return MusicItem(
      id: video.id.value,
      title: video.title,
      author: video.author,
      thumbnailUrl: video.thumbnails.lowResUrl,
    );
  }).toList();
}

class HomeScreen extends StatefulWidget {
  final YoutubeExplode yt;
  final MusicItem? currentSong;
  final bool isPlaying;
  final Function(MusicItem) onPlaySong;
  final VoidCallback onTogglePlayPause;

  const HomeScreen({
    super.key,
    required this.yt,
    required this.currentSong,
    required this.isPlaying,
    required this.onPlaySong,
    required this.onTogglePlayPause,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MusicItem> _featuredList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeaturedSongs();
  }

  Future<void> _loadFeaturedSongs() async {
    try {
      final results = await fetchMusicSearchResults(
        'YouTube Music Hits',
        widget.yt,
      );
      if (mounted) {
        setState(() {
          _featuredList = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _featuredList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Recomendaciones para ti',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                );
              }

              final song = _featuredList[index - 1];
              final isSelected = widget.currentSong?.id == song.id;

              return ListTile(
                leading: Image.network(
                  song.thumbnailUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.music_note, size: 40),
                ),
                title: Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.purpleAccent : Colors.white,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  song.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isSelected && widget.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.purpleAccent,
                    size: 36,
                  ),
                  onPressed: () {
                    if (isSelected) {
                      widget.onTogglePlayPause();
                    } else {
                      widget.onPlaySong(song);
                    }
                  },
                ),
              );
            },
          );
  }
}

class SearchScreen extends StatefulWidget {
  final YoutubeExplode yt;
  final MusicItem? currentSong;
  final bool isPlaying;
  final Function(MusicItem) onPlaySong;
  final VoidCallback onTogglePlayPause;
  final List<String> searchHistory;
  final Function(String) onAddToHistory;
  final Function(String) onRemoveFromHistory;

  const SearchScreen({
    super.key,
    required this.yt,
    required this.currentSong,
    required this.isPlaying,
    required this.onPlaySong,
    required this.onTogglePlayPause,
    required this.searchHistory,
    required this.onAddToHistory,
    required this.onRemoveFromHistory,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MusicItem> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    widget.onAddToHistory(query);
    _searchController.text = query;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final results = await fetchMusicSearchResults(query, widget.yt);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar canciones o artistas...',
              prefixIcon: const Icon(Icons.search, color: Colors.purpleAccent),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.purpleAccent),
                onPressed: () => _performSearch(_searchController.text),
              ),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: _performSearch,
          ),
        ),
        if (!_hasSearched && widget.searchHistory.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Búsquedas Recientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.searchHistory.length,
              itemBuilder: (context, index) {
                final term = widget.searchHistory[index];
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(term),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () => widget.onRemoveFromHistory(term),
                  ),
                  onTap: () => _performSearch(term),
                );
              },
            ),
          ),
        ] else
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final song = _searchResults[index];
                      final isSelected = widget.currentSong?.id == song.id;

                      return ListTile(
                        leading: Image.network(
                          song.thumbnailUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.music_note, size: 40),
                        ),
                        title: Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.purpleAccent
                                : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          song.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isSelected && widget.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.purpleAccent,
                            size: 36,
                          ),
                          onPressed: () {
                            if (isSelected) {
                              widget.onTogglePlayPause();
                            } else {
                              widget.onPlaySong(song);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tu Biblioteca', style: TextStyle(fontSize: 18)),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Perfil de Usuario', style: TextStyle(fontSize: 18)),
    );
  }
}
