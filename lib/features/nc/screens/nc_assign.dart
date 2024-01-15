import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/screens/nc_assign_search_delegate.dart';

class NCAssign extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final Function(Set<String>) onAssign;

  const NCAssign({
    Key? key,
    required this.ref,
    required this.onAssign,
  }) : super(key: key);

  @override
  ConsumerState<NCAssign> createState() => _CreateConsumerNCAssignState();
}

class _CreateConsumerNCAssignState extends ConsumerState<NCAssign> {
  List<String> assignedTo = [];

  void showSearchDelegate() {
    showSearch(
      context: context,
      delegate: NCAssignSearchDelegate(
        ref,
        (assignedTo) {
          setState(() {
            this.assignedTo = assignedTo.toList();
            widget.onAssign(assignedTo);
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Assign To'),
            IconButton(
              onPressed: () => showSearchDelegate(),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 4),
        assignedTo.isEmpty
            ? const SizedBox()
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...assignedTo.map((e) {
                      return ref.watch(getUserDataProvider(e)).when(
                            data: (user) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InputChip(
                                avatar: CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoUrl),
                                ),
                                label: Text(
                                  user.displayName,
                                  style: const TextStyle(fontSize: 11),
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
                    }).toList()
                  ],
                ),
              ),
      ],
    );
  }
}
