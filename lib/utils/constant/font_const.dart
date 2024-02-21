import 'package:flutter/material.dart';

import 'color_const.dart';

class FONT_CONST {

  static final TextStyle BESTIE = TextStyle(
    fontFamily: 'bestie',
    color: COLOR_CONST.BLACK,
  );
  static final TextStyle BRODIES = TextStyle(
    fontFamily: 'brodies',
    color: COLOR_CONST.BLACK,
  );
  static final TextStyle FUTURISTIC_STYLISH = TextStyle(
    fontFamily: 'futuristic_stylish',
    color: COLOR_CONST.BLACK,
  );
  static final TextStyle NEXT_SUNDAY = TextStyle(
    fontFamily: 'next_sunday',
    color: COLOR_CONST.BLACK,
  );
  static final TextStyle SATURDAY = TextStyle(
    fontFamily: 'saturday',
    color: COLOR_CONST.BLACK,
  );

  static final FONT_APP = TextStyle(
      fontFamily: 'bestie',
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: COLOR_CONST.BLUE_DARK,
      shadows: const [
        // Shadow(
        //   offset: Offset(2.0, 2.0), // Độ lệch theo trục x và y
        //   color: Colors.black45,     // Màu bóng đổ
        //   blurRadius: 3.0,         // Bán kính mờ (độ mờ của bóng đổ)
        // ),
      ],);

  static final TextStyle TITLE_BLOG = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: COLOR_CONST.BLACK,
  );

  static final TextStyle CONTENT_BLOG = TextStyle(
    color: COLOR_CONST.BLACK,
    fontSize: 13
  );

  static final TextStyle SESSION = SATURDAY.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold
  );
}