import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/search/cubit/search_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';

import '../../cubit/search_state.dart';
import '../../models/search_result.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchCubit>(),
      child: const SearchBarView(),
    );
  }
}

class SearchBarView extends StatefulWidget {
  const SearchBarView({Key? key}) : super(key: key);

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        context.read<SearchCubit>().search(query);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: ThemeColors.blueDroidconColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: ThemeColors.blueGreenDroidconColor),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sessions or speakers',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    border: InputBorder.none,
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.cancel, color:ThemeColors.orangeDroidconColor),
                  onPressed: _clearSearch,
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Search Results
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              if (state.results.isEmpty) {
                return const Text('No results found');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final result = state.results[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: ThemeColors.orangeDroidconColor
                        )
                      ),
                      elevation: 4,
                      child: ListTile(

                        leading: SizedBox(
                          width: 48,
                          height: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ResolvedImage(imageUrl: result.imageUrl),
                          ),
                        ),
                        title: Text(
                          result.title,
                          style: const TextStyle(
                            color: ThemeColors.blueDroidconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                            result.subtitle,
                            style: const TextStyle(color: ThemeColors.greyTextColor),),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          switch (result.type) {
                            case SearchResultType.session:
                              context.push(FlutterConRouter.sessionDetailsRoute,
                                  extra: result.extra as LocalSession)
                                  .then((_) {
                                _clearSearch();
                              });
                              break;
                            case SearchResultType.speaker:
                              context.push(FlutterConRouter.speakerDetailsRoute,
                                  extra: result.extra as LocalSpeaker)
                                  .then((_) {
                                _clearSearch();
                              });
                              break;
                            case SearchResultType.sponsor:
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
                  style: const TextStyle(color: ThemeColors.orangeDroidconColor),
                ),
              );
            } else {
              return Container();  // No results yet
            }
          },
        ),
      ],
    );
  }
}
