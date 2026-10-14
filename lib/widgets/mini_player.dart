import 'package:flutter/material.dart';
import 'nova_glass.dart';

import '../services/music_player_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final music = MusicPlayerService.instance;

    return AnimatedBuilder(
      animation: music,
      builder: (context, child) {
        final track = music.currentTrack;

        final duration = music.duration.inMilliseconds.toDouble();

        final position = music.position.inMilliseconds.toDouble();

        final progress = duration > 0
            ? (position / duration).clamp(0.0, 1.0)
            : 0.0;

        return Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: NovaGlass(radius: 20, child: SizedBox(
          height: 69,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: track != null && track.artwork.isNotEmpty
                          ? Image.network(
                              track.artwork,
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                              // ignore: unnecessary_underscores
                              errorBuilder: (_, __, ___) => Container(
                                height: 45,
                                width: 45,
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              height: 45,
                              width: 45,
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                            ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track?.title ?? 'Sin reproducción',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            track?.artist ?? 'Music-Nova',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        music.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: track == null
                          ? null
                          : () {
                              music.togglePlayPause();
                            },
                    ),

                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: track == null
                          ? null
                          : () {
                              music.forward();
                            },
                    ),
                  ],
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: track == null || duration <= 0
                    ? null
                    : (details) {
                        final width = context.size?.width ?? 1;

                        final percentage = (details.localPosition.dx / width)
                            .clamp(0.0, 1.0);

                        final newPosition = Duration(
                          milliseconds: (duration * percentage).round(),
                        );

                        music.seek(newPosition);
                      },
                child: SizedBox(
                  height: 8,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFD500F9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        )));
      },
    );
  }
}

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MiniPlayer();
  }
}
