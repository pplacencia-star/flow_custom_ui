import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/qr_profile_screen.dart';
import '../screens/qr_scanner_screen.dart';
import '../screens/public_profile_screen.dart';
import 'nova_glass.dart';

class AccountDialog extends StatelessWidget {
  const AccountDialog({super.key});

  String _getUserDisplayName(User? user) {
    if (user == null) return 'Usuario';
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    if (user.email != null && user.email!.contains('@')) {
      final emailName = user.email!.split('@').first;
      return emailName[0].toUpperCase() + emailName.substring(1);
    }
    return 'Usuario';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = _getUserDisplayName(user);
    final userEmail = user?.email ?? 'Sin correo electrónico';

    return Dialog(
      backgroundColor: const Color(0xE01B1330),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFD500F9), Color(0xFF651FFF)],
                ),
              ),
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 18),
            NovaGlass(child: Column(children: [
              ListTile(leading: const Icon(Icons.qr_code_2, color: Color(0xFFDCA2FF)),
                title: const Text('Mi QR de seguimiento', style: TextStyle(color: Colors.white)),
                onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const QrProfileScreen())); }),
              ListTile(leading: const Icon(Icons.qr_code_scanner, color: Color(0xFFDCA2FF)),
                title: const Text('Escanear y seguir', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final uid = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const QrScannerScreen()));
                  if (uid != null && context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(userId: uid)));
                }),
            ])),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
