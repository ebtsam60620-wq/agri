import 'package:flutter/material.dart';

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(
    BuildContext context,
    Widget child,
    bool isKeyboardVisible,
  ) builder;
  final void Function(bool)? onStateChange;
  final bool doRebuild;

  const KeyboardVisibilityBuilder({
    required this.child,
    required this.builder,
    this.doRebuild = false,
    this.onStateChange,
    super.key,
  });

  @override
  KeyboardVisibilityBuilderState createState() =>
      KeyboardVisibilityBuilderState();
}

class KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      _isKeyboardVisible = newValue;
      if (widget.doRebuild) {
        setState(() {});
      }
      if (widget.onStateChange != null) {
        widget.onStateChange!(_isKeyboardVisible);
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}
