import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

class HomeMenuButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;

  const HomeMenuButton({Key? key, required this.title, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(kBorderRadiusSize),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                kMainColor2.withOpacity(0.5),
                kMainColor.withOpacity(0.5),
              ],
              stops: const [0, 1],
              center: const Alignment(-2, 2),
              radius: 5,
            ),
            borderRadius: BorderRadius.circular(kBorderRadiusSize),
            boxShadow: [
              BoxShadow(
                offset: const Offset(kWPaddingMiniSize, kWPaddingMiniSize),
                blurRadius: kWPaddingMiniSize,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          constraints: BoxConstraints(
            minHeight: ResponsiveSize.S(ResponsiveData.kIsMobile ? 100 : 150),
          ),
          padding: EdgeInsets.all(kPaddingLargeSize),
          child: Text(
            title,
            style: kTextReverseStyle.copyWith(
              fontSize: kTextLargeSize,
            ),
          ),
        ),
      ),
    );
  }
}
