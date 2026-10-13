import 'dart:ui';
import 'package:flutter/material.dart';

class NovaBackdrop extends StatelessWidget {
  final Widget child;
  const NovaBackdrop({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned.fill(child: DecoratedBox(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF151027), Color(0xFF090A18), Color(0xFF170E26)])))),
    Positioned(top: -125, left: -125, child: _glow(const Color(0xFF8544FF), 370)),
    Positioned(bottom: 70, right: -140, child: _glow(const Color(0xFFD34BBD), 320)),
    Positioned.fill(child: IgnorePointer(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 65, sigmaY: 65), child: const SizedBox.expand()))),
    child,
  ]);
  Widget _glow(Color color, double size) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .18)));
}

class NovaGlass extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  const NovaGlass({super.key, required this.child, this.radius = 22, this.padding});
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(radius), child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 19, sigmaY: 19),
    child: Container(padding: padding, decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .075),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withValues(alpha: .14)),
    ), child: child),
  ));
}
