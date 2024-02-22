import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/settings/user_profile/repository/user_profile_repository.dart';
import 'package:windsy_solve/models/common/user_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

/*   Stream<UserModel> getUserData(String uid) {
    return _userProfileRepository.getUserData(uid);
  } */

  void editUserProfile({
    required BuildContext context,
    required File? profileFile,
    required Uint8List? profileWebFile,
    required String name,
    required String phoneNumber,
    required String photoUrl,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(photoUrl: r),
      );
    }
    user = user.copyWith(
      uid: user.uid,
      displayName: name,
      phoneNumber: int.parse(phoneNumber),
    );
    final res = await _userProfileRepository.editUserProfile(user);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).push('/user-profile/${user.uid}');
      },
    );
  }
}
