import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}
class _QrScannerScreenState extends State<QrScannerScreen> {
  bool found = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Escanear perfil'), backgroundColor: const Color(0xFF161224)),
    body: MobileScanner(onDetect: (capture) {
      if (found) return;
      for (final barcode in capture.barcodes) {
        final raw = barcode.rawValue;
        const prefix = 'music-nova:user:';
        if (raw != null && raw.startsWith(prefix) && raw.length > prefix.length) {
          found = true;
          Navigator.of(context).pop(raw.substring(prefix.length));
          break;
        }
      }
    }),
  );
}
