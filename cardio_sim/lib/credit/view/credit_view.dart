import 'package:cardio_sim/common/component/credit_card/flutter_credit_card.dart';
import 'package:cardio_sim/common/component/custom_elevated_button.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/credit/viewmodel/credit_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditView extends ConsumerWidget {
  static String get routeName => 'credit';

  const CreditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultContainer(
      backgroundImage: Image.asset(
        "assets/image/background.png",
        fit: BoxFit.fill,
      ),
      body: ResponsiveContainer(
        mCrossAlignment: CrossAxisAlignment.stretch,
        wCrossAlignment: CrossAxisAlignment.center,
        children: [
          ResponsiveWidget(wFlex: 1, child: Container()),
          ResponsiveWidget(
            wFlex: 5,
            mFlex: 1,
            child: Padding(
              padding: EdgeInsets.all(kPaddingXLargeSize),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Join Us",
                    style: GoogleFonts.abrilFatface(
                      textStyle: kTextReverseStyle.copyWith(
                        fontSize: kTextTitleSize,
                      ),
                    ),
                  ),
                  SizedBox(height: kPaddingMiddleSize),
                  _CardView(),
                ],
              ),
            ),
          ),
          ResponsiveWidget(
            wFlex: 5,
            mFlex: 1,
            child: Padding(
              padding: EdgeInsets.all(kPaddingMiddleSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: ResponsiveData.kIsMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "What is CardioSim?",
                    style: GoogleFonts.abrilFatface(
                      textStyle: kTextReverseStyle.copyWith(
                        fontSize: kTextTitleSize,
                      ),
                    ),
                  ),
                  SizedBox(height: kPaddingXLargeSize),
                  Center(
                    child: Text(
                      "CardioSim is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      maxLines: 100,
                      style: GoogleFonts.notoSerif(
                        textStyle: kTextReverseStyle.copyWith(
                          fontSize: kTextMiddleSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ResponsiveWidget(wFlex: 1, child: Container()),
        ],
      ),
    );
  }
}

class _CardView extends ConsumerStatefulWidget {
  const _CardView({Key? key}) : super(key: key);

  @override
  ConsumerState<_CardView> createState() => _CardViewState();
}

class _CardViewState extends ConsumerState<_CardView> {
  late final CreditViewModel viewmodel;
  bool showBackView = false;

  @override
  void initState() {
    viewmodel = ref.read(creditViewModelProvider);
    super.initState();
  }

  TextStyle get cardTextStyle => GoogleFonts.notoSerif(
        textStyle: kTextReverseStyle.copyWith(
          fontSize: kTextSmallSize,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSize.S(500),
      child: Column(
        children: [
          CreditCardWidget(
            cardNumber: viewmodel.cardNumber,
            expiryDate: viewmodel.expiryDate,
            cardHolderName: viewmodel.cardHolderName,
            cvvCode: viewmodel.cvvCode,
            bankName: "CardioSim",
            showBackView: showBackView,
            onCreditCardWidgetChange: (CreditCardBrand brand) {},
            glassmorphismConfig: Glassmorphism.defaultConfig(),
            enableFloatingCard: true,
            isHolderNameVisible: true,
            cardType: CardType.visa,
            textStyle: cardTextStyle.copyWith(color: Colors.white),
            width: ResponsiveSize.S(400),
            height: ResponsiveSize.S(243),
            animationDuration: const Duration(milliseconds: 1000),
            padding: kPaddingLargeSize,
          ),
          CreditCardForm(
            formKey: viewmodel.creditCardFormKey,
            cardNumber: viewmodel.cardNumber,
            expiryDate: viewmodel.expiryDate,
            cardHolderName: viewmodel.cardHolderName,
            cvvCode: viewmodel.cvvCode,
            onCreditCardModelChange: (CreditCardModel data) {
              setState(() {
                showBackView = data.isCvvFocused;
                viewmodel.cardNumber = data.cardNumber;
                viewmodel.expiryDate = data.expiryDate;
                viewmodel.cardHolderName = data.cardHolderName;
                viewmodel.cvvCode = data.cvvCode;
              });
            },
            obscureNumber: true,
            cardNumberValidator: (String? cardNumber) {
              return null;
            },
            expiryDateValidator: (String? expiryDate) {
              return null;
            },
            cvvValidator: (String? cvv) {
              return null;
            },
            cardHolderValidator: (String? cardHolderName) {
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
            disableCardNumberAutoFillHints: false,
            inputConfiguration: InputConfiguration(
              cardNumberDecoration: _CardInputDecoration(
                labelText: 'Number',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: _CardInputDecoration(
                labelText: 'Expired Date',
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: _CardInputDecoration(
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: _CardInputDecoration(
                labelText: 'Card Holder',
                hintText: 'Card Holder',
              ),
              cardNumberTextStyle: cardTextStyle,
              cardHolderTextStyle: cardTextStyle,
              expiryDateTextStyle: cardTextStyle,
              cvvCodeTextStyle: cardTextStyle,
            ),
          ),
          SizedBox(height: kPaddingMiddleSize),
          CustomElevatedButton(
            onPressed: viewmodel.setPayment,
            padding: EdgeInsets.symmetric(
              vertical: kPaddingMiniSize,
              horizontal: kPaddingMiddleSize,
            ),
            child: Text(
              "Pay",
              style: GoogleFonts.notoSerif(
                textStyle: kTextReverseStyle.copyWith(
                  fontSize: kTextSmallSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardInputDecoration extends InputDecoration {
  _CardInputDecoration({
    super.labelText,
    super.hintText,
  }) : super(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusColor: Colors.grey,
          contentPadding: EdgeInsets.symmetric(
            vertical: kPaddingLargeSize,
            horizontal: kPaddingMiddleSize,
          ),
          isDense: true,
          labelStyle: GoogleFonts.notoSerif(
            textStyle: kTextReverseStyle.copyWith(
              fontSize: kTextSmallSize,
            ),
          ),
          hintStyle: GoogleFonts.notoSerif(
            textStyle: kTextReverseStyle.copyWith(
              fontSize: kTextSmallSize,
            ),
          ),
        );
}
