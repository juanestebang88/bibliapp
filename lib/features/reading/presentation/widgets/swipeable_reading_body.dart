import 'package:flutter/material.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_body.dart';

class SwipeableReadingBody extends StatefulWidget {
  final ReadingState state;

  /// Reports the last verse number visible inside the viewport.
  final ValueChanged<int>? onVisibleVerseChanged;

  /// Extra trailing room in the scrollable content, used to keep the last
  /// verse clear of the floating progress button.
  final double bottomContentInset;

  const SwipeableReadingBody({
    super.key,
    required this.state,
    this.onVisibleVerseChanged,
    this.bottomContentInset = 0,
  });

  @override
  State<SwipeableReadingBody> createState() => _SwipeableReadingBodyState();
}

class _SwipeableReadingBodyState extends State<SwipeableReadingBody> {
  @override
  Widget build(BuildContext context) {
    return ReadingBody(
      state: widget.state,
      onVisibleVerseChanged: widget.onVisibleVerseChanged,
      bottomContentInset: widget.bottomContentInset,
    );
  }
}
