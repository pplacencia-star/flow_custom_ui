import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/social_service.dart';
import '../widgets/nova_glass.dart';
import 'saved_tracks_screen.dart';
import '../friends/friend_button.dart';

class PublicProfileScreen extends StatelessWidget {
  final String userId;
  const PublicProfileScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Perfil Music-Nova'), backgroundColor: const Color(0xFF161224)),
      body: NovaBackdrop(child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: db.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('No se pudo cargar el perfil: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (!snapshot.data!.exists) return const Center(child: Text('Perfil no encontrado', style: TextStyle(color: Colors.white)));
          final data = snapshot.data!.data()!;
          final isSelf = FirebaseAuth.instance.currentUser?.uid == userId;
          return ListView(padding: const EdgeInsets.all(20), children: [
            NovaGlass(padding: const EdgeInsets.all(22), child: Column(children: [
              const CircleAvatar(radius: 42, backgroundColor: Color(0xFF7337B7), child: Icon(Icons.person, size: 46, color: Colors.white)),
              const SizedBox(height: 14),
              Text(data['name']?.toString() ?? 'Usuario', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (!isSelf) StreamBuilder<bool>(stream: SocialService.following(userId), builder: (context, following) {
                final yes = following.data ?? false;
                return FilledButton.icon(icon: Icon(yes ? Icons.check : Icons.person_add), label: Text(yes ? 'Siguiendo' : 'Seguir'),
                  onPressed: () async { try { await SocialService.setFollowing(userId, !yes); }
                    catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } });
              }),
                if (!isSelf) const SizedBox(height: 8),
                if (!isSelf) FriendButton(userId: userId),
            ])),
            const SizedBox(height: 24),
            const Text('Playlists públicas', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.collection('users').doc(userId).collection('playlists').where('isPublic', isEqualTo: true).snapshots(),
              builder: (context, playlists) {
                if (playlists.hasError) return const Text('No se pudieron consultar las playlists públicas', style: TextStyle(color: Colors.white70));
                if (!playlists.hasData) return const Center(child: CircularProgressIndicator());
                if (playlists.data!.docs.isEmpty) return const Text('Todavía no hay playlists públicas', style: TextStyle(color: Colors.white70));
                return Column(children: playlists.data!.docs.map((doc) => ListTile(
                  leading: const Icon(Icons.queue_music, color: Color(0xFFD500F9)),
                  title: Text(doc.data()['name']?.toString() ?? 'Playlist', style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SavedTracksScreen(playlistId: doc.id, title: doc.data()['name']?.toString() ?? 'Playlist', ownerId: userId, readOnly: true))),
                )).toList());
              }),
          ]);
        },
      )),
    );
  }
}
