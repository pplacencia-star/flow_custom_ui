import 'package:flutter/material.dart';
import 'friend_requests_screen.dart';
import 'friend_service.dart';

class FriendButton extends StatefulWidget {
  final String userId;
  const FriendButton({super.key, required this.userId});

  @override
  State<FriendButton> createState() => _FriendButtonState();
}

class _FriendButtonState extends State<FriendButton> {
  final _service = FriendService();
  late Future<String> _status = _service.relationStatus(widget.userId);

  void _refresh() {
    setState(() {
      _status = _service.relationStatus(widget.userId);
    });
  }

  Future<void> _send() async {
    String message;
    try {
      message = await _service.sendRequest(widget.userId);
    } catch (e) {
      message = 'Error: $e';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _status,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        switch (snapshot.data) {
          case 'friends':
            return OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.people),
              label: const Text('Amigos'),
            );
          case 'sent':
            return OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.hourglass_top),
              label: const Text('Solicitud enviada'),
            );
          case 'received':
            return FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FriendRequestsScreen()),
                );
                if (mounted) _refresh();
              },
              icon: const Icon(Icons.mark_email_unread),
              label: const Text('Responder solicitud'),
            );
          default:
            return FilledButton.icon(
              onPressed: _send,
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Agregar amigo'),
            );
        }
      },
    );
  }
}