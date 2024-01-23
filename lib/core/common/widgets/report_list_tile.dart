import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class ReportListTile extends ConsumerWidget {
  const ReportListTile({
    super.key,
    required this.ncData,
    required this.onTap,
  });

  final NCModel ncData;
  final VoidCallback onTap;

  _showPopupMenu(
    BuildContext context,
    Offset position,
    WidgetRef ref,
    String companyId,
    String ncId,
  ) {
    return showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromLTRB(
        position.dx - 200,
        position.dy,
        30,
        0,
      ),
      items: [
        const PopupMenuItem(
          child: Text("Edit"),
        ),
        PopupMenuItem(
          onTap: () => ref.read(ncControllerProvider.notifier).deleteNC(
                context,
                companyId,
                ncId,
              ),
          child: const Text("Delete"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        titleAlignment: ListTileTitleAlignment.top,
        title: Text(
          'NC #${ncData.id}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ncData.status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: ncData.status == 'Open' ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                ncData.title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    TextUtils.capitalizeFirstLetter(ncData.windFarm),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.date_range_outlined,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    ncData.createdAt.toDateString(),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        trailing: GestureDetector(
          onTapDown: (TapDownDetails details) {
            final user = ref.read(userProvider)!;
            _showPopupMenu(context, details.globalPosition, ref, user.companyId,
                ncData.id);
          },
          child: const Icon(
            Icons.more_vert_outlined,
            size: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
