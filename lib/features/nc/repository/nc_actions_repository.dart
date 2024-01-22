import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/nc_actions_model.dart';

final ncActionsRepositoryProvider = Provider<NCActionsRepository>((ref) {
  return NCActionsRepository(firestore: ref.watch(firestoreProvider));
});

class NCActionsRepository {
  final FirebaseFirestore _firestore;

  NCActionsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _companies => _firestore.collection('companies');
  CollectionReference get _ncActions => _firestore.collection('ncActions');

  FutureVoid addActionToNC(
    String companyId,
    NCActionsModel ncActionsModel,
  ) async {
    try {
      return right(_companies
          .doc(companyId)
          .collection('ncActions')
          .add(ncActionsModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
