import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/search/cubit/search_cubit.dart';
import 'package:fluttercon/search/cubit/search_state.dart';
import 'package:fluttercon/search/models/search_result.dart';
import 'package:go_router/go_router.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchCubit>(),
      child: const SearchBarView(),
    );
  }
}

class SearchBarView extends StatefulWidget {
  const SearchBarView({super.key});

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
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
      } else {
        context.read<SearchCubit>().clearSearch();
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
        _buildSearchBar(),
        const SizedBox(height: 10),
        _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
              icon: const Icon(
                Icons.cancel,
                color: ThemeColors.orangeDroidconColor,
              ),
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return state.when(
          initial: Container.new,
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: _buildSearchResultsList,
          error: (message) => Center(
            child: Text(
              message,
              style: const TextStyle(color: ThemeColors.orangeDroidconColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResultsList(List<SearchResult> results) {
    if (results.isEmpty) {
      return const Text('No results found');
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) => _buildSearchResultItem(results[index]),
    );
  }

  Widget _buildSearchResultItem(SearchResult result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: ThemeColors.orangeDroidconColor),
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
            style: const TextStyle(color: ThemeColors.greyTextColor),
          ),
          onTap: () => _handleResultTap(result),
        ),
      ),
    );
  }

  void _handleResultTap(SearchResult result) {
    FocusScope.of(context).unfocus();
    switch (result.type) {
      case SearchResultType.session:
        if (result.session != null) {
          context
              .push(FlutterConRouter.sessionDetailsRoute, extra: result.session)
              .then((_) => _clearSearch());
        }
      case SearchResultType.speaker:
        if (result.speaker != null) {
          context
              .push(
            FlutterConRouter.speakerDetailsRoute,
            extra: result.speaker,
          )
              .then((_) => _clearSearch());
        }
      case SearchResultType.sponsor:
        break;
      case SearchResultType.organizer:
        break;
    }
  }
}
