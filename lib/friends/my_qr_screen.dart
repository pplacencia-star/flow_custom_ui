import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'friend_service.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  final _service = FriendService();

  @override
  void initState() {
    super.initState();
    _service.ensureUserDoc();
  }

  @override
  Widget build(BuildContext context) {
    final data = _service.qrDataForMe();
    return Scaffold(
      appBar: AppBar(title: const Text('Mi código QR')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: QrImageView(data: data, size: 240),
        ),
      ),
    );
  }
}