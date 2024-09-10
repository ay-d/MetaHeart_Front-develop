import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabMenu extends ConsumerStatefulWidget {
  final List<Widget>? children;
  final BasicMenuAlign align;
  late final ChangeNotifierProvider<TabMenuController> provider;

  TabMenu({
    Key? key,
    required TabMenuController controller,
    this.align = BasicMenuAlign.left,
    this.children,
  })  : assert(children != null
            ? controller.menuList.length == children.length
            : true),
        super(key: key) {
    provider = ChangeNotifierProvider((ref) => controller);
  }

  @override
  ConsumerState<TabMenu> createState() => _TabMenuState();
}

class _TabMenuState extends ConsumerState<TabMenu> {
  late TabMenuController controller;

  @override
  Widget build(BuildContext context) {
    controller = ref.watch(widget.provider);
    final children = [
      BasicMenu(controller: controller, align: widget.align),
      if (widget.children != null) ...[
        SizedBox(width: kPaddingMiddleSize, height: kPaddingMiddleSize),
        Expanded(
          flex: widget.align.isVertical ? 0 : 1,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(kPaddingMiddleSize),
                child: Text(
                  controller.menuList[controller.index].text,
                  style: kTextMainStyle.copyWith(fontSize: kTextMiddleSize),
                ),
              ),
              Expanded(
                flex: widget.align.isVertical ? 0 : 1,
                child: widget.children![controller.index],
              ),
            ],
          ),
        )
      ],
    ];
    return ColumnRow(
      isColumn: widget.align.isVertical,
      children: widget.align.isReversed ? children.reversed.toList() : children,
    );
  }
}

class TabMenuController extends BasicMenuController {
  final VoidCallback? callback;

  TabMenuController(super.menuList, {this.callback});

  @override
  void onMenuItemTap(int index) {
    this.index = index;
    if (callback != null) callback!();
    notifyListeners();
  }
}
