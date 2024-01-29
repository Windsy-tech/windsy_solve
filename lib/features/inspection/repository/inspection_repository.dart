import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/inspection_model.dart';
import 'package:windsy_solve/models/inspection_templates_model.dart';

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

  //create new inspection
  FutureEither<int> createInspection(
    String companyId,
    InspectionModel inspection,
  ) async {
    try {
      final getLatestId = await _createNewInspectionId(companyId);
      var newId = getLatestId;

      // Update inspection with the new ID
      inspection = inspection.copyWith(id: newId.toString());

      if (newId != 0) {
        await _companies
            .doc(companyId)
            .collection('inspections')
            .doc(newId.toString())
            .set(inspection.toMap());
      }

      return right(newId);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //get old id and create new inspection id
  Future<int> _createNewInspectionId(String companyId) async {
    try {
      final querySnapshot = await _companies
          .doc(companyId)
          .collection('inspections')
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

  //close inspection
  FutureEither closeInspection(
    String companyId,
    String userId,
    String inspectionId,
  ) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .update({
        'status': 'Closed',
        'closedBy': userId,
        'closedAt': DateTime.now().millisecondsSinceEpoch,
      });
      return right('I-$inspectionId closed successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //delete inspection
  FutureEither deleteInspection(String companyId, String inspectionId) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .delete();
      return right('I-$inspectionId deleted successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //get stream of inspection assigned to by user id
  Stream<List<InspectionModel>> getInspectionAssignedToByUserId(
      String companyId, String uid) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .where(
          'assignedTo',
          isEqualTo: uid,
        )
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return InspectionModel.fromMap(e.data());
      }).toList();
    });
  }

  Stream<List<InspectionTemplates>> getInspectionTemplates(String companyId) {
    return _companies
        .doc(companyId)
        .collection('inspectionTemplates')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return InspectionTemplates.fromMap(e.data());
      }).toList();
    });
  }

  //get stream of all inspections created by user
  Stream<List<InspectionModel>> getInspectionsCreatedByUser(
    String companyId,
    String uid,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map((data) {
      List<InspectionModel> inspections = [];
      for (var inspection in data.docs) {
        inspections.add(
          InspectionModel.fromMap(
            inspection.data(),
          ),
        );
      }
      return inspections;
    });
  }

  //get stream of sections
  Stream<List<String>> getInspectionSections(
    String companyId,
    String inspectionId,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .snapshots()
        .map((event) {
      return event.data()!['sections'].cast<String>();
    });
  }

  //add new section
  FutureEither<String> addSection(
    String companyId,
    String inspectionId,
    String sectionName,
  ) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .collection(sectionName)
          .add({
        "section": sectionName,
      });
      return right('Section $sectionName added successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
