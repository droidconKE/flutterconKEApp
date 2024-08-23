import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:fluttercon/features/auth/cubit/social_auth_sign_in_cubit.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    return BlocListener<GoogleSignInCubit, GoogleSignInState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loaded: (token) =>
              context.read<SocialAuthSignInCubit>().socialSignIn(token: token),
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          },
        );
      },
      child: BlocListener<SocialAuthSignInCubit, SocialAuthSignInState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loaded: () =>
                GoRouter.of(context).goNamed(FlutterConRouter.decisionRoute),
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          );
        },
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Image(image: AssetImage(AppAssets.flutterConKeLogo)),
                    const SizedBox(height: 64),
                    BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => const CircularProgressIndicator(),
                          orElse: () => GoogleAuthButton(
                            themeMode:
                                isLightMode ? ThemeMode.light : ThemeMode.dark,
                            onPressed: () async => context
                                .read<GoogleSignInCubit>()
                                .signInWithGoogle(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
