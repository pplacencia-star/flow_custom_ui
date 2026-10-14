import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FriendService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  static const _prefix = 'musicnova://friend/';

  String qrDataForMe() => '$_prefix${_auth.currentUser!.uid}';

  Future<void> ensureUserDoc() async {
  final user = _auth.currentUser;
  if (user == null) return;
  try {
    await _db.collection('users').doc(user.uid).set({
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
    }, SetOptions(merge: true));
    debugPrint('ensureUserDoc OK: ${user.uid}');
  } catch (e) {
    debugPrint('ensureUserDoc error: $e');
  }
}

  String? parseQr(String raw) {
    if (!raw.startsWith(_prefix)) return null;
    final uid = raw.substring(_prefix.length).trim();
    return uid.isEmpty ? null : uid;
  }

  Future<String> sendRequestFromQr(String raw) async {
    final toUid = parseQr(raw);
    if (toUid == null) return 'Este QR no es de Music Nova';

    final me = _auth.currentUser!.uid;
    if (toUid == me) return 'No puedes agregarte a ti mismo';

    final userDoc = await _db.collection('users').doc(toUid).get();
    if (!userDoc.exists) return 'Usuario no encontrado';

    final alreadyFriend = await _db
        .collection('users')
        .doc(me)
        .collection('friends')
        .doc(toUid)
        .get();
  if (alreadyFriend.exists) return 'Ya son amigos';

    final reverse =
        await _db.collection('friend_requests').doc('${toUid}_$me').get();
    if (reverse.exists && reverse.data()?['status'] == 'pending') {
      return 'Esa persona ya te envió una solicitud, revisa tus solicitudes';
    }

    final ref = _db.collection('friend_requests').doc('${me}_$toUid');
    final existing = await ref.get();
    if (existing.exists && existing.data()?['status'] == 'pending') {
      return 'Ya enviaste una solicitud a este usuario';
    }

    await ref.set({
      'from': me,
      'to': toUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return 'Solicitud enviada';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> incomingRequests() {
    final me = _auth.currentUser!.uid;
    return _db
        .collection('friend_requests')
        .where('to', isEqualTo: me)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> friends() {
  final me = _auth.currentUser!.uid;
  return _db.collection('users').doc(me).collection('friends').snapshots();
}

  Future<void> accept(String requestId, String fromUid) async {
    final me = _auth.currentUser!.uid;
    final batch = _db.batch();
    batch.update(_db.collection('friend_requests').doc(requestId),
        {'status': 'accepted'});
    batch.set(
        _db.collection('users').doc(me).collection('friends').doc(fromUid),
        {'since': FieldValue.serverTimestamp()});
    batch.set(
        _db.collection('users').doc(fromUid).collection('friends').doc(me),
        {'since': FieldValue.serverTimestamp()});
    await batch.commit();
  }

  Future<void> reject(String requestId) {
    return _db
        .collection('friend_requests')
        .doc(requestId)
        .update({'status': 'rejected'});
  }
}