import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/estimation_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveEstimation(EstimationModel estimation) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('estimations')
        .add(estimation.toMap());
  }

  Stream<List<EstimationModel>> getEstimations() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('estimations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => EstimationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteEstimation(String id) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('estimations')
        .doc(id)
        .delete();
  }
}