import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF161224),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://picsum.photos/200?random=1',
              height: 45,
              width: 45,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 45,
                  width: 45,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Midnight Memories',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Cyberwave',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
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
