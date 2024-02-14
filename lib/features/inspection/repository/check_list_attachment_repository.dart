import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/attachment_model.dart';
import 'package:windsy_solve/models/checklist_model.dart';

final checkListAttachmentRepositoryProvider =
    Provider<CheckListAttachmentRepository>((ref) {
  return CheckListAttachmentRepository(firestore: ref.watch(firestoreProvider));
});

class CheckListAttachmentRepository {
  final FirebaseFirestore _firestore;

  CheckListAttachmentRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _companies => _firestore.collection('companies');

  //add Attachment
  FutureEither addAttachment(
    String companyId,
    CheckListModel checkList,
    AttachmentModel attachment,
  ) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(checkList.inspectionId)
          .collection(checkList.section)
          .doc(checkList.id)
          .collection('attachments')
          .doc(attachment.id)
          .set(attachment.toMap());
      return right('File uploaded successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //get stream of all ncs created by user
  Stream<List<AttachmentModel>> getCheckListAttachments(
    String companyId,
    CheckListModel checkList,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(checkList.inspectionId)
        .collection(checkList.section)
        .doc(checkList.id)
        .collection('attachments')
        .snapshots()
        .map((data) {
      List<AttachmentModel> attachments = [];
      for (var attachment in data.docs) {
        attachments.add(
          AttachmentModel.fromMap(
            attachment.data(),
          ),
        );
      }
      return attachments;
    });
  }

  //get Attachment by id
  Future<DocumentSnapshot<Map<String, dynamic>>> getAttachmentById(
    String companyId,
    CheckListModel checkList,
    String attachmentId,
  ) {
    return _companies
        .doc(companyId)
        .collection('inspections')
        .doc(checkList.inspectionId)
        .collection(checkList.section)
        .doc(checkList.id)
        .collection('attachments')
        .doc(attachmentId)
        .get();
  }

  //delete Attachment by Id
  FutureEither deleteAttachmentById(
    String companyId,
    CheckListModel checkList,
    String attachmentId,
  ) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(checkList.inspectionId)
          .collection(checkList.section)
          .doc(checkList.id)
          .collection('attachments')
          .doc(attachmentId)
          .delete();
      return right('Attachment deleted successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //Update attachment comment
  FutureEither updateAttachmentComment(
    String companyId,
    CheckListModel checkList,
    AttachmentModel attachment,
  ) async {
    try {
      await _companies
          .doc(companyId)
          .collection('inspections')
          .doc(checkList.inspectionId)
          .collection(checkList.section)
          .doc(checkList.id)
          .collection('attachments')
          .doc(attachment.id)
          .update(attachment.toMap());
      return right('Attachment comment updated successfully!');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
