import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  void navigateToGeneralSettings(BuildContext context) {
    Routemaster.of(context).push(Constants.rGeneralSettings);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => Routemaster.of(context).push('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                onTap: () => navigateToUserProfile(context, user.uid),
                leading: const Icon(Icons.person),
                title: const Text("User Profile"),
              ),
              ListTile(
                onTap: () => navigateToGeneralSettings(context),
                leading: const Icon(Icons.settings),
                title: const Text("General Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
