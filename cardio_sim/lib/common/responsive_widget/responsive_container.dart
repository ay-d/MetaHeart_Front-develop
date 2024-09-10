import 'package:cardio_sim/common/responsive_widget/util/responsive_container_util.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:flutter/material.dart';

class ResponsiveDivider extends StatelessWidget {
  const ResponsiveDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveData.kIsMobile ? const Divider() : const VerticalDivider();
  }
}

class ResponsiveSizedBox extends StatelessWidget {
  final double size;
  final Widget? child;

  const ResponsiveSizedBox({
    Key? key,
    required this.size,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: child,
      );
}

class ResponsiveWidget extends StatelessWidget {
  final int? mFlex;
  final int? wFlex;

  final BoxConstraints? constraints;

  final Widget child;

  const ResponsiveWidget({
    Key? key,
    this.mFlex,
    this.wFlex,
    this.constraints,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: constraints,
        child: child,
      );
}

class ResponsiveContainer extends StatelessWidget {
  final bool reverse;
  final MainAxisAlignment wMainAlignment;
  final MainAxisSize wMainSize;
  final CrossAxisAlignment wCrossAlignment;
  final MainAxisAlignment mMainAlignment;
  final MainAxisSize mMainSize;
  final CrossAxisAlignment mCrossAlignment;
  final List<Widget> children;

  const ResponsiveContainer({
    Key? key,
    this.reverse = false,
    this.mMainAlignment = MainAxisAlignment.start,
    this.wMainSize = MainAxisSize.min,
    this.wCrossAlignment = CrossAxisAlignment.start,
    this.wMainAlignment = MainAxisAlignment.start,
    this.mMainSize = MainAxisSize.min,
    this.mCrossAlignment = CrossAxisAlignment.center,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = this.children.map((e) => convert(e, reverse)).toList();
    return ResponsiveData.kIsMobile ^ reverse
        ? Column(
            mainAxisAlignment: mMainAlignment,
            mainAxisSize: mMainSize,
            crossAxisAlignment: mCrossAlignment,
            children: children,
          )
        : Row(
            mainAxisAlignment: wMainAlignment,
            mainAxisSize: wMainSize,
            crossAxisAlignment: wCrossAlignment,
            children: children,
          );
  }
}
