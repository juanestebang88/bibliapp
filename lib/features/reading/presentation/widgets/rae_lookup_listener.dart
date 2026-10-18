import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_webview_dialog.dart';

/// Consumes the one-shot RAE connectivity result from [ReadingCubit] and shows
/// the matching dialog: the RAE webview when online, the no-internet alert
/// otherwise. The cubit returns to unknown after each result, so rebuilds never
/// repeat the dialog.
class RaeLookupListener extends StatelessWidget {
  final Widget child;

  const RaeLookupListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReadingCubit, ReadingState>(
      listenWhen: (previous, current) =>
          previous.raeAvailability != current.raeAvailability &&
          (current.raeAvailability == RaeAvailability.available ||
              current.raeAvailability == RaeAvailability.unavailable),
      listener: (context, state) {
        if (state.raeAvailability == RaeAvailability.unavailable) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text(AppStrings.noInternetConnection),
              content: const Text(AppStrings.needsInternetForRae),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(AppStrings.close),
                ),
              ],
            ),
          );
          return;
        }
        showDialog<void>(
          context: context,
          builder: (_) => RaeWebViewDialog(word: state.raeWord),
        );
      },
      child: child,
    );
  }
}
