import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(firestore: ref.watch(firestoreProvider));
});

class InspectionRepository {
  final FirebaseFirestore _firestore;

  InspectionRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _inspections => _firestore.collection('inspections');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _windFarms => _firestore.collection('windfarms');
  CollectionReference get _companies => _firestore.collection('companies');

  //get stream of inspection assigned to by user id
}
