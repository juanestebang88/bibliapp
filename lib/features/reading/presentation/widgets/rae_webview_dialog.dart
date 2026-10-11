import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

enum _RaeWebViewStatus { loading, ready, error }

/// Modal that shows the RAE definition of [word] inside a WebView.
class RaeWebViewDialog extends StatefulWidget {
  static const double _maxWidth = 420;
  static const double _maxHeightFactor = 0.7;

  final String word;
  final WebViewController? controller;
  final Widget Function(BuildContext context, WebViewController controller)?
  webViewBuilder;

  const RaeWebViewDialog({
    super.key,
    required this.word,
    this.controller,
    this.webViewBuilder,
  });

  @override
  State<RaeWebViewDialog> createState() => _RaeWebViewDialogState();
}

class _RaeWebViewDialogState extends State<RaeWebViewDialog> {
  // Keeps only the RAE dictionary block (.o-main); the <head> and its styles
  // stay, so the extracted content keeps the site typography.
  static const String _extractMainScript = '''
    (function () {
      var main = document.querySelector('.o-main');
      if (!main) { return; }
      document.body.innerHTML = main.outerHTML;
      document.body.style.margin = '0';
      document.body.style.padding = '0';
    })();
  ''';

  late final WebViewController _controller;
  _RaeWebViewStatus _status = _RaeWebViewStatus.loading;

  Uri get _uri =>
      Uri.parse('https://dle.rae.es/${Uri.encodeComponent(widget.word)}');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WebViewController();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _updateStatus(_RaeWebViewStatus.loading),
          onPageFinished: (_) => _onPageFinished(),
          onWebResourceError: (_) => _updateStatus(_RaeWebViewStatus.error),
        ),
      );
    _controller.loadRequest(_uri);
  }

  Future<void> _onPageFinished() async {
    await _extractMainContent();
    _updateStatus(_RaeWebViewStatus.ready);
  }

  Future<void> _extractMainContent() async {
    try {
      await _controller.runJavaScript(_extractMainScript);
    } catch (_) {
      // Showing the full page is an acceptable fallback when the RAE layout
      // cannot be trimmed down.
    }
  }

  void _updateStatus(_RaeWebViewStatus status) {
    if (!mounted || _status == status) return;
    setState(() => _status = status);
  }

  void _retry() {
    _updateStatus(_RaeWebViewStatus.loading);
    _controller.loadRequest(_uri);
  }

  void _close() => Navigator.of(context).pop();

  Color _dialogBackground(BuildContext context) {
    final theme = Theme.of(context);
    return theme.dialogTheme.backgroundColor ??
        theme.colorScheme.surfaceContainerHigh;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: RaeWebViewDialog._maxWidth,
          maxHeight:
              MediaQuery.of(context).size.height *
              RaeWebViewDialog._maxHeightFactor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(word: widget.word, onClose: _close),
            Flexible(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final webView =
        widget.webViewBuilder?.call(context, _controller) ??
        WebViewWidget(controller: _controller);
    return Stack(
      fit: StackFit.expand,
      children: [
        webView,
        if (_status == _RaeWebViewStatus.loading)
          ColoredBox(
            color: _dialogBackground(context),
            child: const Center(child: _LoadingView()),
          ),
        if (_status == _RaeWebViewStatus.error)
          ColoredBox(
            color: _dialogBackground(context),
            child: Center(
              child: _ErrorView(onRetry: _retry, onClose: _close),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String word;
  final VoidCallback onClose;

  const _Header({required this.word, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.xxl),
          Expanded(
            child: Text(
              word,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: AppStrings.close,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.loadingRae, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onClose;

  const _ErrorView({required this.onRetry, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.primary,
            size: AppSpacing.xxl,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.errorLoadingRae,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onClose,
                child: const Text(AppStrings.close),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
