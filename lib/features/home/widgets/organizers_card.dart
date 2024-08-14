import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_organisers_cubit.dart';

class OrganizersCard extends StatefulWidget {
  const OrganizersCard({super.key});

  @override
  State<OrganizersCard> createState() => _OrganizersCardState();
}

class _OrganizersCardState extends State<OrganizersCard> {
  @override
  void initState() {
    context.read<FetchOrganisersCubit>().fetchOrganisers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.sizeOf(context); //Widget to only rebuild when size changes

    return Container(
      width: double.infinity,
      height: size.height / 4,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeColors.lightGrayColor,
      ),
      child: Column(
        children: [
          const Spacer(),
          const Text(
            'Organised by:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ThemeColors.blueColor,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          BlocBuilder<FetchOrganisersCubit, FetchOrganisersState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (organisers) => Wrap(
                spacing: 10,
                children: [
                  for (final Organiser organiser in organisers)
                    SizedBox(
                      width: size.width / 4,
                      child: resolveImage(organiser),
                    ),
                ],
              ),
              error: (message) => Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.blueColor,
                      fontSize: 18,
                    ),
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget resolveImage(Organiser organiser) {
    return organiser.logo.contains('.svg')
        ? SvgPicture.network(organiser.logo)
        : CachedNetworkImage(imageUrl: organiser.logo);
  }
}
