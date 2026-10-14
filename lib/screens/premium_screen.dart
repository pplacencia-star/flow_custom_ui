import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';

const String kEnlaceSuscripcion = 'https://buy.stripe.com/test_4gM28s6WkdGq13I3cIawo00';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  Future<void> _abrirSuscripcion(BuildContext context) async {
    final uri = Uri.parse(kEnlaceSuscripcion);
    final abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!abierto && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace de pago')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Music-Nova Premium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, size: 80, color: AppColors.accent),
            const SizedBox(height: 16),
            const Text(
              'Hazte Premium',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'MX\$49 al mes (modo de prueba)',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _abrirSuscripcion(context),
                child: const Text('Suscribirme'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}