import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/menu/component/animated_menu_container.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:cardio_sim/menu/viewmodel/menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuView extends ConsumerWidget {
  static String get name => "menu";

  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MenuViewModel viewModel = ref.watch(menuViewModelProvider);
    return DefaultContainer(
      margin: EdgeInsets.zero,
      color: kBackgroundMainColor,
      body: Material(
        color: kBackgroundMainColor,
        child: ResponsiveContainer(
          wCrossAlignment: CrossAxisAlignment.center,
          children: [
            ResponsiveWidget(wFlex: 1, child: Container()),
            ResponsiveSizedBox(size: kLayoutGutterSize),
            ResponsiveWidget(
              wFlex: 4,
              mFlex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    vertical: ResponsiveData.kIsMobile
                        ? BorderSide.none
                        : BorderSide(
                            color: Colors.black.withOpacity(0.5),
                            width: kBorderWidth,
                          ),
                    horizontal: !ResponsiveData.kIsMobile
                        ? BorderSide.none
                        : BorderSide(
                            color: Colors.black.withOpacity(0.5),
                            width: kBorderWidth,
                          ),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: ResponsiveData.kIsMobile ? 3 : 2,
                      child: AnimatedMenuContainer(
                        controller: viewModel.menuController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ResponsiveSizedBox(size: kLayoutGutterSize),
            ResponsiveWidget(wFlex: 1, child: Container()),
            ResponsiveSizedBox(
              size: kLayoutGutterSize,
              child: Container(color: kBackgroundMainColor),
            ),
            ResponsiveWidget(
              wFlex: 6,
              mFlex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: ResponsiveData.kIsMobile ? 0 : 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(top: kPaddingMiddleSize),
                      child: _ExplainContainer(viewModel.hoveredMenu),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplainContainer extends StatelessWidget {
  final MenuType menu;

  const _ExplainContainer(this.menu, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundMainColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            menu.title,
            style: kTextMainStyle.copyWith(fontSize: kTextLargeSize),
          ),
          Text(
            menu.explain ?? "",
            style: kTextMainStyle.copyWith(fontSize: kTextMiddleSize),
          ),
          SizedBox(height: kPaddingXLargeSize),
          ListView.builder(
            shrinkWrap: true,
            itemCount: menu.subMenu?.length ?? 0,
            itemBuilder: (context, i) => Text(
              "· ${menu.subMenu?[i].title}",
              style: kTextMainStyle.copyWith(fontSize: kTextMiddleSize),
            ),
          ),
        ],
      ),
    );
  }
}
