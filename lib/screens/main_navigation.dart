import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'playlist_screen.dart';
import 'artist_screen.dart';
import '../widgets/account_dialog.dart';
import '../widgets/mini_player.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openPlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlaylistScreen(onBack: () => Navigator.pop(context)),
      ),
    );
  }

  void _openArtist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ArtistScreen(onBack: () => Navigator.pop(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onOpenPlaylist: _openPlaylist, onOpenArtist: _openArtist),
      const SearchScreen(),
      LibraryScreen(onOpenPlaylist: _openPlaylist, onOpenArtist: _openArtist),
      const AccountScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0B14),
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: screens),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayerWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161224),
        selectedItemColor: const Color(0xFFD500F9),
        unselectedItemColor: Colors.grey,
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
