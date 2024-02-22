import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/nc/controller/nc_attachments_controller.dart';
import 'package:windsy_solve/features/nc/widgets/nc_show_attachment.dart';
import 'package:windsy_solve/models/common/attachment_model.dart';
import 'package:windsy_solve/utils/text_utils.dart';


class AttachmentItem extends ConsumerWidget {
  final String ncId;
  final AttachmentModel attachment;
  const AttachmentItem({
    super.key,
    required this.ncId,
    required this.attachment,
  });

  void _showAttachment({
    required BuildContext context,
    required AttachmentModel attachment,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ShowAttachment(
            ncId: ncId,
            attachment: attachment,
          );
        },
      ),
    );
  }

  void deleteAttachmentById({
    required BuildContext context,
    required String ncId,
    required AttachmentModel attachment,
    required WidgetRef ref,
  }) {
    ref.read(ncAttachmentControllerProvider.notifier).deleteAttachmentById(
          context: context,
          ncId: ncId,
          attachment: attachment,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: theme.colorScheme.secondaryContainer,
        ),
        child: ListTile(
          onTap: () => _showAttachment(
            attachment: attachment,
            context: context,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          contentPadding: const EdgeInsets.only(
            left: 10.0,
          ),
          leading: const Icon(
            Icons.image_outlined,
            size: 12,
          ),
          title: Text(
            attachment.name.shortenFileName(30),
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: theme.textTheme.labelSmall,
          ),
          trailing: PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            offset: const Offset(0, 20),
            onSelected: (value) {
              if (value == 'delete') {
                deleteAttachmentById(
                  context: context,
                  ncId: ncId,
                  attachment: attachment,
                  ref: ref,
                );
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                height: kMinInteractiveDimension / 2,
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            icon: const Icon(
              Icons.more_vert_outlined,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
