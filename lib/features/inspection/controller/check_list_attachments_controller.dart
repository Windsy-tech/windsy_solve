import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/repository/check_list_attachment_repository.dart';
import 'package:windsy_solve/models/common/attachment_model.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final checkListAttachmentControllerProvider =
    StateNotifierProvider<CheckListAttachmentController, bool>((ref) {
  final checkListAttachmentRepository =
      ref.watch(checkListAttachmentRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CheckListAttachmentController(
    ref: ref,
    checkListAttachmentRepository: checkListAttachmentRepository,
    storageRepository: storageRepository,
  );
});

final getCheckListAttachmentsProvider =
    StreamProvider.family((ref, CheckListModel checkList) {
  return ref
      .watch(checkListAttachmentControllerProvider.notifier)
      .getCheckListAttachments(checkList);
});

class CheckListAttachmentController extends StateNotifier<bool> {
  final CheckListAttachmentRepository _checkListAttachmentRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CheckListAttachmentController({
    required CheckListAttachmentRepository checkListAttachmentRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _checkListAttachmentRepository = checkListAttachmentRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void addAttachment({
    required BuildContext context,
    required CheckListModel checkList,
    required File? file,
  }) async {
    state = true;
    final user = _ref.read(userProvider)!;

    AttachmentModel attachment = AttachmentModel(
      id: '',
      name: file!.path.split('/').last,
      fileUrl: '',
      fileType: file.path.split('.').last,
      comment: '',
      createdBy: user.uid,
      createdAt: DateTime.now(),
      updatedBy: user.uid,
      updatedAt: DateTime.now(),
    );

    if (file != null) {
      Uuid uuid = const Uuid();
      attachment = attachment.copyWith(
        id: uuid.v8(),
      );
      final filePath =
          '${user.companyId}/inspections/${checkList.inspectionId}/${checkList.section}/${checkList.id}/attachments';
      final res = await _storageRepository.storeFile(
        id: attachment.id,
        path: filePath,
        file: file,
        webFile: null,
      );
      res.fold(
        (l) => showSnackBar(context, l.message, SnackBarType.error),
        (r) => attachment = attachment.copyWith(fileUrl: r),
      );
    } else {
      showSnackBar(context, 'Please select a file/image', SnackBarType.warning);
    }

    final res = await _checkListAttachmentRepository.addAttachment(
      user.companyId,
      checkList,
      attachment,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) => showSnackBar(context, r, SnackBarType.success),
    );
  }

  Stream<List<AttachmentModel>> getCheckListAttachments(
      CheckListModel checkList) {
    final user = _ref.read(userProvider)!;
    return _checkListAttachmentRepository.getCheckListAttachments(
      user.companyId,
      checkList,
    );
  }

  //get attachment by id
  Future getAttachmentById(CheckListModel checkList, String attachmentId) {
    final user = _ref.read(userProvider)!;
    return _checkListAttachmentRepository.getAttachmentById(
      user.companyId,
      checkList,
      attachmentId,
    );
  }

  void _uploadAttachment({
    required BuildContext context,
    required CheckListModel checkList,
    required String filePath,
    required File attachmentFile,
    required Uint8List attachmentWebFile,
  }) async {
    state = true;
    final res = await _storageRepository.storeFile(
      id: checkList.id,
      path: filePath,
      file: attachmentFile,
      webFile: attachmentWebFile,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(
            context, 'NC-$r created successfully!', SnackBarType.success);
      },
    );
  }

  //delete an attachment by id
  void deleteAttachmentById({
    required BuildContext context,
    required CheckListModel checkList,
    required AttachmentModel attachment,
  }) async {
    state = true;
    final storageRes = await _storageRepository.deleteFile(
      url: attachment.fileUrl,
    );
    storageRes.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) async {
        final res = await _checkListAttachmentRepository.deleteAttachmentById(
          _ref.read(userProvider)!.companyId,
          checkList,
          attachment.id,
        );
        res.fold(
          (l) => showSnackBar(context, l.message, SnackBarType.error),
          (r) => showSnackBar(context, r, SnackBarType.success),
        );
      },
    );
    state = false;
  }

  // update attachment comment
  void updateAttachmentComment({
    required BuildContext context,
    required CheckListModel checkList,
    required AttachmentModel attachment,
    required String comment,
  }) async {
    state = true;

    final user = _ref.read(userProvider)!;

    AttachmentModel updatedAttachment = attachment.copyWith(
      comment: comment,
      updatedBy: user.uid,
      updatedAt: DateTime.now(),
    );

    final res = await _checkListAttachmentRepository.updateAttachmentComment(
      user.companyId,
      checkList,
      updatedAttachment,
    );

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) => showSnackBar(context, r, SnackBarType.success),
    );
  }
}
