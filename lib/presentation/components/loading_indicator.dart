import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    super.key,
    this.cancelToken,
    this.onCreated, // Callback to pass the progress logic back to the parent
  });

  final CancelToken? cancelToken;

  /// This gives the parent a function to call: (sent, total) => void
  final Function(void Function(int, int))? onCreated;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    // We pass the "updater" function back to the parent widget immediately
    widget.onCreated?.call(_updateProgress);
  }

  void _updateProgress(int sent, int total) {
    if (total != -1 && mounted) {
      setState(() {
        _progressValue = sent / total;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int percentage = (_progressValue * 100).toInt();

    return Center(
      child: widget.cancelToken != null && widget.onCreated != null
          ? GestureDetector(
              onTap: () => widget.cancelToken?.cancel('User cancelled'),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 65,
                    height: 65,
                    child: CircularProgressIndicator(
                      value: _progressValue > 0 ? _progressValue : null,
                      strokeWidth: 5,
                      backgroundColor: ColorsManager.grey.withAlpha(
                        0.2.toAlpha,
                      ),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        ColorsManager.primary,
                      ),
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primary,
                    ),
                  ),
                ],
              ),
            )
          : widget.cancelToken == null && widget.onCreated != null
          ? Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 65,
                  height: 65,
                  child: CircularProgressIndicator(
                    value: _progressValue > 0 ? _progressValue : null,
                    strokeWidth: 5,
                    backgroundColor: ColorsManager.grey.withAlpha(0.2.toAlpha),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorsManager.primary,
                    ),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primary,
                  ),
                ),
              ],
            )
          : CircularProgressIndicator(
              strokeWidth: 5,
              backgroundColor: ColorsManager.grey.withAlpha(0.2.toAlpha),
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorsManager.primary,
              ),
            ),
    );
  }
}
