import 'dart:convert';

import 'package:http/http.dart' as http;

class AudiusTrack {
  final String id;
  final String title;
  final String artist;
  final String artwork;

  AudiusTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.artwork,
  });

  factory AudiusTrack.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final artwork = json['artwork'] as Map<String, dynamic>? ?? {};

    return AudiusTrack(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? 'Sin título',
      artist: user['name']?.toString() ?? 'Artista desconocido',
      artwork:
          artwork['480x480']?.toString() ??
          artwork['150x150']?.toString() ??
          '',
    );
  }
}

class AudiusService {
  static const String baseUrl = 'https://api.audius.co/v1';

  static Future<List<AudiusTrack>> searchTracks(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final uri = Uri.parse('$baseUrl/tracks/search')
        .replace(queryParameters: {'query': query.trim(), 'limit': '20'});

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error al buscar canciones: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final tracks = json['data'] as List<dynamic>? ?? [];

    return tracks
        .map((track) => AudiusTrack.fromJson(track as Map<String, dynamic>))
        .toList();
  }

  static String getStreamUrl(String trackId) {
    return '$baseUrl/tracks/${Uri.encodeComponent(trackId)}/stream';
  }
}
