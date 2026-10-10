import 'package:flutter/material.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_body.dart';

class SwipeableReadingBody extends StatefulWidget {
  final ReadingState state;

  const SwipeableReadingBody({super.key, required this.state});

  @override
  State<SwipeableReadingBody> createState() => _SwipeableReadingBodyState();
}

class _SwipeableReadingBodyState extends State<SwipeableReadingBody> {
  @override
  Widget build(BuildContext context) {
    return ReadingBody(state: widget.state);
  }
}
