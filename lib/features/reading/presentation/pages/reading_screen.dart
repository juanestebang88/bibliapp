import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_progress_button_tokens.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';
import 'package:bibliapp/features/reading/domain/entities/search_focus.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_navigation.dart';
import 'package:bibliapp/features/reading/presentation/widgets/consultation_continue_button.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_dialog.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_focus_actions.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_header.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_immersive_scaffold.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_progress_button.dart';
import 'package:bibliapp/features/reading/presentation/widgets/search_verse_dialog.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';

class ReadingScreen extends StatefulWidget {
  /// When set, the screen is the one pushed from search results: it jumps to
  /// the target verse and shows the consultation mode (no chapter navigation,
  /// actions pills, single continue button).
  final SearchFocus? focus;

  /// When set, this is the real reading screen opened at a specific location
  /// (via "continue my reading from here"): it jumps there with the progress
  /// counter visible and no back button.
  final SearchFocus? initialLocation;

  const ReadingScreen({super.key, this.focus, this.initialLocation});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool _didJump = false;
  String? _loadedBook;
  int? _loadedChapter;

  /// When set, the scroll counter ignores updates caused by programmatic
  /// scrolls (namely the landing jump) and only reacts to the user's own
  /// drags. Used when this screen is opened at a location in a chapter that
  /// is not marked as read, so the counter starts at 0 %.
  bool _counterUserScrollOnly = false;

  final ValueNotifier<int> _visibleVerse = ValueNotifier<int>(0);

  @override
  void dispose() {
    _visibleVerse.dispose();
    super.dispose();
  }

  /// Resets the visible verse tracker when the loaded chapter changes so the
  /// progress button never mixes verses from a previous chapter. A chapter with
  /// saved partial progress starts at that percentage; a fresh one starts at
  /// 0 % (the "not started" sentinel) until the user scrolls. Only seeds on a
  /// successful load, when the chapter progress is available. While the
  /// counter is restricted to user drags (landing at a location), no partial
  /// seed is applied: the landing shows 0 %.
  void _trackChapterChange(ReadingState state) {
    if (state.status != ReadingStatus.success) return;
    if (_loadedBook == state.currentBook &&
        _loadedChapter == state.currentChapter) {
      return;
    }
    _loadedBook = state.currentBook;
    _loadedChapter = state.currentChapter;
    final progress = state.chapterProgress;
    final seed = _counterUserScrollOnly
        ? 0
        : progress != null && !progress.isComplete && progress.lastVerseRead > 0
        ? progress.lastVerseRead
        : 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _visibleVerse.value = seed;
    });
  }

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
    final target = widget.focus ?? widget.initialLocation;
    if (target == null || _didJump) return;
    if (state.status != ReadingStatus.success) return;
    _didJump = true;
    if (widget.initialLocation != null && !_counterUserScrollOnly) {
      setState(() => _counterUserScrollOnly = true);
    }
    context.read<ReadingCubit>().loadChapterAndScrollTo(
      target.book,
      target.chapter,
      target.verse,
      markSearchFocus: widget.focus != null,
    );
  }

  void _onVisibleVerseChanged(int verse) {
    // The first report that gets through while the counter is restricted to
    // user drags comes from a real drag: normal counter behavior resumes.
    if (_counterUserScrollOnly) {
      setState(() => _counterUserScrollOnly = false);
    }
    _visibleVerse.value = verse;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReadingCubit, ReadingState>(
      listener: _onStateChanged,
      child: Scaffold(
        body: BlocBuilder<ReadingCubit, ReadingState>(
          builder: (context, state) {
            _trackChapterChange(state);
            final isConsultation = widget.focus != null;
            return ReadingImmersiveScaffold(
              state: state,
              header: ReadingHeader(
                state: state,
                onOpenPicker: () => _openPassagePicker(context, state),
                onSearch: () => _openSearch(context),
              ),
              topAccessory: isConsultation
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: ReadingFocusActions(
                        showBackToResults: state.activeFocus != null,
                      ),
                    )
                  : null,
              body: !isConsultation
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: SwipeableReadingBody(
                            state: state,
                            bottomContentInset:
                                AppProgressButtonTokens.contentBottomClearance,
                            userScrollOnly: _counterUserScrollOnly,
                            onVisibleVerseChanged: _onVisibleVerseChanged,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.md,
                              bottom: AppProgressButtonTokens.bottomMargin,
                            ),
                            child: ReadingProgressButton(
                              state: state,
                              visibleVerse: _visibleVerse,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SwipeableReadingBody(
                      state: state,
                      chapterSwipeEnabled: false,
                    ),
              footer: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  if (isConsultation)
                    ConsultationContinueButton(
                      book: state.currentBook,
                      chapter: state.currentChapter,
                      verse: state.currentVerseNumber,
                      enabled: state.status == ReadingStatus.success,
                    )
                  else
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
            );
          },
        ),
      ),
    );
  }
}
