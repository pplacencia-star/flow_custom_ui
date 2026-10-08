import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({super.key});

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  bool isPlaying = true;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      decoration: BoxDecoration(
        gradient: AppColors.miniPlayerGradient,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 15,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  'https://images.unsplash.com/photo-1583795483972-8dc136f36e53?auto=format&fit=crop&w=400&q=85',
                  width: 31,
                  height: 31,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Starboy',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'The Weeknd, Daft Punk',
                      style: TextStyle(fontSize: 6, color: Color(0xFFA493B2)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(2),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 15,
                  color: isLiked ? AppColors.accent : AppColors.muted,
                ),
                onPressed: () => setState(() => isLiked = !isLiked),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(2),
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => setState(() => isPlaying = !isPlaying),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0x55645274),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.37,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFAA76FA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
