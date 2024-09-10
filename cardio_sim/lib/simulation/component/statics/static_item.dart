import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';
import 'package:flutter/material.dart';

class StaticItem extends StatelessWidget {
  final StaticData data;

  const StaticItem(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                data.type.toString(),
                style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
              ),
              SizedBox(width: kPaddingMiniSize),
              Text(
                data.title,
                style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
              ),
            ],
          ),
        ),
        SizedBox(width: kPaddingMiniSize),
        Expanded(
          child: Text(
            data.value.toString(),
            style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
          ),
        ),
      ],
    );
  }
}
