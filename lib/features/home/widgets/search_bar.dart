import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/search_result_type.dart';
import 'package:fluttercon/common/data/models/search_result.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/search_cubit.dart';
import 'package:fluttercon/features/home/cubit/search_state.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
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
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: ThemeColors.blueDroidconColor),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.cancel, color: colorScheme.error),
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
            child: AutoSizeText(
              message,
              style: const TextStyle(color: ThemeColors.orangeDroidconColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResultsList(List<SearchResult> results) {
    final l10n = context.l10n;
    if (results.isEmpty) {
      return AutoSizeText(l10n.errorSearch);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) => _buildSearchResultItem(results[index]),
    );
  }

  Widget _buildSearchResultItem(SearchResult result) {
    final (_, colorScheme) = Misc.getTheme(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.primary),
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
          title: AutoSizeText(
            result.title,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: AutoSizeText(
            result.subtitle,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
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
          GoRouter.of(context)
              .push(
                FlutterConRouter.sessionDetailsRoute,
                extra: result.session,
              )
              .then((_) => _clearSearch());
        }
      case SearchResultType.speaker:
        if (result.speaker != null) {
          GoRouter.of(context)
              .push(
                FlutterConRouter.speakerDetailsRoute,
                extra: result.speaker,
              )
              .then((_) => _clearSearch());
        }
      case SearchResultType.organizer:
        if (result.organizer != null) {
          GoRouter.of(context)
              .push(
                FlutterConRouter.organiserDetailsRoute,
                extra: result.organizer,
              )
              .then((_) => _clearSearch());
        }
    }
  }
}
