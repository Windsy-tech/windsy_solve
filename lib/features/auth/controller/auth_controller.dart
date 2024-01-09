import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/respository/auth_repository.dart';

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithEmailAndPassword(String? email, String? password) {
    _authRepository.signInWithEmailAndPassword(email, password);
  }
}
