// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/repository/nc_attachment_repository.dart';
import 'package:windsy_solve/models/common/attachment_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final ncAttachmentControllerProvider =
    StateNotifierProvider<NCAttachmentController, bool>((ref) {
  final ncAttachmentRepository = ref.watch(ncAttachmentRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return NCAttachmentController(
    ref: ref,
    ncAttachmentRepository: ncAttachmentRepository,
    storageRepository: storageRepository,
  );
});

final getNCAttachmentsProvider = StreamProvider.family((ref, String ncId) {
  return ref
      .watch(ncAttachmentControllerProvider.notifier)
      .getNCAttachments(ncId);
});

class NCAttachmentController extends StateNotifier<bool> {
  final NCAttachmentRepository _ncAttachmentRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  NCAttachmentController({
    required NCAttachmentRepository ncAttachmentRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _ncAttachmentRepository = ncAttachmentRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void addAttachment({
    required BuildContext context,
    required String ncId,
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
      final filePath = '${user.companyId}/ncs/$ncId/attachments';
      final res = await _storageRepository.storeFile(
        id: attachment.id,
        path: filePath,
        file: file,
        webFile: null,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => attachment = attachment.copyWith(fileUrl: r),
      );
    } else {
      showSnackBar(context, 'Please select a file/image');
    }

    final res = await _ncAttachmentRepository.addAttachment(
      user.companyId,
      ncId,
      attachment,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r);
      },
    );
  }

  Stream<List<AttachmentModel>> getNCAttachments(String ncId) {
    final user = _ref.read(userProvider)!;
    return _ncAttachmentRepository.getNCAttachments(user.companyId, ncId);
  }

  //get attachment by id
  Future getAttachmentById(String ncId, String attachmentId) {
    final user = _ref.read(userProvider)!;
    return _ncAttachmentRepository.getAttachmentById(
      user.companyId,
      ncId,
      attachmentId,
    );
  }

  void _uploadAttachment({
    required BuildContext context,
    required String ncId,
    required String filePath,
    required File attachmentFile,
    required Uint8List attachmentWebFile,
  }) async {
    state = true;
    final res = await _storageRepository.storeFile(
      id: ncId,
      path: filePath,
      file: attachmentFile,
      webFile: attachmentWebFile,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'NC-$r created successfully!');
      },
    );
  }

  //delete an attachment by id
  void deleteAttachmentById({
    required BuildContext context,
    required String ncId,
    required AttachmentModel attachment,
  }) async {
    state = true;
    final storageRes = await _storageRepository.deleteFile(
      url: attachment.fileUrl,
    );
    storageRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final res = await _ncAttachmentRepository.deleteAttachmentById(
          _ref.read(userProvider)!.companyId,
          ncId,
          attachment.id,
        );
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, r.toString()),
        );
      },
    );
    state = false;
  }

  // update attachment comment
  void updateAttachmentComment({
    required BuildContext context,
    required String ncId,
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

    final res = await _ncAttachmentRepository.updateAttachmentComment(
      user.companyId,
      ncId,
      updatedAttachment,
    );

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r.toString());
      },
    );
  }
}
