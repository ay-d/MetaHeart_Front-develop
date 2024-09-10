import 'package:cardio_sim/auth/components/login_web_container.dart';
import 'package:cardio_sim/auth/viewmodel/login_viewmodel.dart';
import 'package:cardio_sim/auth/viewmodel/signup_viewmodel.dart';
import 'package:cardio_sim/common/component/custom_elevated_button.dart';
import 'package:cardio_sim/common/component/custom_text_form_field.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/common/utils/validation_util.dart';
import 'package:cardio_sim/common/value_state/component/value_state_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends ConsumerWidget {
  static String get routeName => "login";

  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.read(loginViewModelProvider);
    final signupViewModel = ref.read(signupViewModelProvider);

    return DefaultContainer(
      backgroundImage: Image.asset(
        "assets/image/background.png",
        fit: BoxFit.fill,
      ),
      body: ResponsiveContainer(
        children: [
          ResponsiveWidget(wFlex: 2, child: Container()),
          ResponsiveWidget(
            wFlex: 8,
            mFlex: 1,
            child: Center(
              child: LoginWebContainer(
                loginView: _LoginInput(),
                signupView: _SignupInput(),
                loginButtonBuilder: (onPressed) => ValueStateListener(
                  state: loginViewModel.authState,
                  defaultBuilder: (_, __) => _DesignedElevatedButton(
                    onPressed: onPressed,
                    child: Text(
                      "로그인",
                      style: kTextReverseStyle.copyWith(
                        fontSize: kTextMiddleSize,
                      ),
                    ),
                  ),
                ),
                onLoginPressed: loginViewModel.login,
                signupButtonBuilder: (onPressed) => ValueStateListener(
                  state: loginViewModel.authState,
                  defaultBuilder: (_, __) => _DesignedElevatedButton(
                    onPressed: onPressed,
                    child: Text(
                      "회원가입",
                      style: kTextReverseStyle.copyWith(
                        fontSize: kTextMiddleSize,
                      ),
                    ),
                  ),
                ),
                onSignupPressed: signupViewModel.signup,
              ),
            ),
          ),
          ResponsiveWidget(wFlex: 2, child: Container()),
        ],
      ),
    );
  }
}

class _LoginInput extends ConsumerWidget {
  _LoginInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider);
    return Padding(
      padding: EdgeInsets.all(kPaddingLargeSize * 2),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Log In",
            style: GoogleFonts.abrilFatface(
              textStyle: kTextMainStyle.copyWith(
                fontSize: kTextTitleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: kPaddingLargeSize * 3),
          Form(
            key: viewModel.loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DesignedTextFormField(
                  labelText: "이메일",
                  hintText: '이메일을 입력해주세요',
                  textController: viewModel.emailTextController,
                  validator: validateId,
                ),
                SizedBox(height: kPaddingLargeSize),
                _DesignedTextFormField(
                  labelText: "비밀번호",
                  hintText: '비밀번호를 입력해주세요',
                  keyboardType: TextInputType.visiblePassword,
                  textController: viewModel.passwordTextController,
                  validator: validatePassword,
                ),
              ],
            ),
          ),
          SizedBox(height: kPaddingLargeSize * 3),
        ],
      ),
    );
  }
}

class _SignupInput extends ConsumerWidget {
  _SignupInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(signupViewModelProvider);
    return Padding(
      padding: EdgeInsets.all(kPaddingLargeSize * 2),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign Up",
            style: GoogleFonts.abrilFatface(
              textStyle: kTextMainStyle.copyWith(
                fontSize: kTextTitleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: kPaddingLargeSize * 3),
          Form(
            key: viewModel.signupKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DesignedTextFormField(
                  labelText: "이메일",
                  hintText: '이메일을 입력해주세요',
                  textController: viewModel.emailTextController,
                  validator: validateId,
                ),
                SizedBox(height: kPaddingLargeSize),
                _DesignedTextFormField(
                  labelText: "비밀번호",
                  hintText: '비밀번호를 입력해주세요',
                  keyboardType: TextInputType.visiblePassword,
                  textController: viewModel.passwordTextController,
                  validator: validatePassword,
                ),
                SizedBox(height: kPaddingLargeSize),
                _DesignedTextFormField(
                  labelText: "비밀번호 확인",
                  hintText: '비밀번호를 다시 입력해 주세요',
                  keyboardType: TextInputType.visiblePassword,
                  textController: viewModel.checkPasswordTextController,
                  validator: validatePassword,
                ),
                SizedBox(height: kPaddingLargeSize),
                _DesignedTextFormField(
                  labelText: "이름",
                  hintText: '이름을 입력해 주세요',
                  keyboardType: TextInputType.text,
                  textController: viewModel.nameTextController,
                  validator: validateMessage,
                ),
                SizedBox(height: kPaddingLargeSize),
                _DesignedTextFormField(
                  labelText: "소속",
                  hintText: '소속을 입력해 주세요',
                  keyboardType: TextInputType.text,
                  textController: viewModel.affiliationTextController,
                  validator: validateMessage,
                ),
                SizedBox(height: kPaddingLargeSize),
                _DesignedTextFormField(
                  labelText: "직무",
                  hintText: '직무를 입력해 주세요',
                  keyboardType: TextInputType.text,
                  textController: viewModel.positionTextController,
                  validator: validateMessage,
                ),
              ],
            ),
          ),
          SizedBox(height: kPaddingLargeSize * 3),
        ],
      ),
    );
  }
}

class _DesignedElevatedButton extends CustomElevatedButton {
  _DesignedElevatedButton({required super.child, required super.onPressed})
      : super(
          padding: EdgeInsets.symmetric(
            horizontal: kPaddingLargeSize,
            vertical: kPaddingSmallSize,
          ),
        );
}

class _DesignedTextFormField extends CustomTextFormField {
  _DesignedTextFormField({
    Key? key,
    super.labelText,
    super.hintText,
    super.keyboardType,
    super.textController,
    super.validator,
  }) : super(
          key: key,
          decorationStyle: kTextMainStyle.copyWith(
            fontSize: kTextSmallSize,
            color: kTextMainColor.withOpacity(0.5),
          ),
          backgroundColor: Colors.transparent,
        );
}
