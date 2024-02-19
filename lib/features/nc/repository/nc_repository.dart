// Non-Conformity Repository

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/handler/failure.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_sync_task.dart';
import 'package:windsy_solve/core/providers/connectivity_provider.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/providers/sync_task/sync_task_controller.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/user_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';

final ncRepositoryProvider = Provider<NCRepository>((ref) {
  return NCRepository(
    firestore: ref.watch(firestoreProvider),
    localDatabase: ref.watch(testProvider),
    connectivityProvider: ref.watch(connectivityProvider),
  );
});

class NCRepository {
  final FirebaseFirestore _firestore;
  final LocalDatabase _localDatabase;
  final ConnectivityProvider _connectivityProvider;

  NCRepository(
      {required FirebaseFirestore firestore,
      required LocalDatabase localDatabase,
      required ConnectivityProvider connectivityProvider})
      : _firestore = firestore,
        _localDatabase = localDatabase,
        _connectivityProvider = connectivityProvider;

  CollectionReference get _ncs => _firestore.collection('ncs');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _windFarms => _firestore.collection('windfarms');
  CollectionReference get _companies => _firestore.collection('companies');

  FutureEither<int> createNC(String companyId, NCModel ncModel) async {
    try {
      final getLatestId = await _createNewNCId(companyId);
      var newId = getLatestId;

      // Update ncModel with the new ID
      ncModel = ncModel.copyWith(id: newId.toString());

      if (newId != 0) {
        await _companies
            .doc(companyId)
            .collection('ncs')
            .doc(newId.toString())
            .set(ncModel.toMap());
      }

      return right(newId);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<int> _createNewNCId(String companyId) async {
    try {
      final querySnapshot = await _companies
          .doc(companyId)
          .collection('ncs')
          .orderBy('id', descending: true)
          .limit(1) // Limit the result to one document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final oldId = int.parse(querySnapshot.docs.first.data()['id']);
        return oldId + 1;
      } else {
        // If no documents are found, start with ID 1
        return 1001;
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return 0;
    }
  }

  //Update NC data by id
  FutureEither updateNC(
    String companyId,
    String userId,
    NCModel ncModel,
  ) async {
    //check internet connection
    if (await _connectivityProvider.connectivityStatus ==
        ConnectivityStatus.offline) {
      final ncSyncTask = NCSyncTask(
        companyId: companyId,
        userId: userId,
        ncModel: ncModel,
        action: 'update',
      );
      await _localDatabase.saveNCSyncTask(ncSyncTask);
      return right('No internet. Storing to local database!');
    }

    try {
      await _companies
          .doc(companyId)
          .collection('ncs')
          .doc(ncModel.id)
          .update(ncModel.toMap());
      return right('NC-${ncModel.id} updated successfully!');
    } on FirebaseException catch (e) {
      return right('No internet. Storing to local database!');
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither deleteNC(String companyId, String ncId) async {
    try {
      await _companies.doc(companyId).collection('ncs').doc(ncId).delete();
      return right('NC-$ncId deleted successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither closeNC(String companyId, String userId, String ncId) async {
    try {
      await _companies.doc(companyId).collection('ncs').doc(ncId).update({
        'status': 'Closed',
        'closedAt': DateTime.now().millisecondsSinceEpoch,
        'closedBy': userId,
      });
      return right('NC-$ncId closed successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getNCbyId(
    String companyId,
    String ncId,
  ) {
    return _companies.doc(companyId).collection('ncs').doc(ncId).get();
  }

  //get stream of nc by id
  Stream<NCModel> getNCbyId1(String companyId, String ncId) {
    return _companies
        .doc(companyId)
        .collection('ncs')
        .doc(ncId)
        .snapshots()
        .map((event) {
      return NCModel.fromMap(
        event.data() as Map<String, dynamic>,
      );
    });
  }

  //get stream of all ncs created by user
  Stream<List<NCModel>> getNCsCreatedByUser(
    String companyId,
    String uid,
  ) {
    return _companies
        .doc(companyId)
        .collection('ncs')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map((data) {
      List<NCModel> ncs = [];
      for (var nc in data.docs) {
        ncs.add(NCModel.fromMap(nc.data()));
      }
      return ncs;
    });
  }

  //get all ncs assigned to user
  Future<List<NCModel>> getNCsAssignedToUser(String uid) {
    return _ncs.where('assignedTo', arrayContains: uid).get().then((value) {
      return value.docs
          .map(
            (nc) => NCModel.fromMap(
              nc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
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
          (event) =>
              event.docs.map((e) => WindFarmModel.fromMap(e.data())).toList(),
        );
  }
}
