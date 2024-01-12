// Non-Conformity Repository
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/nc_model.dart';

final ncRepositoryProvider = Provider<NCRepository>((ref) {
  return NCRepository(firestore: ref.watch(firestoreProvider));
});

class NCRepository {
  final FirebaseFirestore _firestore;

  NCRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _ncs => _firestore.collection('ncs');

  FutureVoid createNC(NCModel ncModel) async {
    try {
      return right(_ncs.doc(ncModel.id).set(ncModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //get stream of all ncs created by user
  Stream<List<NCModel>> getNCsCreatedByUser(String uid) {
    return _ncs
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((ncs) => ncs.docs
            .map((nc) => NCModel.fromMap(
                  nc.data()! as Map<String, dynamic>,
                ))
            .toList());
  }

  //get all ncs assigned to user
  Stream<List<NCModel>> getNCsAssignedToUser(String uid) {
    return _ncs
        .where('assignedTo', arrayContains: uid)
        .snapshots()
        .map((ncs) => ncs.docs
            .map((nc) => NCModel.fromMap(
                  nc.data()! as Map<String, dynamic>,
                ))
            .toList());
  }
}
