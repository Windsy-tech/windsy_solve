// Non-Conformity Repository

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/user_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';

final ncRepositoryProvider = Provider<NCRepository>((ref) {
  return NCRepository(firestore: ref.watch(firestoreProvider));
});

class NCRepository {
  final FirebaseFirestore _firestore;

  NCRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _ncs => _firestore.collection('ncs');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _windFarms => _firestore.collection('windfarms');
  CollectionReference get _companies => _firestore.collection('companies');

  FutureVoid createNC(NCModel ncModel) async {
    try {
      final newId = await _createNewNCId();
      ncModel.copyWith(id: newId.toString());
      return right(_ncs.doc(ncModel.id).set(ncModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<int> _createNewNCId() async {
    try {
      _ncs.orderBy('id', descending: true).snapshots().map((event) {
        print(event.docs);
      }).toList();
      print("HERE");
      return right(100);
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

  Stream<List<UserModel>> searchMembers(String query) {
    return _users
        .where(
          'displayName',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var user in event.docs) {
        users.add(UserModel.fromMap(user.data() as Map<String, dynamic>));
      }
      return users;
    });
  }

  FutureVoid addMembers(String ncId, List<String> uids) async {
    try {
      return right(_ncs.doc(ncId).update({
        'assignedTo': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<WindFarmModel>> getWindFarms(String companyName, String query) {
    return _companies
        .doc(companyName.toLowerCase())
        .collection('turbines')
        .where(
          'windFarm',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => WindFarmModel.fromMap(e.data()))
              .toList(),
        );
  }
}
