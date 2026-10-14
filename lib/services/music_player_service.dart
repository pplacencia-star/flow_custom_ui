import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'audius_service.dart';

class MusicPlayerService extends ChangeNotifier {
  MusicPlayerService._() {
    player.playerStateStream.listen((state) {
      notifyListeners();
    });

    player.positionStream.listen((position) {
      notifyListeners();
    });

    player.durationStream.listen((duration) {
      notifyListeners();
    });
  }

  static final MusicPlayerService instance = MusicPlayerService._();

  final AudioPlayer player = AudioPlayer();

  AudiusTrack? currentTrack;

  bool get isPlaying => player.playing;

  bool get isLoading =>
      player.processingState == ProcessingState.loading ||
      player.processingState == ProcessingState.buffering;

  Duration get position => player.position;

  Duration get duration => player.duration ?? Duration.zero;

  Future<void> playTrack(AudiusTrack track) async {
    try {
      await player.stop();

      currentTrack = track;
      notifyListeners();

      final url = AudiusService.getStreamUrl(track.id);

      await player.setUrl(url);

      player.play().catchError((Object error) {
        debugPrint('Error durante la reproducción: $error');
      });
    } catch (error) {
      debugPrint('Error al reproducir: $error');
      rethrow;
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> seek(Duration newPosition) async {
    await player.seek(newPosition);
  }

  Future<void> forward() async {
    final newPosition = position + const Duration(seconds: 10);

    if (newPosition > duration) {
      await player.seek(duration);
    } else {
      await player.seek(newPosition);
    }
  }

  Future<void> backward() async {
    final newPosition = position - const Duration(seconds: 10);

    if (newPosition.isNegative) {
      await player.seek(Duration.zero);
    } else {
      await player.seek(newPosition);
    }
  }
}
