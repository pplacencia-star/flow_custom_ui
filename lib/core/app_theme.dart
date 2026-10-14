import 'package:flutter/material.dart';

class AppColors {
  // Colores base extraídos de :root y CSS
  static const Color background = Color(0xFF100E16);
  static const Color phoneBg = Color(0xFF0F0A1C);
  static const Color accent = Color(0xFF8B5CF6);
  static const Color muted = Color(0xFF8E859F);
  static const Color card = Color(0xFF21172F);
  static const Color recentGridCard = Color(0xFF241A34);
  static const Color textPrimary = Color(0xFFF7F5FC);
  static const Color border = Color(0x2280619C);

  // Degradados extraídos del CSS
  static const LinearGradient likesGradient = LinearGradient(
    colors: [Color(0xFF7445E5), Color(0xFF372557)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient miniPlayerGradient = LinearGradient(
    colors: [Color(0xF2352442), Color(0xF2271B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient playlistHeroGradient = RadialGradient(
    center: Alignment(0.0, -0.3),
    radius: 0.85,
    colors: [Color(0xFF553081), Color(0xFF28163F), Color(0xFF0F0A1C)],
    stops: [0.0, 0.47, 0.85],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.phoneBg,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: AppColors.phoneBg,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'DM Sans',
        ),
      ),
    );
  }
}
