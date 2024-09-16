import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/search/cubit/search_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import '../cubit/search_state.dart';
import '../models/search_result.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchCubit>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: ThemeColors.lightGrayBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: ThemeColors.greyTextColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Search sessions and speakers...',
                    hintStyle: TextStyle(color: ThemeColors.greyTextColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (query) => context.read<SearchCubit>().search(query),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,  // Subtle shadow
                    shadowColor: Colors.black.withOpacity(0.1),
                    child: ListTile(
                      leading: SizedBox(
                        width: 56,
                        height: 56,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ResolvedImage(imageUrl: result.imageUrl),
                        ),
                      ),
                      title: Text(
                        result.title,
                        style: const TextStyle(
                          color: ThemeColors.blueDroidconColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        result.subtitle,
                        style: const TextStyle(
                          color: ThemeColors.greyTextColor,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        switch (result.type) {
                          case SearchResultType.session:
                            context.push(FlutterConRouter.sessionDetailsRoute, extra: result.extra as LocalSession);
                            break;
                          case SearchResultType.speaker:
                            context.push(FlutterConRouter.speakerDetailsRoute, extra: result.extra as LocalSpeaker);
                            break;
                          case SearchResultType.sponsor:
                            break;
                          case SearchResultType.organizer:
                            break;
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is SearchError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: ThemeColors.orangeDroidconColor, fontSize: 16),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Start searching...',
                style: TextStyle(color: ThemeColors.lightGreyTextColor, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
