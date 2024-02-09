import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class ReportListTile extends ConsumerWidget {
  const ReportListTile({
    super.key,
    required this.id,
    required this.status,
    required this.title,
    required this.windFarm,
    required this.createdAt,
    required this.onTapClose,
    required this.onTapDelete,
    required this.onTap,
  });

  final String id;
  final String status;
  final String title;
  final String windFarm;
  final DateTime createdAt;
  final VoidCallback onTapClose;
  final VoidCallback onTapDelete;
  final VoidCallback onTap;

  _showPopupMenu(
    BuildContext context,
    Offset position,
    String status,
  ) {
    return showMenu(
      context: context,
      color: Theme.of(context).colorScheme.surface,
      position: RelativeRect.fromLTRB(
        position.dx - 200,
        position.dy,
        30,
        0,
      ),
      items: [
        const PopupMenuItem(
          child: Text("Archive"),
        ),
        if (status == "Open") ...[
          PopupMenuItem(
            onTap: onTapClose,
            child: const Text("Mark as closed"),
          ),
        ],
        PopupMenuItem(
          onTap: onTapDelete,
          child: const Text("Delete"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
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
          vertical: 8.0,
          horizontal: 16.0,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: status == 'Open' ? Colors.green : Colors.red,
                  ),
                  margin: const EdgeInsets.only(right: 20.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        id,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        status,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: status == 'Open' ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        title,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            TextUtils.capitalizeFirstLetter(windFarm),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 16,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            createdAt.toDateString(),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        trailing: GestureDetector(
          onTapDown: (TapDownDetails details) {
            _showPopupMenu(
              context,
              details.globalPosition,
              status,
            );
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
