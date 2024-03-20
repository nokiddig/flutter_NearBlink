import '../../../services/save_account.dart';
import '../../../ui/screen/app/bottom_navigation_app.dart';
import '../../../ui/screen/login/signin_screen.dart';
import '../../../utils/constant/my_const.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin  {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }
  /*
    Setup 1 SaveAccount for get data from sharedPreferences
    before login screen init
  */
  @override
  void initState() {
    SaveAccount();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1));

    CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: _controller, curve: Curves.easeIn);

    _animation = Tween<double>(begin: 1, end: 200)
        .animate(curvedAnimation);

    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
              if (_animation.isCompleted) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (SaveAccount.currentEmail != null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavigationApp()),
                    );
                  }
                  else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  }

                });
              }
              return Image.asset(STRING_CONST.IMAGE_LOGO_REMOVEBG,
                height: _animation.value,
              );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
