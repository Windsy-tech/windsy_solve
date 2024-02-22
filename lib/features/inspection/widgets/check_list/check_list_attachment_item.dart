import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_attachments_controller.dart';
import 'package:windsy_solve/features/inspection/widgets/check_list/check_list_show_attachment.dart';
import 'package:windsy_solve/models/common/attachment_model.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class CheckListAttachmentItem extends ConsumerWidget {
  final CheckListModel checkList;
  final AttachmentModel attachment;
  const CheckListAttachmentItem({
    super.key,
    required this.checkList,
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
          return CheckListShowAttachment(
            checkList: checkList,
            attachment: attachment,
          );
        },
      ),
    );
  }

  void deleteAttachmentById({
    required BuildContext context,
    required CheckListModel checkList,
    required AttachmentModel attachment,
    required WidgetRef ref,
  }) {
    ref
        .read(checkListAttachmentControllerProvider.notifier)
        .deleteAttachmentById(
          context: context,
          checkList: checkList,
          attachment: attachment,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
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
                  checkList: checkList,
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
