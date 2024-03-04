import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/respository/auth_repository.dart';
import 'package:windsy_solve/models/common/user_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithEmailAndPassword(
    String? email,
    String? password,
    BuildContext context,
  ) async {
    state = true;
    final user = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    state = false;

    user.fold(
      (error) => showSnackBar(context, error.message, SnackBarType.error),
      (userModel) => _ref.read(userProvider.notifier).update(
            (state) => userModel,
          ),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void signOut() async {
    state = true;
    _authRepository.signOut();
    state = false;
  }
}
