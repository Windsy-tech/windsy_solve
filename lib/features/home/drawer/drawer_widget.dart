import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/theme/pallete.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  void signout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  void navigateToReportNC(BuildContext context) {
    Routemaster.of(context).push(Constants.reportNC);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundImage: user.photoUrl != ''
                    ? NetworkImage(user.photoUrl)
                    : Image.asset(
                        Constants.profileAvatarDefault,
                        fit: BoxFit.cover,
                      ).image,
                backgroundColor: Pallete.greyColor,
              ),
              onTap: () {},
              title: Text(user.email),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => navigateToReportNC(context),
                    leading: const Icon(Icons.report),
                    title: const Text("Report NC"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.construction),
                    title: Text("Perform Inspection"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.wysiwyg),
                    title: Text("Reports Dashboard"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () => signout(ref),
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
