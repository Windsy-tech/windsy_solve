import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class NCAssignSearchDelegate extends SearchDelegate {
  final WidgetRef ref;
  final Set<String> assignedTo;
  final Function(Set<String>) onAssign;

  NCAssignSearchDelegate({
    required this.ref,
    required this.assignedTo,
    required this.onAssign,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void assignToUser(BuildContext context, String uid) {
    //ref.read(ncControllerProvider.notifier).assignToUser(uid);
    Navigator.pop(context);
  }

  void addAssignedTo(String uid) {
    if (!assignedTo.contains(uid)) {
      assignedTo.add(uid);
      onAssign(assignedTo);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref
        .watch(searchMembersProvider(TextUtils.capitalizeFirstLetter(query)))
        .when(
          data: (users) => ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return CheckboxListTile(
                value: assignedTo.contains(user.uid),
                /* title: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ), */
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    const SizedBox(width: 10),
                    Text(user.displayName),
                  ],
                ),
                onChanged: (value) {
                  if (assignedTo.contains(user.uid)) {
                    assignedTo.remove(user.uid);
                    onAssign(assignedTo);
                  } else {
                    addAssignedTo(user.uid);
                  }
                },
              );
            },
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
