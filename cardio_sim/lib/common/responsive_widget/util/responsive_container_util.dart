import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:flutter/material.dart';

Widget convert(Widget widget, bool reverse) {
  bool isMobile = ResponsiveData.kIsMobile ^ reverse;
  if (widget is ResponsiveWidget) {
    int? flex = isMobile ? widget.mFlex : widget.wFlex;
    if (flex == null) return widget;
    return Expanded(flex: flex, child: widget);
  }
  if (widget is ResponsiveSizedBox) {
    return SizedBox(
      width: isMobile ? null : widget.size,
      height: isMobile ? widget.size : null,
    );
  }
  return widget;
}
