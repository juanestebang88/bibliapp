import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_webview_dialog.dart';
import 'package:bibliapp/features/reading/presentation/widgets/verse_context_menu.dart';

import 'fake_webview_platform.dart';

class _MockCheckInternetConnectivity extends Mock
    implements CheckInternetConnectivity {}

const _verse = VerseEntity(book: 'john', chapter: 3, verse: 16, text: 'paz');

void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          null,
        );
    await getIt.reset();
  });

  Future<void> pumpMenu(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SelectableText.rich(
              const TextSpan(text: 'paz'),
              contextMenuBuilder: (context, editableTextState) =>
                  VerseContextMenu(
                    editableTextState: editableTextState,
                    verse: _verse,
                  ),
            ),
          ),
        ),
      ),
    );
    await tester.longPress(find.byType(SelectableText));
    await tester.pumpAndSettle();
  }

  void registerConnectivity({required bool hasInternet}) {
    final useCase = _MockCheckInternetConnectivity();
    when(() => useCase())
        .thenAnswer((_) async => Right<Failure, bool>(hasInternet));
    getIt.registerFactory<CheckInternetConnectivity>(() => useCase);
  }

  testWidgets('shows the three context actions in order', (tester) async {
    await pumpMenu(tester);

    expect(find.text(AppStrings.copyWord), findsOneWidget);
    expect(find.text(AppStrings.shareVerse), findsOneWidget);
    expect(find.text(AppStrings.searchInRae), findsOneWidget);

    final labels = tester
        .widgetList<TextSelectionToolbarTextButton>(
          find.byType(TextSelectionToolbarTextButton),
        )
        .map((button) => (button.child as Text).data)
        .toList();
    expect(labels, [
      AppStrings.copyWord,
      AppStrings.shareVerse,
      AppStrings.searchInRae,
    ]);
  });

  testWidgets('uses the white surface and the app background blue text', (
    tester,
  ) async {
    await pumpMenu(tester);

    final element = tester.element(
      find.byType(TextSelectionToolbarTextButton).first,
    );
    final scheme = Theme.of(element).colorScheme;
    expect(scheme.surface, AppColors.contextMenuBackground);
    expect(scheme.onSurface, AppColors.contextMenuForeground);
  });

  testWidgets('copy word puts the selected word in the clipboard', (
    tester,
  ) async {
    String? copied;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        });

    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.copyWord));
    await tester.pumpAndSettle();

    expect(copied, 'paz');
  });

  testWidgets('share verse shares the verse text with its reference', (
    tester,
  ) async {
    String? shared;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          (call) async {
            if (call.method == 'share') {
              shared = (call.arguments as Map)['text'] as String?;
            }
            return null;
          },
        );

    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.shareVerse));
    await tester.pumpAndSettle();

    expect(shared, 'paz — Juan 3:16');
  });

  testWidgets('search in RAE shows the no-internet dialog when offline', (
    tester,
  ) async {
    registerConnectivity(hasInternet: false);

    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.searchInRae));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.needsInternetForRae), findsOneWidget);
    expect(find.byType(RaeWebViewDialog), findsNothing);
  });

  testWidgets('search in RAE opens the webview dialog when online', (
    tester,
  ) async {
    WebViewPlatform.instance = FakeWebViewPlatform();
    registerConnectivity(hasInternet: true);

    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.searchInRae));
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
}
