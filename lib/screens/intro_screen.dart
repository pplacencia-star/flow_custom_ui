import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Presentación original: una estrella fugaz dibuja la órbita de Music-Nova,
/// detona un destello y revela el logotipo. Compatible con web y Android.
class IntroScreen extends StatefulWidget {
  final Widget child;
  const IntroScreen({super.key, required this.child});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3550),
    )..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _finished = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return widget.child;
    return Scaffold(
      backgroundColor: const Color(0xFF070611),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final reveal = Curves.easeOutBack.transform(((t - .40) / .32).clamp(0.0, 1.0));
          final fade = ((t - .39) / .17).clamp(0.0, 1.0);
          final endFade = (1 - ((t - .92) / .08).clamp(0.0, 1.0));
          final burst = math.sin(math.pi * ((t - .55) / .30).clamp(0.0, 1.0));
          return Opacity(
            opacity: endFade,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const DecoratedBox(decoration: BoxDecoration(gradient: RadialGradient(
                  center: Alignment.center, radius: 1.05,
                  colors: [Color(0xFF25113F), Color(0xFF070611)],
                ))),
                CustomPaint(painter: _NovaOrbitPainter(progress: t)),
                Center(child: Transform.scale(
                  scale: .50 + .50 * reveal + .06 * burst,
                  child: Opacity(
                    opacity: fade,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(46),
                          boxShadow: [BoxShadow(color: const Color(0xFFA85CFF).withValues(alpha: .32 + .28 * burst),
                            blurRadius: 42 + 55 * burst, spreadRadius: 2 + 12 * burst)]),
                        child: ClipRRect(borderRadius: BorderRadius.circular(43),
                          child: Image.asset('assets/icon/app_icon.png', width: 190, height: 190)),
                      ),
                      const SizedBox(height: 24),
                      const Text('MUSIC-NOVA', style: TextStyle(color: Colors.white,
                        fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 5)),
                      const SizedBox(height: 8),
                      Text('TU UNIVERSO MUSICAL', style: TextStyle(
                        color: Colors.white.withValues(alpha: .76),
                        fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 4)),
                    ]),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NovaOrbitPainter extends CustomPainter {
  final double progress;
  const _NovaOrbitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 15);
    final radius = math.min(size.width * .39, 220.0);
    final orbit = Rect.fromCircle(center: center, radius: radius);
    final p = (progress / .62).clamp(0.0, 1.0);
    final sweep = 2 * math.pi * Curves.easeInOutCubic.transform(p);
    final start = -math.pi * .75;
    final glow = Paint()..color = const Color(0xFF9E54FF).withValues(alpha: .32)
      ..style = PaintingStyle.stroke..strokeWidth = 16..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    final line = Paint()..shader = const SweepGradient(colors: [
      Color(0xFF3B1B72), Color(0xFFB568FF), Color(0xFF76F4FF), Color(0xFFECC8FF),
    ]).createShader(orbit)..style = PaintingStyle.stroke..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(orbit, start, sweep, false, glow);
    canvas.drawArc(orbit, start, sweep, false, line);
    if (p < 1 && p > 0) {
      final angle = start + sweep;
      final head = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawCircle(head, 19, Paint()..color = const Color(0xFFB76AFF).withValues(alpha: .8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 17));
      canvas.drawCircle(head, 6, Paint()..color = Colors.white);
    }
    final flash = math.sin(math.pi * ((progress - .58) / .24).clamp(0.0, 1.0));
    if (flash > 0) {
      canvas.drawCircle(center, radius * (1 + flash * .75), Paint()
        ..color = const Color(0xFFB974FF).withValues(alpha: flash * .16)
        ..style = PaintingStyle.stroke..strokeWidth = 2 + 4 * flash);
    }
    final stars = math.Random(14);
    for (var i = 0; i < 34; i++) {
      final point = Offset(stars.nextDouble() * size.width, stars.nextDouble() * size.height);
      final twinkle = .25 + .65 * (math.sin(progress * math.pi * 5 + i) + 1) / 2;
      canvas.drawCircle(point, .6 + stars.nextDouble() * 1.3,
        Paint()..color = Colors.white.withValues(alpha: twinkle * .65));
    }
  }

  @override
  bool shouldRepaint(covariant _NovaOrbitPainter oldDelegate) => oldDelegate.progress != progress;
}
