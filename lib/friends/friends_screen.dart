import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/public_profile_screen.dart';
import '../screens/qr_profile_screen.dart';
import '../screens/qr_scanner_screen.dart';
import 'friend_requests_screen.dart';
import 'friend_service.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  Future<void> _scan(BuildContext context) async {
    final uid = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
    if (uid != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PublicProfileScreen(userId: uid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = FriendService();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Amigos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Mi QR'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrProfileScreen()),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Escanear QR'),
                  onPressed: () => _scan(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Solicitudes'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FriendRequestsScreen()),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: service.friends(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('Aún no tienes amigos'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final friendUid = docs[i].id;
                    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendUid)
                          .get(),
                      builder: (context, userSnap) {
                        final name =
                            userSnap.data?.data()?['name'] ?? friendUid;
                        return ListTile(
                          leading:
                              const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(name),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PublicProfileScreen(userId: friendUid),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}