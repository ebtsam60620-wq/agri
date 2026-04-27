import 'package:flutter/material.dart';

typedef AnimationBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget? child,
);

// New typedef for the disposal logic
typedef ShouldDisposeCallback = bool Function(int index);

class LazyAnimatedIndexedStack extends StatefulWidget {
  const LazyAnimatedIndexedStack({
    super.key,
    this.index = 0,
    this.children = const <Widget>[],
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.sizing = StackFit.loose,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.animationBuilder,
    this.skipStart = false,
    this.skipEnd = false,
    // The logic function: return true to dispose the page when it's not active
    this.shouldDispose,
  });

  final int index;
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final Clip clipBehavior;
  final StackFit sizing;
  final Duration duration;
  final Curve curve;
  final AnimationBuilder? animationBuilder;
  final bool skipStart;
  final bool skipEnd;
  final ShouldDisposeCallback? shouldDispose;

  @override
  State<LazyAnimatedIndexedStack> createState() =>
      _LazyAnimatedIndexedStackState();
}

class _LazyAnimatedIndexedStackState extends State<LazyAnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late int _currentIndex = widget.index;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Set<int> _activatedChildren = {widget.index};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void didUpdateWidget(covariant LazyAnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _activate(widget.index);
      _runAnimation();
    }
  }

  void _activate(int index) {
    if (!_activatedChildren.contains(index)) {
      setState(() => _activatedChildren.add(index));
    }
  }

  Future<void> _runAnimation() async {
    if (!widget.skipStart) {
      await _controller.animateTo(1);
    } else {
      _controller.value = 1;
    }

    setState(() => _currentIndex = widget.index);

    if (!widget.skipEnd) {
      await _controller.animateTo(0);
    } else {
      _controller.value = 0;
    }
  }

  List<Widget> get _lazyChildren {
    return List.generate(
      widget.children.length,
      (i) {
        // 1. Is it currently visible?
        final bool isCurrent = i == _currentIndex;

        // 2. Has it been loaded before?
        final bool isActivated = _activatedChildren.contains(i);

        // 3. Does the user want to dispose it when inactive?
        final bool disposeThisPage = widget.shouldDispose?.call(i) ?? false;

        // Logic: Show if current OR (if it was loaded and NOT marked for disposal)
        if (isCurrent || (isActivated && !disposeThisPage)) {
          return widget.children[i];
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return widget.animationBuilder?.call(context, _animation, child) ??
            _defaultAnimationBuilder(context, _animation, child);
      },
      child: IndexedStack(
        index: _currentIndex,
        alignment: widget.alignment,
        sizing: widget.sizing,
        clipBehavior: widget.clipBehavior,
        textDirection: widget.textDirection,
        children: _lazyChildren,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Widget _defaultAnimationBuilder(
    BuildContext context, Animation<double> animation, Widget? child) {
  return Opacity(
    opacity: animation.value,
    child: Transform.translate(
      offset: Offset(0, (1 - animation.value) * 10),
      child: child,
    ),
  );
}
