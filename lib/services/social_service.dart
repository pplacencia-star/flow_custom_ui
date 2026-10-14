import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialService {
  static final db = FirebaseFirestore.instance;
  static String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Inicia sesión para continuar');
    return user.uid;
  }

  static Future<void> ensureProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Inicia sesión para compartir tu perfil');
    final ref = db.collection('users').doc(user.uid);
    await ref.set({
      'uid': user.uid,
      'name': user.displayName?.trim().isNotEmpty == true
          ? user.displayName : (user.email?.split('@').first ?? 'Usuario'),
      'photoUrl': user.photoURL ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Stream<bool> following(String otherUid) => db
      .collection('users').doc(uid).collection('following').doc(otherUid)
      .snapshots().map((doc) => doc.exists);

  static Future<void> setFollowing(String otherUid, bool follow) async {
    if (otherUid == uid) throw StateError('No puedes seguirte a ti mismo');
    final target = await db.collection('users').doc(otherUid).get();
    if (!target.exists) throw StateError('Este perfil todavía no está disponible');
    final ref = db.collection('users').doc(uid).collection('following').doc(otherUid);
    if (follow) {
      await ref.set({'uid': otherUid, 'createdAt': FieldValue.serverTimestamp()});
    } else {
      await ref.delete();
    }
  }
}
