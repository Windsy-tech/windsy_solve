import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/checklist_model.dart';
import 'package:windsy_solve/models/inspection_model.dart';
import 'package:windsy_solve/models/inspection_templates_model.dart';

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(
      firestore: ref.watch(firestoreProvider),
      storageRepository: ref.watch(storageRepositoryProvider));
});

class InspectionRepository {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;

  InspectionRepository(
      {required FirebaseFirestore firestore,
      required StorageRepository storageRepository})
      : _firestore = firestore,
        _storageRepository = storageRepository;

  CollectionReference get _companies => _firestore.collection('companies');

  //create new inspection
  FutureEither<String> createInspection(
    String companyId,
    InspectionModel inspection,
  ) async {
    try {
      bool isExists =
          await _checkIfInspectionIdExists(companyId, inspection.id);
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

  //check if the inspection id exists as future
  Future<bool> _checkIfInspectionIdExists(
    String companyId,
    String inspectionId,
  ) async {
    final inspection = await _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .get();
    return inspection.exists;
  }

  //check if the inspection id exists as stream
  Stream<bool> checkIfInspectionIdExists(
    String companyId,
    String inspectionId,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .snapshots()
        .map((inspection) => inspection.exists);
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

  //get inspection data by id
  Future<DocumentSnapshot<Map<String, dynamic>>> getInspectionbyId(
    String companyId,
    String inspectionId,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .get();
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

  //get stream of sections (sub-collections) of an inspection
  Stream<List<String>> getInspectionSections(
    String companyId,
    String inspectionId,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .snapshots()
        .map((sections) {
      List<String> sectionList = [];
      for (var section in sections.data()!['sections']) {
        sectionList.add(section);
      }
      return sectionList;
    });
  }

  //update section in inspection
  FutureEither<bool> updateSection(
    String companyId,
    String inspectionId,
    String sectionName,
  ) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .update({
        "sections": FieldValue.arrayUnion([sectionName]),
      });
      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //get stream of checklists from section
  Stream<List<String>> getChecklistsFromSection(
    String companyId,
    String inspectionId,
    String sectionName,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .collection(sectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((checklists) {
      List<String> checklistList = [];
      for (var checklist in checklists.docs) {
        checklistList.add(checklist.id);
      }
      return checklistList;
    });
  }

  //add new section
  FutureEither<String> addSection(
    String companyId,
    String displayName,
    String inspectionId,
    String sectionName,
  ) async {
    try {
      CheckListModel checkList = CheckListModel();
      checkList = checkList.copyWith(
        id: 'Default',
        inspectionId: inspectionId,
        section: sectionName,
        createdBy: displayName,
        modifiedBy: displayName,
      );
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .collection(sectionName)
          .doc('Default')
          .set(checkList.toMap());
      return right('Section: $sectionName added successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<String> deleteSection(
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
          .get()
          .then((value) {
        for (var doc in value.docs) {
          print(doc.id);
          doc.reference.delete();
        }
      });
      await _storageRepository.deleteFolder(
        companyId,
        inspectionId,
        sectionName,
      );
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .update({
        "sections": FieldValue.arrayRemove([sectionName]),
      });
      return right('Section: $sectionName deleted successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //add new checklist
  FutureEither<String> addChecklist(
    String companyId,
    String inspectionId,
    String sectionName,
    String checklistName,
  ) async {
    try {
      CheckListModel checkList = CheckListModel();
      checkList = checkList.copyWith(
        id: checklistName,
        inspectionId: inspectionId,
        section: sectionName,
      );
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(inspectionId)
          .collection(sectionName)
          .doc(checklistName)
          .set(checkList.toMap());
      return right('Checklist: $checklistName added successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //check if checklist exists by id
  Future<bool> checkIfChecklistExists(
    String companyId,
    String inspectionId,
    String sectionName,
    String checklistId,
  ) async {
    final checklist = await _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .collection(sectionName)
        .doc(checklistId)
        .get();
    return checklist.exists;
  }

  //check if section exists by id
  Future<bool> checkIfSectionExists(
    String companyId,
    String inspectionId,
    String sectionName,
  ) async {
    final section = await _companies
        .doc(companyId)
        .collection('inspections')
        .doc(inspectionId)
        .get()
        .then(
          (value) => value.data()!['sections'].contains(sectionName),
        );
    return section.exists;
  }
}
