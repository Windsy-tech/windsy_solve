import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/widgets/labelled_text.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/theme/color_palette.dart';
import 'package:windsy_solve/theme/pallete.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToSettingsPage(BuildContext context) {
    Routemaster.of(context).push(Constants.rSettings);
  }

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile Screen'),
        leading: IconButton(
          onPressed: () => navigateToSettingsPage(context),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          //edit screen
          IconButton(
            onPressed: () => navigateToEditUser(context),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => Container(
              decoration: BoxDecoration(
                gradient: theme.brightness == Brightness.dark
                    ? ColorPalette.darkSurface
                    : ColorPalette.lightSurface,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user.photoUrl != ''
                                  ? NetworkImage(user.photoUrl)
                                  : Image.asset(
                                      Constants.pProfileAvatarDefault,
                                    ).image,
                              backgroundColor: Pallete.greyColor,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(user.companyName),
                              ],
                            ),
                          ],
                        ),
                      ),
                      LabelledText(label: "Email Address", text: user.email),
                      LabelledText(
                        label: "Phone Number",
                        text: "${user.countryCode} ${user.phoneNumber}",
                      ),
                      //Labelled Text for Expertise input like this ["Flutter", "Dart"]
                      LabelledText(
                        label: "Expertise",
                        text: user.expertise.join(", "),
                      ),
                      LabelledText(label: "Role", text: user.role),
                    ],
                  ),
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Center(
              child: Text('Error'),
            ),
          ),
    );
  }
}
