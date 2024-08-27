import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/features/auth/cubit/log_out_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class LogOutDialog extends StatefulWidget {
  const LogOutDialog({super.key});

  @override
  State<LogOutDialog> createState() => _LogOutDialogState();
}

class _LogOutDialogState extends State<LogOutDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16) +
          const EdgeInsets.only(bottom: 16),
      child: BlocListener<LogOutCubit, LogOutState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: () {
              GoRouter.of(context)
                ..pop()
                ..go(FlutterConRouter.signInRoute);
            },
            orElse: () {},
          );
        },
        child: Column(
          children: [
            AutoSizeText(
              l10n.areYouSureLogOut,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AutoSizeText(
              l10n.logoutDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.read<LogOutCubit>().logOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: BlocBuilder<LogOutCubit, LogOutState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => AutoSizeText(
                        l10n.logoutLoading.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      orElse: () => AutoSizeText(
                        l10n.confirmLogout.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorScheme.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: AutoSizeText(
                  l10n.cancel.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
