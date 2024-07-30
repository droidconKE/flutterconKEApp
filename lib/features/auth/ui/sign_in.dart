import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/features/auth/cubit/google_sign_in_cubit.dart';

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
              BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => const LinearProgressIndicator(),
                    orElse: () => GoogleAuthButton(
                      onPressed: () async =>
                          context.read<GoogleSignInCubit>().signInWithGoogle(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
