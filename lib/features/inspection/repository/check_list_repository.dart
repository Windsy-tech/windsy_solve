import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/models/checklist_model.dart';

final checkListRepositoryProvider = Provider<CheckListRepository>((ref) {
  return CheckListRepository(firestore: ref.watch(firestoreProvider));
});

class CheckListRepository {
  final FirebaseFirestore _firestore;

  CheckListRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _companies => _firestore.collection('companies');

  Stream<CheckListModel> getCheckListById(String section, String checkListId) {
    return _companies
        .doc('windsy')
        .collection('inspections')
        .doc(section)
        .collection('checklist')
        .doc(checkListId)
        .snapshots()
        .map((snapshot) => CheckListModel.fromMap(snapshot.data()!));
  }
}
