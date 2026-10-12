import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

/// Overlays the reading chrome (header and bottom controls) on top of the
/// reading body and hides it while the user scrolls, showing it again after an
/// idle delay, on tap, or when the scroll reaches either end of the chapter.
class ReadingImmersiveScaffold extends StatefulWidget {
  final ReadingState state;
  final Widget header;
  final Widget? topAccessory;
  final Widget body;
  final Widget footer;

  const ReadingImmersiveScaffold({
    super.key,
    required this.state,
    required this.header,
    required this.body,
    required this.footer,
    this.topAccessory,
  });

  @override
  State<ReadingImmersiveScaffold> createState() =>
      _ReadingImmersiveScaffoldState();
}

class _ReadingImmersiveScaffoldState extends State<ReadingImmersiveScaffold>
    with SingleTickerProviderStateMixin {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _accessoryKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _headerSlide;
  late final Animation<Offset> _footerSlide;

  Timer? _idleTimer;
  double _accumulated = 0;
  double _headerHeight = 0;
  double _topInset = 0;
  double _bottomInset = 0;

  /// Scroll compensation used when the chrome becomes visible because the
  /// chapter bottom was reached: keeps the last verse above the footer while
  /// the inset grows instead of leaving it obscured behind the overlay.
  bool _pendingBottomCompensation = false;
  ScrollPosition? _bottomChromePosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.chromeDuration,
      value: 1,
    );
    _controller.addListener(_followBottomScrollPosition);
    _controller.addStatusListener(_onChromeStatusChanged);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.chromeCurve,
    );
    _fade = animation;
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(animation);
    _footerSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(animation);
    _scheduleMeasure();
  }

  @override
  void didUpdateWidget(covariant ReadingImmersiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final chapterChanged =
        oldWidget.state.currentBook != widget.state.currentBook ||
        oldWidget.state.currentChapter != widget.state.currentChapter;
    final startedLoading =
        oldWidget.state.status != ReadingStatus.loading &&
        widget.state.status == ReadingStatus.loading;
    if (chapterChanged || startedLoading) {
      _showChrome();
    }
    _scheduleMeasure();
  }

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final headerBox =
          _headerKey.currentContext?.findRenderObject() as RenderBox?;
      final accessoryBox =
          _accessoryKey.currentContext?.findRenderObject() as RenderBox?;
      final footerBox =
          _footerKey.currentContext?.findRenderObject() as RenderBox?;
      final headerHeight = headerBox?.size.height ?? 0;
      final topInset = headerHeight + (accessoryBox?.size.height ?? 0);
      final bottomInset = footerBox?.size.height ?? 0;
      if (headerHeight != _headerHeight ||
          topInset != _topInset ||
          bottomInset != _bottomInset) {
        setState(() {
          _headerHeight = headerHeight;
          _topInset = topInset;
          _bottomInset = bottomInset;
        });
      }
    });
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _cancelBottomCompensation();
    }
    if (notification is! ScrollUpdateNotification) return false;

    final metrics = notification.metrics;
    final pixels = metrics.pixels;

    if (pixels >= metrics.maxScrollExtent) {
      _trackBottomCompensation(notification);
      _showChrome();
      return false;
    }

    if (pixels <= metrics.minScrollExtent) {
      _cancelBottomCompensation();
      _showChrome();
      return false;
    }

    _cancelBottomCompensation();

    final delta = notification.scrollDelta;
    if (delta != null) {
      _accumulated += delta.abs();
    }

    _idleTimer?.cancel();
    _idleTimer = Timer(AppMotion.chromeIdleDelay, _showChrome);

    if (_accumulated >= AppMotion.scrollHideThreshold) {
      _accumulated = 0;
      _hideChrome();
    }
    return false;
  }

  void _showChrome() {
    _idleTimer?.cancel();
    _idleTimer = null;
    _accumulated = 0;
    _controller.forward();
  }

  void _hideChrome() {
    _controller.reverse();
  }

  /// Remembers the scrollable when the chapter bottom is reached while the
  /// chrome is still hidden, so its position can be kept pinned at the bottom
  /// while the inset grows.
  void _trackBottomCompensation(ScrollNotification notification) {
    if (_pendingBottomCompensation || _controller.isCompleted) return;
    final scrollable = notification.context
        ?.findAncestorStateOfType<ScrollableState>();
    if (scrollable == null) return;
    _bottomChromePosition = scrollable.position;
    _pendingBottomCompensation = true;
  }

  /// Keeps the last verse anchored at the bottom of the viewport (the footer
  /// top) while the chrome turns visible at the chapter bottom.
  void _followBottomScrollPosition() {
    if (!_pendingBottomCompensation) return;
    _pinBottomPosition();
  }

  void _pinBottomPosition() {
    final position = _bottomChromePosition;
    if (position == null) return;
    final max = position.maxScrollExtent;
    if ((position.pixels - max).abs() > 0.5) {
      position.jumpTo(max);
    }
  }

  void _onChromeStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    // maxScrollExtent is final only after the layout that applies the full
    // inset, so the last compensation runs once post-frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pendingBottomCompensation) return;
      _pinBottomPosition();
      _cancelBottomCompensation();
    });
  }

  void _cancelBottomCompensation() {
    _pendingBottomCompensation = false;
    _bottomChromePosition = null;
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Padding(
                padding: EdgeInsets.lerp(
                  EdgeInsets.zero,
                  EdgeInsets.only(top: _topInset, bottom: _bottomInset),
                  _controller.value,
                )!,
                child: child,
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _showChrome,
                  child: widget.body,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _headerSlide,
              child: FadeTransition(
                opacity: _fade,
                child: KeyedSubtree(key: _headerKey, child: widget.header),
              ),
            ),
          ),
          if (widget.topAccessory != null)
            Positioned(
              top: _headerHeight,
              left: 0,
              right: 0,
              child: KeyedSubtree(
                key: _accessoryKey,
                child: widget.topAccessory!,
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _footerSlide,
              child: FadeTransition(
                opacity: _fade,
                child: KeyedSubtree(key: _footerKey, child: widget.footer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
