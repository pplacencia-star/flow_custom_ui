import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'friend_service.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FriendService();
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de amistad')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: service.incomingRequests(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No tienes solicitudes pendientes'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final fromUid = doc['from'] as String;
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(fromUid)
                    .get(),
                builder: (context, userSnap) {
                  final name = userSnap.data?.data()?['name'] ?? fromUid;
                  return ListTile(
                    title: Text(name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => service.accept(doc.id, fromUid),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => service.reject(doc.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}