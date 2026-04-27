import 'package:flutter/material.dart';

class MySeparator extends StatelessWidget {
  const MySeparator(
      {super.key, this.height = 1, this.color = const Color(0xFF808080)});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (dashWidth)).floor();
        return Flex(
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (index) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: index % 2 == 0 ? color : Colors.white),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
