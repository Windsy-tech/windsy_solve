import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/checklist_model.dart';

final checkListRepositoryProvider = Provider<CheckListRepository>((ref) {
  return CheckListRepository(firestore: ref.watch(firestoreProvider));
});

class CheckListRepository {
  final FirebaseFirestore _firestore;

  CheckListRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _companies => _firestore.collection('companies');

  //add new component
  FutureEither<String> addNewComponent(
    String companyName,
    String component,
  ) async {
    try {
      await _companies
          .doc(companyName.toLowerCase())
          .collection('checkListData')
          .doc('component')
          .update({
        'values': FieldValue.arrayUnion([component])
      });
      return right('New Component added');
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message!));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //add new check
  FutureEither<String> addNewCheck(
    String companyName,
    String check,
  ) async {
    try {
      await _companies
          .doc(companyName.toLowerCase())
          .collection('checkListData')
          .doc('check')
          .update({
        'values': FieldValue.arrayUnion([check])
      });
      return right('New Check added');
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message!));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //update checkList
  FutureEither<String> updateCheckList(
    String companyName,
    String checkListId,
    CheckListModel checkList,
  ) async {
    try {
      await _companies
          .doc(companyName.toLowerCase())
          .collection('inspections')
          .doc(checkList.inspectionId)
          .collection(checkList.section)
          .doc(checkListId)
          .update(checkList.toMap());
      return right('Updated successfully');
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message!));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //get check list by id
  Stream<CheckListModel> getCheckListById(
    String inspectionId,
    String section,
    String checkListId,
  ) {
    return _companies
        .doc('windsy')
        .collection('inspections')
        .doc(inspectionId)
        .collection(section)
        .doc(checkListId)
        .snapshots()
        .map((snapshot) => CheckListModel.fromMap(snapshot.data()!));
  }

  //get components
  Stream<List<String>> getComponents(String companyName, String query) {
    if (query.length <= 3) {
      // Return an empty stream if the query is too short
      return Stream.value([]);
    }
    return _companies
        .doc(companyName.toLowerCase())
        .collection('checkListData')
        .doc('component')
        .snapshots()
        .map((event) {
      List<String> values = event['values'].cast<String>();
      print(values); // Use values instead of event.data()!['values']

      // Filter values based on the query
      List<String> filteredValues = values
          .where((value) => value.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filteredValues;
    });
  }

  //get checks
  Stream<List<String>> getChecks(String companyName, String query) {
    if (query.length <= 3) {
      // Return an empty stream if the query is too short
      return Stream.value([]);
    }
    return _companies
        .doc(companyName.toLowerCase())
        .collection('checkListData')
        .doc('check')
        .snapshots()
        .map((event) {
      List<String> values = event['values'].cast<String>();
      print(values); // Use values instead of event.data()!['values']

      // Filter values based on the query
      List<String> filteredValues = values
          .where((value) => value.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filteredValues;
    });
  }
}
