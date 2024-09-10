import 'dart:math';

import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Color backgroundColor;
  final Color color;
  final String? title;
  final Color? titleColor;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget body;
  final bool isExpanded;
  final Widget? drawer;
  final Image? backgroundImage;
  late final EdgeInsetsGeometry margin;

  DefaultContainer({
    Key? key,
    this.scaffoldKey,
    this.backgroundColor = kBackgroundMainColor,
    this.color = Colors.transparent,
    this.title,
    this.titleColor,
    this.leading,
    this.actions,
    this.drawer,
    this.backgroundImage,
    this.isExpanded = false,
    EdgeInsetsGeometry? margin,
    required this.body,
  }) : super(key: key) {
    this.margin = margin ??
        EdgeInsets.symmetric(
          vertical: kPaddingMiddleSize,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: title == null
          ? null
          : _DefaultLayoutAppBar(
              title: title ?? "",
              leading: leading,
              actions: actions,
              color: backgroundColor,
              titleColor: titleColor,
            ),
      drawer: drawer,
      body: Stack(
        children: [
          if (backgroundImage != null) Positioned.fill(child: backgroundImage!),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) => _DefaultLayoutContainer(
                      color: color,
                      margin: margin,
                      height: (isExpanded
                              ? constraints.maxHeight
                              : max(
                                  ResponsiveData.kIsMobile
                                      ? constraints.maxWidth * 3 / 2
                                      : constraints.maxWidth * 8 / 15,
                                  MediaQuery.of(context).size.height,
                                )) -
                          margin.vertical * 2 -
                          kLayoutMarginSize * 2 -
                          (title == null ? 0 : kToolbarHeight),
                      child: body,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultLayoutContainer extends Container {
  _DefaultLayoutContainer({
    super.color,
    super.margin,
    super.child,
    required double height,
  }) : super(
          constraints: BoxConstraints(
            maxWidth: kLayoutMaxSize,
            maxHeight: height,
          ),
          padding: EdgeInsets.symmetric(horizontal: kLayoutMarginSize),
        );
}

class _DefaultLayoutAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Color color;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? titleColor;

  const _DefaultLayoutAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.color = kBackgroundMainColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final appbarHeight =
        ResponsiveData.kIsMobile ? kToolbarHeight - 10 : kToolbarHeight;
    return Container(
      padding: EdgeInsets.symmetric(vertical: kPaddingSmallSize),
      child: Center(
        child: _DefaultLayoutContainer(
          height: appbarHeight,
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: color,
            leading: leading,
            elevation: 0,
            title: Text(
              title,
              style: kTextMainStyle.copyWith(
                fontSize: kTextTitleSize,
                color: titleColor,
              ),
              textAlign: ResponsiveData.kIsMobile ? TextAlign.center : null,
            ),
            actions: actions?.expand(_addPadding).toList(),
            foregroundColor: Colors.black,
          ),
        ),
      ),
    );
  }

  Iterable<Widget> _addPadding(Widget element) =>
      [SizedBox(width: kPaddingMiddleSize), element];

  @override
  Size get preferredSize => Size.fromHeight(
      ResponsiveData.kIsMobile ? kToolbarHeight - 10 : kToolbarHeight);
}
