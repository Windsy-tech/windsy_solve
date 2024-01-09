import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  final String? email;
  final String? password;

  const SignInButton(this.email, this.password, {super.key});

  void signInWithEmailAndPassword(
      WidgetRef ref, String? email, String? password) {
    ref
        .read(authControllerProvider)
        .signInWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => signInWithEmailAndPassword(ref, email, password),
      style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50)),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontSize: 16,
          color: Pallete.whiteColor,
        ),
      ),
    );
  }
}
