import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/auth/screens/login_screen_widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Loader()
          : Container(
              color: theme.colorScheme.surface,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Image.asset(
                          Constants.pLogoPath,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SignInForm(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
