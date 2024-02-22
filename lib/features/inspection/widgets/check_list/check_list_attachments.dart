import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_attachments_controller.dart';
import 'package:windsy_solve/features/inspection/widgets/check_list/check_list_attachment_item.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';

class CheckListAttachments extends ConsumerStatefulWidget {
  final CheckListModel checkList;
  const CheckListAttachments({
    super.key,
    required this.checkList,
  });
  @override
  ConsumerState<CheckListAttachments> createState() =>
      _CreateConsumerCheckListAttachmentsState();
}

class _CreateConsumerCheckListAttachmentsState
    extends ConsumerState<CheckListAttachments> {
  void uploadFile(File file) {
    ref.read(checkListAttachmentControllerProvider.notifier).addAttachment(
          context: context,
          checkList: widget.checkList,
          file: file,
        );
  }

  _pickImageFromCameraAndUpload() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        uploadFile(file);
      }
    } catch (e) {
      rethrow;
    }
  }

  _pickImageFromGalleryAndUpload() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      pickedFiles.forEach((pickedFile) async {
        File file = File(pickedFile.path);
        uploadFile(file);
      });
    } catch (e) {
      rethrow;
    }
  }

  _pickFilesAndUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        result.files.forEach((pickedFile) async {
          File file = File(pickedFile.path!);
          uploadFile(file);
        });
      } else {
        print('No file selected.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _getAttachment(String type) async {
    switch (type) {
      case 'camera':
        _pickImageFromCameraAndUpload();
        break;
      case 'gallery':
        _pickImageFromGalleryAndUpload();
        break;
      case 'files':
        _pickFilesAndUpload();
        break;
      default:
        break;
    }
  }

  _showBottomOptions(BuildContext context) {
    final theme = Theme.of(context);
    return showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                _getAttachment('camera');
                Navigator.pop(context);
              },
              title: Center(
                child: Text(
                  'Capture Image',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _getAttachment('gallery');
                Navigator.pop(context);
              },
              title: Center(
                child: Text(
                  'Upload Images',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _getAttachment('files');
                Navigator.pop(context);
              },
              title: Center(
                child: Text(
                  'Upload Files',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      //dense: true,
      contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 4.0, 0.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Attachments',
            style: theme.textTheme.labelLarge,
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              _showBottomOptions(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      subtitle:
          ref.watch(getCheckListAttachmentsProvider(widget.checkList)).when(
                data: (attachment) {
                  final isLoading = ref.watch(
                    checkListAttachmentControllerProvider,
                  );
                  return isLoading
                      ? const Loader()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: attachment.length,
                          itemBuilder: (context, index) {
                            return CheckListAttachmentItem(
                              checkList: widget.checkList,
                              attachment: attachment[index],
                            );
                          },
                        );
                },
                loading: () => const Loader(),
                error: (error, stack) => ErrorText(
                  error: error.toString(),
                ),
              ),
    );
  }
}
