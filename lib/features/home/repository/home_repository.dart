import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(firestore: ref.watch(firestoreProvider));
});

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _ncs => _firestore.collection('ncs');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _windFarms => _firestore.collection('windfarms');
  CollectionReference get _companies => _firestore.collection('companies');

  //get stream of nc count by user id
  Stream<int> getNCCountByUserId(String companyId, String uid) {
    return _companies
        .doc(companyId)
        .collection('ncs')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  //get stream of inspection count by user id
  Stream<int> getInspectionCountByUserId(String companyId, String uid) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  //get stream of safety count by user id
  Stream<int> getSafetyCountByUserId(String companyId, String uid) {
    return _companies
        .doc(companyId)
        .collection('safety')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }

  //get stream of 8d count by user id
  Stream<int> get8DCountByUserId(String companyId, String uid) {
    return _companies
        .doc(companyId)
        .collection('8d')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map((event) {
      return event.docs.length;
    });
  }
}
