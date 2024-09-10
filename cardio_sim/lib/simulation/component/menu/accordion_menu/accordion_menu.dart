import 'package:cardio_sim/common/component/container/accordion_container.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccordionMenu extends ConsumerStatefulWidget {
  final List<Widget> children;
  final BasicMenuAlign align;
  final BoxDecoration? decoration;
  final Color? titleColor;
  late final ChangeNotifierProvider<AccordionMenuController> provider;

  AccordionMenu({
    Key? key,
    required AccordionMenuController controller,
    this.align = BasicMenuAlign.left,
    this.decoration,
    this.titleColor,
    required this.children,
  })  : assert(controller.menuList.length == children.length),
        super(key: key) {
    provider = ChangeNotifierProvider((ref) => controller);
  }

  @override
  ConsumerState<AccordionMenu> createState() => _AccordionMenuState();
}

class _AccordionMenuState extends ConsumerState<AccordionMenu> {
  late AccordionMenuController controller;

  @override
  Widget build(BuildContext context) {
    controller = ref.watch(widget.provider);
    final children = [
      BasicMenu(controller: controller, align: widget.align),
      SizedBox(width: kPaddingMiddleSize, height: kPaddingMiddleSize),
      if (controller.isOpen)
        Expanded(
          flex: widget.align.isVertical ? 0 : 1,
          child: Container(
            decoration: widget.decoration,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: kPaddingMiddleSize),
                  child: Text(
                    controller.menuList[controller.index].text,
                    style: kTextMainStyle.copyWith(
                      fontSize: kTextMiddleSize,
                      color: widget.titleColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: widget.align.isVertical ? 0 : 1,
                  child: widget.children[controller.index],
                ),
              ],
            ),
          ),
        ),
    ];
    return ColumnRow(
      isColumn: widget.align.isVertical,
      children: widget.align.isReversed ? children.reversed.toList() : children,
    );
  }
}

class AccordionMenuController extends AccordionController
    implements BasicMenuController {
  @override
  final List<BasicMenuItemData> menuList;

  @override
  int index = -1;

  AccordionMenuController(
    this.menuList, {
    bool initState = false,
    super.onChange,
  }) {
    super.isOpen = initState;
  }

  @override
  void onMenuItemTap(int index) {
    if (this.index == index) {
      close();
    } else {
      this.index = index;
      open();
    }
  }

  @override
  void open() {
    index = 0;
    super.open();
  }

  @override
  void close() {
    index = -1;
    super.close();
  }

  @override
  set menuList(List<BasicMenuItemData> menuList) {
    this.menuList = menuList;
  }
}
