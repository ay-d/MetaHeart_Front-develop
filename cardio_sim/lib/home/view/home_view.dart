import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/home/components/home_menu_button.dart';
import 'package:cardio_sim/home/viewmodel/home_viewmodel.dart';
import 'package:cardio_sim/menu/component/menu_item.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  static String get routeName => "home";

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.isMaintainMenu == true) {
        viewModel.openDrawer();
        viewModel.close();
      }
    });

    return DefaultContainer(
      scaffoldKey: viewModel.scaffoldKey,
      backgroundColor: Colors.transparent,
      backgroundImage: Image.asset(
        "assets/image/background.png",
        fit: BoxFit.fill,
      ),
      titleColor: kTextReverseColor,
      leading: CustomIconButton(
        onPressed: viewModel.openDrawer,
        icon: Icons.menu,
        iconColor: kTextReverseColor,
      ),
      actions: [
        CustomPopupMenu(
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: const Color(0xFF4C4C4C),
                    height: ResponsiveSize.S(150),
                    width: ResponsiveSize.S(250),
                    padding: EdgeInsets.all(kPaddingMiddleSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.member.email,
                          style: kTextReverseStyle.copyWith(
                            fontSize: kTextSmallSize,
                          ),
                        ),
                        SizedBox(height: kPaddingMiddleSize),
                        Text(
                          viewModel.member.name,
                          style: kTextReverseStyle.copyWith(
                            fontSize: kTextMiddleSize,
                          ),
                        ),
                        Text(
                          "${viewModel.member.affiliation} (${viewModel.member.position})",
                          style: kTextReverseStyle.copyWith(
                            fontSize: kTextSmallSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: const Color(0xFF4C4C4C),
                    child: InkWell(
                      onTap: viewModel.logout,
                      child: Container(
                        height: ResponsiveSize.S(50),
                        padding: EdgeInsets.symmetric(
                          horizontal: kPaddingLargeSize,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.logout,
                              size: kIconSmallSize,
                              color: Colors.white,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Logout",
                                style: kTextReverseStyle.copyWith(
                                  fontSize: kTextMiddleSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          pressType: PressType.singleClick,
          verticalMargin: -10,
          controller: viewModel.menuController,
          child: Icon(Icons.person, color: Colors.white, size: kIconMiddleSize),
        ),
      ],
      margin: EdgeInsets.zero,
      title: "CardioSim",
      drawer: Drawer(
        width: ResponsiveSize.S(700),
        backgroundColor: kMainColor,
        child: ListenableBuilder(
          listenable: viewModel.menuStack,
          builder: (_, __) => Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          padding: EdgeInsets.all(kPaddingLargeSize),
                          child: Center(
                            child: Text(
                              viewModel.currentMenu.title,
                              style: kTextMainStyle.copyWith(
                                fontSize: kTextLargeSize,
                                color: kTextReverseColor,
                              ),
                            ),
                          ),
                        ),
                        if (viewModel.currentIndex != 0)
                          Positioned(
                            left: kPaddingMiddleSize,
                            child: CustomIconButton(
                              icon: Icons.navigate_before,
                              onPressed: viewModel.popMenu,
                              iconColor: kTextReverseColor,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: kPaddingMiddleSize),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.currentMenu.subMenu?.length ?? 0,
                        itemBuilder: (context, index) {
                          final menu = viewModel.currentMenu.subMenu![index];
                          return MenuItem(
                            menu,
                            textColor: kTextReverseColor,
                            onTap: viewModel.onMenuClicked,
                            onHover: (isHovered) => viewModel.onMenuHovered(
                              isHovered ? menu : viewModel.currentMenu,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: kBorderWidth),
              ValueListenableBuilder(
                valueListenable: viewModel.hoveredMenu,
                builder: (_, hoveredMenu, __) => _ExplainContainer(hoveredMenu),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => Stack(
          children: [
            Positioned(
              bottom: ResponsiveData.kIsMobile
                  ? ResponsiveSize.S(100) * 3
                  : ResponsiveSize.S(100),
              right: 0,
              child: SizedBox(
                width: ResponsiveSize.S(1000),
                child: const Image(
                  image: AssetImage("assets/image/c2_img.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 1, end: 0),
              duration: const Duration(milliseconds: 500),
              builder: (_, value, __) => Positioned(
                bottom: kPaddingMiddleSize -
                    ResponsiveSize.S(ResponsiveData.kIsMobile ? 100 : 150) *
                        value,
                width: constraints.maxWidth,
                child: ResponsiveContainer(
                  mCrossAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ResponsiveWidget(
                      wFlex: 4,
                      child: HomeMenuButton(
                        title: "Simulation",
                        onClick: viewModel.openDrawer,
                      ),
                    ),
                    ResponsiveSizedBox(size: kLayoutGutterSize),
                    ResponsiveWidget(
                      wFlex: 4,
                      child: HomeMenuButton(
                          title: "Logcat",
                          onClick: () =>
                              viewModel.navigateToLogcatPage(context)),
                    ),
                    ResponsiveSizedBox(size: kLayoutGutterSize),
                    ResponsiveWidget(
                      wFlex: 4,
                      child: HomeMenuButton(
                        title: "My Page",
                        onClick: viewModel.menuController.showMenu,
                      ),
                    ),
                  ],
                ),
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
      padding: EdgeInsets.all(kPaddingMiddleSize),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            menu.title,
            style: kTextReverseStyle.copyWith(fontSize: kTextLargeSize),
          ),
          Text(
            menu.explain ?? "",
            style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
          ),
          SizedBox(height: kPaddingXLargeSize),
          ListView.builder(
            shrinkWrap: true,
            itemCount: menu.subMenu?.length ?? 0,
            itemBuilder: (context, i) => Text(
              "· ${menu.subMenu?[i].title}",
              style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
            ),
          ),
        ],
      ),
    );
  }
}
