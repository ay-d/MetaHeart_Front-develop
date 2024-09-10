import 'package:flutter/material.dart';

class CustomAnimationList<T> extends StatelessWidget {
  final AnimationListController<T> controller;

  const CustomAnimationList({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      key: controller.listKey,
      initialItemCount: controller.length,
      itemBuilder: (context, i, animation) => SlideTransition(
        position: controller.position(animation, false),
        child: controller.itemBuilder(controller.list[i]),
      ),
    );
  }
}

class AnimationListController<T> {
  final GlobalKey<AnimatedListState> listKey;
  final List<T> _list = [];
  final Widget Function(T) itemBuilder;
  final Duration allMethodDuration;

  AnimationListController({
    List<T>? initList,
    required this.listKey,
    required this.itemBuilder,
    required this.allMethodDuration,
  }) {
    _list.addAll(initList ?? []);
  }

  AnimatedListState? get _animatedList => listKey.currentState;

  bool _isReversed = false;

  Animation<Offset> Function(Animation<double> animation, bool reverse)
      get position => (animation, reverse) => animation.drive(
            Tween(
              begin: Offset(
                _isReversed ^ reverse ? -0.3 : 0.3,
                _isReversed ^ reverse ? -0.1 : 0.1,
                //0.0,
              ),
              end: const Offset(0, 0),
            ),
          );

  void insert(T value, {int? index, bool reverse = false}) {
    index ??= length;
    _isReversed = reverse;
    _list.insert(index, value);
    _animatedList?.insertItem(index);
  }

  void insertAll(List<T> values, {int? index, bool reverse = false}) async {
    index ??= length;
    for (int i = 0; i < values.length; i++) {
      insert(values[i], index: index + i, reverse: reverse);
      await Future.delayed(allMethodDuration);
    }
  }

  void remove({int? index, bool reverse = false}) {
    index ??= length - 1;

    if (index < 0 || index > length - 1) return;
    _isReversed = reverse;

    T value = _list[index];
    _list.remove(value);

    _animatedList?.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: position(animation, true),
        child: itemBuilder(value),
      ),
    );
  }

  void removeAll({bool reverse = false}) async {
    while (length > 0) {
      remove(index: length - 1, reverse: reverse);
      await Future.delayed(allMethodDuration);
    }
  }

  List<T> get list => _list;

  int get length => _list.length;
}
