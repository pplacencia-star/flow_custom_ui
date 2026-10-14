import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'friend_service.dart';
import 'package:flutter/foundation.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final _service = FriendService();
  bool _busy = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
  if (_busy) return;
  final raw =
      capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
  if (raw == null) return;

  setState(() => _busy = true);
  String message;
  try {
    await _service.ensureUserDoc();
    message = await _service.sendRequestFromQr(raw);
  } catch (e) {
    debugPrint('scan error: $e');
    message = 'Error: $e';
  }
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}