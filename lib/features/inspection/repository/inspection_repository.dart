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

  CollectionReference get _companies => _firestore.collection('companies');

  //create new inspection
  FutureEither<String> createInspection(
    String companyId,
    InspectionModel inspection,
  ) async {
    try {
      bool isExists =
          await checkIfInspectionIdExists(companyId, inspection.id);
      if (!isExists) {
        await _companies
            .doc(companyId)
            .collection('inspections')
            .doc(inspection.id)
            .set(inspection.toMap());
      } else {
        return left(Failure(message: 'Inspection id already exists!'));
      }
      return right(inspection.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //check if the inspection id exists
  Future<bool> checkIfInspectionIdExists(
    String companyId,
    String inspectionId,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .get()
        .then(
          (value) => value.exists,
        );
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
      return right('Inspection: $inspectionId closed successfully!');
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
      return right('Inspection: $inspectionId deleted successfully!');
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
      return right('Section: $sectionName added successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
