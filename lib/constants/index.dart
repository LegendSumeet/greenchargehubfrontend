import 'package:flutter/material.dart';



Widget BuildText(
  String title,
  double width,
  double fontSize,
  Color textColor,
) {
  return Text(
    title,
    textAlign: TextAlign.start,
    style: TextStyle(
      color: textColor,
      fontFamily: "Mulish",
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
    ),
  );
}

const Color kBlackRich12 = Color(0xff121421);
const Color kBlackRichLight1C = Color(0xff1C2031);
const Color kBlueAzure4A = Color.fromRGBO(74, 128, 240, 1);
const Color kWhiteFF = Color(0xffFFFFFF);
const Color kUltraViolet51 = Color(0xff515979);
const Color kWhite = Color(0xffffffff);
const Color kWhiteF7 = Color(0xfff7f7f7);
const Color kWhiteFA = Color(0xffFAFAFA);
const Color kWhiteEF = Color(0xffEFEFEF);

const Color kBlack = Color(0xff000000);
const Color kBlack0D = Color(0xff0d0d0d);

const Color kGrey = Color(0xffD7D7D7);
const Color kGreyB7 = Color(0xffB7B7B7);
const Color kGrey8E = Color(0xff8E8E8E);
const Color kGrey83 = Color(0xff838383);
const Color kGrey85 = Color(0xff858585);

const Color kBlue = Color(0xff0A8ED9);
const Color kLightBlue = Color(0xffA0DAFB);

const double kBorderRadius10 = 10.0;
const double kBorderRadius12 = 12.0;
const double kBorderRadius16 = 16.0;
const double kBorderRadius24 = 24.0;
const double kBorderRadius26 = 26.0;

const double kPadding4 = 4.0;
const double kPadding6 = 6.0;
const double kPadding8 = 8.0;
const double kPadding12 = 12.0;
const double kPadding14 = 14.0;
const double kPadding16 = 16.0;
const double kPadding18 = 18.0;
const double kPadding20 = 20.0;
const double kPadding22 = 22.0;
const double kPadding24 = 24.0;
const double kPadding28 = 28.0;
const double kPadding32 = 32.0;

Gradient kLinearGradientDarkBlue = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: <Color>[
    Colors.blue.shade800.withOpacity(0.8),
    Colors.blue.shade400.withOpacity(0),
  ],
  tileMode: TileMode.clamp,
);

const Gradient kLinearGradientBlue = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    kLightBlue,
    kBlue,
  ],
  tileMode: TileMode.clamp,
);

Gradient kLinearGradientWhite = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    kWhite.withOpacity(0),
    kWhite,
  ],
  tileMode: TileMode.clamp,
);


const double kBorderRadius20 = 20.0;
const double kBorderRadius5 = 5.0;



final kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(kBorderRadius10),
  borderSide: const BorderSide(
    color: kWhite,
  ),
);



