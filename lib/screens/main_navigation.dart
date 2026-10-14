import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/nova_glass.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import '../friends/friends_screen.dart';
import '../services/social_service.dart';
import '../widgets/account_dialog.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SocialService.ensureProfile().catchError((_) {});
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      showDialog(context: context, builder: (context) => const AccountDialog());
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const SearchScreen(),
      LibraryScreen(onOpenPlaylist: () {}, onOpenArtist: () {}),
      const FriendsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: NovaBackdrop(child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 330),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(key: ValueKey(_selectedIndex), child: screens[_selectedIndex]),
      )),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22), child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xBB211830),
        selectedItemColor: const Color(0xFFD500F9),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Biblioteca',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Amigos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
        ],
      )),
      ),
    );
  }
}