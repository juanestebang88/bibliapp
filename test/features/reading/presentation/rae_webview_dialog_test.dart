import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_webview_dialog.dart';

import 'fake_webview_platform.dart';

void main() {
  late FakeWebViewPlatform fakePlatform;

  setUp(() {
    fakePlatform = FakeWebViewPlatform();
    WebViewPlatform.instance = fakePlatform;
  });

  Future<void> openDialog(WidgetTester tester, {String word = 'paz'}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => RaeWebViewDialog(word: word),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('requests the RAE page and shows the loading indicator', (
    tester,
  ) async {
    await openDialog(tester);

    expect(find.text('paz'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    final controller = fakePlatform.lastController!;
    expect(
      controller.loadedRequests.single.toString(),
      'https://dle.rae.es/paz',
    );
  });

  testWidgets('caps the dialog height at 70% of the screen', (tester) async {
    await openDialog(tester);

    final maxHeights = tester
        .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
        .map((box) => box.constraints.maxHeight);
    expect(maxHeights, contains(600 * 0.7));
  });

  testWidgets('renders only the .o-main block after the page finishes', (
    tester,
  ) async {
    await openDialog(tester);

    final controller = fakePlatform.lastController!;
    controller.navigationDelegate!.onPageFinished!('https://dle.rae.es/paz');
    await tester.pumpAndSettle();

    expect(controller.injectedScripts, hasLength(1));
    expect(controller.injectedScripts.single, contains(".o-main"));
    expect(find.byKey(const Key('fake-webview')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows the error view with retry and close when loading fails', (
    tester,
  ) async {
    await openDialog(tester);

    fakePlatform.lastController!.navigationDelegate!.onWebResourceError!(
      const WebResourceError(errorCode: -2, description: 'failed'),
    );
    await tester.pump();

    expect(find.text(AppStrings.errorLoadingRae), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
    expect(find.text(AppStrings.close), findsOneWidget);
  });

  testWidgets('retry requests the page again', (tester) async {
    await openDialog(tester);

    final controller = fakePlatform.lastController!;
    controller.navigationDelegate!.onWebResourceError!(
      const WebResourceError(errorCode: -2, description: 'failed'),
    );
    await tester.pump();

    await tester.tap(find.text(AppStrings.retry));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(controller.loadedRequests, hasLength(2));
  });

  testWidgets('close button dismisses the dialog', (tester) async {
    await openDialog(tester);

    expect(find.byType(RaeWebViewDialog), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.close));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(RaeWebViewDialog), findsNothing);
  });
}
