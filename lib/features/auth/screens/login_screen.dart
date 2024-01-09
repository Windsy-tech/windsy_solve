import 'package:flutter/material.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/auth/screens/login_screen_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Solve",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Image.asset(
                  Constants.logoPath,
                  height: 40,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Expanded(
                child: SignInForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
