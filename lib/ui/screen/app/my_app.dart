import 'package:blog_app/utils/constain/color_const.dart';
import 'package:flutter/material.dart';
import '../splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NearBLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: COLOR_CONST.BLUE_DARK),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}