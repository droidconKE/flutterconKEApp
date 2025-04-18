import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/features/home/cubit/fetch_organisers_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:sizer/sizer.dart';

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
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    final size = MediaQuery.sizeOf(context);
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      height: size.height * .3,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.secondaryContainer,
      ),
      child: Column(
        children: [
          const Spacer(),
          AutoSizeText(
            l10n.organisedBy,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          BlocBuilder<FetchOrganisersCubit, FetchOrganisersState>(
            builder:
                (context, state) => state.maybeWhen(
                  loaded:
                      (organisers) => SizedBox(
                        height: size.height * .2,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder:
                              (context, index) => Container(
                                height: size.height * .2,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color:
                                      isLightMode
                                          ? colorScheme.secondaryContainer
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        isLightMode
                                            ? Colors.transparent
                                            : colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: ResolvedImage(
                                  imageUrl: organisers[index].logo,
                                ),
                              ),
                          separatorBuilder: (_, __) => SizedBox(width: 4.w),
                          itemCount: organisers.length,
                        ),
                      ),
                  error:
                      (message) => AutoSizeText(
                        message,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          fontSize: 18,
                        ),
                      ),
                  orElse:
                      () => const Center(child: CircularProgressIndicator()),
                ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
