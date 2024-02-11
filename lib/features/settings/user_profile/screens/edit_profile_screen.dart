import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/settings/user_profile/controller/user_profile_controller.dart';
import 'package:windsy_solve/utils/image_utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileFile;
  Uint8List? profileWebFile;

  late TextEditingController nameController;
  late TextEditingController phoneController;

  void navigateToUserProfilePage(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${widget.uid}');
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          context: context,
          name: nameController.text,
          phoneNumber: phoneController.text,
          photoUrl: '',
          profileFile: profileFile,
          profileWebFile: null,
        );
  }

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: ref.read(userProvider)!.displayName);
    phoneController = TextEditingController(
        text: ref.read(userProvider)!.phoneNumber.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          onPressed: () => navigateToUserProfilePage(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ref.watch(getUserDataProvider(widget.uid)).when(
                data: (user) => isLoading
                    ? const Loader()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Profile Image
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: profileFile != null
                                    ? FileImage(profileFile!)
                                    : profileWebFile != null
                                        ? MemoryImage(profileWebFile!)
                                        : user.photoUrl != ''
                                            ? NetworkImage(user.photoUrl)
                                            : Image.asset(
                                                Constants.pProfileAvatarDefault,
                                              ).image,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          //Name
                          const Text(
                            "Name",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: "Name",
                            ),
                          ),

                          const SizedBox(height: 20),

                          //Phone
                          const Text(
                            "Phone",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: phoneController,
                            decoration:
                                const InputDecoration(hintText: "Phone"),
                          ),
                        ],
                      ),
                loading: () => const Loader(),
                error: (error, stack) => ErrorText(
                  error: error.toString(),
                ),
              ),
        ),
      ),
    );
  }
}
