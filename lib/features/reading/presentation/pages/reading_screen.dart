import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';
import 'package:bibliapp/features/reading/domain/entities/search_focus.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_navigation.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_dialog.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_header.dart';
import 'package:bibliapp/features/reading/presentation/widgets/search_verse_dialog.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';

class ReadingScreen extends StatefulWidget {
  /// When set, the screen is the one pushed from search results: it jumps to
  /// the target verse and shows the white "back to results" button.
  final SearchFocus? focus;

  const ReadingScreen({super.key, this.focus});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool _didJump = false;

  Future<void> _openPassagePicker(
    BuildContext context,
    ReadingState state,
  ) async {
    final cubit = context.read<ReadingCubit>();
    final selection = await showDialog<PassageSelection>(
      context: context,
      builder: (_) => PassagePickerDialog(
        currentBook: state.currentBook,
        currentChapter: state.currentChapter,
        currentVerseNumber: state.currentVerseNumber,
      ),
    );
    if (selection == null) return;
    await cubit.loadChapterAndScrollTo(
      selection.reference.book,
      selection.reference.chapter,
      selection.verse,
    );
  }

  Future<void> _openSearch(BuildContext context) async {
    context.read<ReadingCubit>().clearFocus();
    final query = await showDialog<String>(
      context: context,
      builder: (_) => const SearchVerseDialog(),
    );
    if (query == null) return;
    if (!context.mounted) return;
    context.push('/search-results?q=${Uri.encodeQueryComponent(query.trim())}');
  }

  void _onStateChanged(BuildContext context, ReadingState state) {
    final focus = widget.focus;
    if (focus == null || _didJump) return;
    if (state.status != ReadingStatus.success) return;
    _didJump = true;
    context.read<ReadingCubit>().loadChapterAndScrollTo(
      focus.book,
      focus.chapter,
      focus.verse,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReadingCubit, ReadingState>(
      listener: _onStateChanged,
      child: Scaffold(
        body: BlocBuilder<ReadingCubit, ReadingState>(
          builder: (context, state) => SafeArea(
            child: Column(
              children: [
                ReadingHeader(
                  state: state,
                  onOpenPicker: () => _openPassagePicker(context, state),
                  onSearch: () => _openSearch(context),
                ),
                if (state.activeFocus != null) ...[
                  const _BackToResultsButton(),
                  SizedBox(height: AppSpacing.xs),
                ],
                Expanded(child: SwipeableReadingBody(state: state)),
                const SizedBox(height: AppSpacing.sm),
                ChapterNavigation(state: state),
                const BottomToolbar(
                  items: [
                    BottomToolbarItem(
                      icon: Icons.home_outlined,
                      label: AppStrings.home,
                    ),
                    BottomToolbarItem(
                      icon: Icons.menu_book_outlined,
                      label: AppStrings.reading,
                    ),
                    BottomToolbarItem(
                      icon: Icons.bar_chart,
                      label: AppStrings.statistics,
                    ),
                    BottomToolbarItem(
                      icon: Icons.settings_outlined,
                      label: AppStrings.settings,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackToResultsButton extends StatelessWidget {
  const _BackToResultsButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Material(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: AppColors.darkText, size: 18),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    AppStrings.backToResults,
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
