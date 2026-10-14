import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> relationStatus(String otherUid) async {
    final me = _auth.currentUser!.uid;
    final friend = await _db
        .collection('users')
        .doc(me)
        .collection('friends')
        .doc(otherUid)
        .get();
    if (friend.exists) return 'friends';

    final sent =
        await _db.collection('friend_requests').doc('${me}_$otherUid').get();
    if (sent.exists && sent.data()?['status'] == 'pending') return 'sent';

    final received =
        await _db.collection('friend_requests').doc('${otherUid}_$me').get();
    if (received.exists && received.data()?['status'] == 'pending') {
      return 'received';
    }
    return 'none';
  }

  Future<String> sendRequest(String toUid) async {
    final me = _auth.currentUser!.uid;
    if (toUid == me) return 'No puedes agregarte a ti mismo';

    final userDoc = await _db.collection('users').doc(toUid).get();
    if (!userDoc.exists) return 'Usuario no encontrado';

    final status = await relationStatus(toUid);
    if (status == 'friends') return 'Ya son amigos';
    if (status == 'sent') return 'Ya enviaste una solicitud a este usuario';
    if (status == 'received') {
      return 'Esa persona ya te envió una solicitud, revisa tus solicitudes';
    }

    await _db.collection('friend_requests').doc('${me}_$toUid').set({
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
    batch.update(
        _db.collection('friend_requests').doc(requestId), {'status': 'accepted'});
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