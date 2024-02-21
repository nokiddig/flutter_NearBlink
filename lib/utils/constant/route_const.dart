import 'package:blog_app/ui/screen/login/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ui/screen/app/bottom_navigation_app.dart';
import '../../ui/tab/home_tab.dart';

class ROUTE_CONST{
  static final Route ROUTE_HOME = MaterialPageRoute(builder: (context) => HomeTab(),);
  static final Route ROUTE_CATEGORY = MaterialPageRoute(builder: (context) => HomeTab(),);
  static final Route ROUTE_NOTIFICATION = MaterialPageRoute(builder: (context) => HomeTab(),);
  static final Route ROUTE_SIGNIN = MaterialPageRoute(builder: (context) => SignInScreen(),);
  static final Route ROUTE_BOTTOMNAV = MaterialPageRoute(builder: (context) => BottomNavigationApp(),);
}