import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music-Nova',
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}
