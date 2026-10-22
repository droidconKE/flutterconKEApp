import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/common/widgets/status_view.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/home/cubit/fetch_organisers_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';

class OrganizersCard extends StatefulWidget {
  const OrganizersCard({super.key});

  @override
  State<OrganizersCard> createState() => _OrganizersCardState();
}

class _OrganizersCardState extends State<OrganizersCard> {
  @override
  void initState() {
    super.initState();

    context.read<FetchOrganisersCubit>().fetchOrganisers();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: Corners.s24Border,
        color: ThemeColors.flutterconMagenta,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            l10n.organisedBy,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ThemeColors.blackColor,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<FetchOrganisersCubit, FetchOrganisersState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (organisers) => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: organisers
                    .map(
                      (organiser) => Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Corners.s16Border,
                        ),
                        child: ResolvedImage(
                          imageUrl: organiser.logo,
                          height: 64,
                          width: 64,
                        ),
                      ),
                    )
                    .toList(),
              ),
              error: (message) => StatusView(
                icon: Icons.wifi_off_rounded,
                title: l10n.organisersErrorTitle,
                message: message,
                onRetry: () =>
                    context.read<FetchOrganisersCubit>().fetchOrganisers(),
              ),
              orElse: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
