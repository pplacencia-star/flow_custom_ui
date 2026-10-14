import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/nova_glass.dart';
import '../services/social_service.dart';
import 'qr_scanner_screen.dart';
import 'public_profile_screen.dart';

class QrProfileScreen extends StatefulWidget {
  const QrProfileScreen({super.key});
  @override
  State<QrProfileScreen> createState() => _QrProfileScreenState();
}
class _QrProfileScreenState extends State<QrProfileScreen> {
  late final Future<void> ready = SocialService.ensureProfile();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Mi código Music-Nova'), backgroundColor: const Color(0xFF161224)),
      body: NovaBackdrop(child: Center(child: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(24), child: NovaGlass(padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.auto_awesome, size: 35, color: Color(0xFFDCA2FF)),
            const SizedBox(height: 12),
            const Text('Conecta tu universo', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Comparte este código para que puedan seguirte.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            FutureBuilder<void>(future: ready, builder: (context, snapshot) {
              if (snapshot.hasError) return Text('No se pudo publicar el perfil: ${snapshot.error}', style: const TextStyle(color: Colors.orangeAccent));
              if (snapshot.connectionState != ConnectionState.done) return const CircularProgressIndicator();
              return Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                child: QrImageView(data: 'music-nova:user:${user!.uid}', version: QrVersions.auto, size: 225,
                  embeddedImage: const AssetImage('assets/icon/app_icon.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(36, 36)),
                  errorCorrectionLevel: QrErrorCorrectLevel.H));
            }),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: () async {
              final uid = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const QrScannerScreen()));
              if (uid != null && context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(userId: uid)));
            }, icon: const Icon(Icons.qr_code_scanner), label: const Text('Escanear otro perfil')),
          ])),
      )))),
    );
  }
}
