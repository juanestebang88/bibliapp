import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/domain/usecases/add_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';
import 'package:bibliapp/features/reading/domain/usecases/delete_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_highlights.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/record_daily_reading_event.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_chapter_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/update_verse_highlight.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_lookup_listener.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_webview_dialog.dart';

import 'fake_webview_platform.dart';

void main() {
  late _MockCheckInternetConnectivity checkInternetConnectivity;
  late ReadingCubit cubit;

  setUp(() {
    checkInternetConnectivity = _MockCheckInternetConnectivity();
    cubit = ReadingCubit(
      getChapterVerses: _MockGetChapterVerses(),
      getChapterCount: _MockGetChapterCount(),
      getReadingProgress: _MockGetReadingProgress(),
      saveReadingProgress: _MockSaveReadingProgress(),
      getReadingSettings: _MockGetReadingSettings(),
      saveReadingSettings: _MockSaveReadingSettings(),
      getChapterProgress: _MockGetChapterProgress(),
      saveChapterProgress: _MockSaveChapterProgress(),
      getChapterHighlights: _MockGetChapterHighlights(),
      addVerseHighlight: _MockAddVerseHighlight(),
      updateVerseHighlight: _MockUpdateVerseHighlight(),
      deleteVerseHighlight: _MockDeleteVerseHighlight(),
      recordDailyReadingEvent: _MockRecordDailyReadingEvent(),
      checkInternetConnectivity: checkInternetConnectivity,
    );
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          null,
        );
    await cubit.close();
  });

  Future<void> pumpListener(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ReadingCubit>.value(
          value: cubit,
          child: const RaeLookupListener(child: SizedBox.shrink()),
        ),
      ),
    );
  }

  testWidgets('shows the no-internet dialog when offline', (tester) async {
    when(() => checkInternetConnectivity()).thenAnswer(
      (_) async => const Left<Failure, bool>(ConnectivityFailure('offline')),
    );
    await pumpListener(tester);

    await cubit.checkRaeConnectivity('paz');
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.needsInternetForRae), findsOneWidget);
    expect(find.byType(RaeWebViewDialog), findsNothing);
  });

  testWidgets('shows the RAE webview with the word when online', (
    tester,
  ) async {
    WebViewPlatform.instance = FakeWebViewPlatform();
    when(() => checkInternetConnectivity())
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    await pumpListener(tester);

    await cubit.checkRaeConnectivity('paz');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(RaeWebViewDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(RaeWebViewDialog),
        matching: find.text('paz'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('does not repeat the dialog after the cubit returns to unknown', (
    tester,
  ) async {
    when(() => checkInternetConnectivity()).thenAnswer(
      (_) async => const Left<Failure, bool>(ConnectivityFailure('offline')),
    );
    await pumpListener(tester);

    await cubit.checkRaeConnectivity('paz');
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.pump();

    expect(tester.widgetList(find.byType(AlertDialog)), hasLength(1));
    expect(cubit.state.raeAvailability, RaeAvailability.unknown);
  });
}

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetReadingProgress extends Mock implements GetReadingProgress {}

class _MockSaveReadingProgress extends Mock implements SaveReadingProgress {}

class _MockGetReadingSettings extends Mock implements GetReadingSettings {}

class _MockSaveReadingSettings extends Mock implements SaveReadingSettings {}

class _MockGetChapterProgress extends Mock implements GetChapterProgress {}

class _MockSaveChapterProgress extends Mock implements SaveChapterProgress {}

class _MockGetChapterHighlights extends Mock implements GetChapterHighlights {}

class _MockAddVerseHighlight extends Mock implements AddVerseHighlight {}

class _MockUpdateVerseHighlight extends Mock implements UpdateVerseHighlight {}

class _MockDeleteVerseHighlight extends Mock implements DeleteVerseHighlight {}

class _MockRecordDailyReadingEvent extends Mock
    implements RecordDailyReadingEvent {}

class _MockCheckInternetConnectivity extends Mock
    implements CheckInternetConnectivity {}
