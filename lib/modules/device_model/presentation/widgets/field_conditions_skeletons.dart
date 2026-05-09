import 'package:flutter/material.dart';

class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class SystemTabSkeleton extends StatelessWidget {
  const SystemTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SkeletonBox(width: double.infinity, height: 120, borderRadius: 20),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: SkeletonBox(width: double.infinity, height: 100, borderRadius: 16)),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(width: double.infinity, height: 100, borderRadius: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: SkeletonBox(width: double.infinity, height: 100, borderRadius: 16)),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(width: double.infinity, height: 100, borderRadius: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class SensorTabSkeleton extends StatelessWidget {
  const SensorTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: const SkeletonBox(width: double.infinity, height: 90, borderRadius: 16),
      ),
    );
  }
}
