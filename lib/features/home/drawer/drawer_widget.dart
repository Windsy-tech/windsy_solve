import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/widgets/show_inspection_modal.dart';
import 'package:windsy_solve/features/nc/widgets/show_nc_modal.dart';
import 'package:windsy_solve/theme/pallete.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  void signout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  void navigateToReportNCPage(BuildContext context) {
    showNCModelBottomSheet(context);
    Scaffold.of(context).closeDrawer();
  }

  void showInspectionModal(BuildContext context) {
    showInspectionModelBottomSheet(context);
    Scaffold.of(context).closeDrawer();
  }

  void navigateToSettingsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rSettings);
    Scaffold.of(context).closeDrawer();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => navigateToUserProfile(context, user.uid),
                leading: CircleAvatar(
                  radius: 14,
                  backgroundImage: user.photoUrl != ''
                      ? NetworkImage(user.photoUrl)
                      : Image.asset(
                          Constants.pProfileAvatarDefault,
                          fit: BoxFit.cover,
                        ).image,
                  backgroundColor: Pallete.greyColor,
                ),
                title: Text(user.email),
              ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => navigateToReportNCPage(context),
                      leading: const Icon(Icons.report),
                      title: const Text("Report NC"),
                    ),
                    ListTile(
                      onTap: () => showInspectionModal(context),
                      leading: const Icon(Icons.construction),
                      title: const Text("Perform Inspection"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.wysiwyg),
                      title: Text("Reports Dashboard"),
                    ),
                    ListTile(
                      onTap: () => navigateToSettingsPage(context),
                      leading: const Icon(Icons.settings),
                      title: const Text("Settings"),
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
      ),
    );
  }
}
