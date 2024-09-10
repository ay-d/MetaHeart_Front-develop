import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

class LoginWebContainer extends StatefulWidget {
  final Widget loginView;
  final Widget signupView;
  final Widget Function(VoidCallback? onPressed) loginButtonBuilder;
  final Widget Function(VoidCallback? onPressed) signupButtonBuilder;
  final VoidCallback? onLoginPressed;
  final bool Function()? onSignupPressed;

  const LoginWebContainer({
    Key? key,
    required this.loginView,
    required this.signupView,
    required this.loginButtonBuilder,
    required this.signupButtonBuilder,
    this.onLoginPressed,
    this.onSignupPressed,
  }) : super(key: key);

  @override
  State<LoginWebContainer> createState() => _LoginWebContainerState();
}

class _LoginWebContainerState extends State<LoginWebContainer>
    with TickerProviderStateMixin {
  late final AnimationController boxAnimationController;
  late final AnimationController viewAnimationController;

  late final Animation<double> inputBoxAnimation;
  late final Animation<double> explainBoxAnimation;
  late final Animation<double> viewAnimation;

  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    boxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        if (boxAnimationController.isCompleted) isLogin = false;
        if (boxAnimationController.isDismissed) isLogin = true;
      });
    viewAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    inputBoxAnimation =
        Tween(begin: 0.05, end: 0.4).animate(boxAnimationController);
    explainBoxAnimation =
        Tween(begin: 0.625, end: 0.025).animate(boxAnimationController);
    viewAnimation =
        Tween<double>(begin: 0, end: 1).animate(viewAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) => AnimatedBuilder(
        animation: boxAnimationController,
        builder: (_, __) => SizedBox(
          width: constraint.maxWidth,
          height: constraint.maxHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Card(
                color: Colors.white.withOpacity(0.5),
                elevation: 5,
                child: SizedBox(
                  width: constraint.maxWidth,
                  height: constraint.maxHeight * 0.8,
                ),
              ),
              Positioned(
                left: constraint.maxWidth * explainBoxAnimation.value,
                child: SizedBox(
                  width: constraint.maxWidth * 0.35,
                  height: constraint.maxHeight * 0.8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Title(),
                        const _ExplainBox(),
                        navigationButton,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraint.maxWidth * inputBoxAnimation.value,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(kBorderRadiusSize),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kBorderRadiusSize),
                      border: Border.all(
                        width: 2,
                        color: kMainColor2.withOpacity(0.5),
                      ),
                    ),
                    child: SizedBox(
                      width: constraint.maxWidth * 0.55,
                      height: constraint.maxHeight * 0.9,
                      child: AnimatedBuilder(
                        animation: viewAnimationController,
                        builder: (_, __) => ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: constraint.maxHeight *
                                      0.9 *
                                      viewAnimation.value,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(kPaddingLargeSize),
                                  child: Column(children: [view, button]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get view => !isLogin ? widget.signupView : widget.loginView;

  Widget get button => !isLogin
      ? widget.signupButtonBuilder(() {
          if (widget.onSignupPressed?.call() ?? false) {
            viewAnimationController.forward().then((_) => boxAnimationController
                .reverse()
                .then((value) => viewAnimationController.reverse()));
          }
        })
      : widget.loginButtonBuilder(widget.onLoginPressed);

  Widget get navigationButton => OutlinedButton(
        onPressed: () {
          viewAnimationController.forward().then((value) {
            if (!isLogin) {
              boxAnimationController
                  .reverse()
                  .then((value) => viewAnimationController.reverse());
            } else {
              boxAnimationController
                  .forward()
                  .then((value) => viewAnimationController.reverse());
            }
          });
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(kPaddingLargeSize),
          side: const BorderSide(color: Colors.white),
        ),
        child: Text(
          !isLogin ? "Log In" : "Sign Up",
          style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
        ),
      );
}

class _Title extends StatelessWidget {
  _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: const AssetImage("assets/image/logo.png"),
          width: ResponsiveSize.S(100),
          height: ResponsiveSize.S(100),
          fit: BoxFit.fitWidth,
        ),
        Expanded(
          child: Text(
            'CardioSim Login\n- 인실리코 심장 독성평가 SW -',
            textAlign: TextAlign.center,
            style: kTextReverseStyle.copyWith(fontSize: kTextMiddleSize),
          ),
        ),
      ],
    );
  }
}

class _ExplainBox extends StatelessWidget {
  const _ExplainBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 200);
  }
}
