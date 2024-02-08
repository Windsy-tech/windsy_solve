import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/delegates/nc_assign_search_delegate.dart';

class NCAssign extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final Function(Set<String>) onAssign;

  const NCAssign({
    super.key,
    required this.ref,
    required this.onAssign,
  });

  @override
  ConsumerState<NCAssign> createState() => _CreateConsumerNCAssignState();
}

class _CreateConsumerNCAssignState extends ConsumerState<NCAssign> {
  Set<String> assignedTo = {};

  void showSearchDelegate() {
    showSearch(
      context: context,
      delegate: NCAssignSearchDelegate(
        ref: ref,
        assignedTo: assignedTo,
        onAssign: (assigned) {
          setState(() {
            widget.onAssign(assigned);
          });
        },
      ),
    );
  }

  void onDeleted(String uid) {
    setState(() {
      assignedTo.remove(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LabelWidget("Reporting Team"),
            IconButton(
              onPressed: () => showSearchDelegate(),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 4),
        assignedTo.toList().isEmpty
            ? const SizedBox()
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: theme.colorScheme.secondaryContainer,
                ),
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...assignedTo.toList().map(
                      (e) {
                        return ref.watch(getUserDataProvider(e)).when(
                              data: (user) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InputChip(
                                  color: MaterialStateColor.resolveWith(
                                    (states) => theme.colorScheme.surface,
                                  ),
                                  avatar: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.photoUrl),
                                  ),
                                  label: Text(
                                    user.displayName,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  deleteIcon: const Icon(
                                    Icons.close,
                                    size: 14,
                                  ),
                                  onDeleted: () => onDeleted(user.uid),
                                  onPressed: () {},
                                ),
                              ),
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (error, stack) => const Center(
                                child: Text('Error'),
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
