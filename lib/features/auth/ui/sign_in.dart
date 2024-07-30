import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/repository/auth_repository.dart';
import 'package:fluttercon/core/di/injectable.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleAuthButton(
                onPressed: () async {
                  await getIt<AuthRepository>().signInWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
