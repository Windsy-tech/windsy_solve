import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/nc/controller/nc_attachments_controller.dart';
import 'package:windsy_solve/features/nc/widgets/nc_attachment_item.dart';

class NCAttachments extends ConsumerStatefulWidget {
  final String ncId;
  const NCAttachments({
    super.key,
    required this.ncId,
  });
  @override
  ConsumerState<NCAttachments> createState() =>
      _CreateConsumerNCAttachmentsState();
}

class _CreateConsumerNCAttachmentsState extends ConsumerState<NCAttachments> {
  void uploadFile(File file) {
    ref.read(ncAttachmentControllerProvider.notifier).addAttachment(
          context: context,
          ncId: widget.ncId,
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
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              textColor: Colors.blue,
              onTap: () {
                _getAttachment('camera');
                Navigator.pop(context);
              },
              title: const Center(
                child: Text(
                  'Capture Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              textColor: Colors.blue,
              onTap: () {
                _getAttachment('gallery');
                Navigator.pop(context);
              },
              title: const Center(
                child: Text(
                  'Upload Images',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              textColor: Colors.blue,
              onTap: () {
                _getAttachment('files');
                Navigator.pop(context);
              },
              title: const Center(
                child: Text(
                  'Upload Files',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      contentPadding: const EdgeInsets.all(0),
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Attachments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
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
      subtitle: ref.watch(getNCAttachmentsProvider(widget.ncId)).when(
            data: (attachment) {
              final isLoading = ref.watch(
                ncAttachmentControllerProvider,
              );
              return isLoading
                  ? const Loader()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: attachment.length,
                      itemBuilder: (context, index) {
                        return AttachmentItem(
                          ncId: widget.ncId,
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
