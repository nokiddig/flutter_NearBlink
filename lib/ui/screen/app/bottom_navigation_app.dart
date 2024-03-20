import '../../../utils/constant/my_const.dart';
import 'package:flutter/material.dart';

import '../../tab/category_tab.dart';
import '../../tab/home_tab.dart';
import '../../tab/menu_tab.dart';
import '../../tab/notification_tab.dart';
import '../custom_search.dart';

class BottomNavigationApp extends StatefulWidget {
  BottomNavigationApp({super.key});
  final GlobalKey<_BottomNavigationAppState> _stateKey = GlobalKey();

  @override
  State<BottomNavigationApp> createState() => _BottomNavigationAppState();
}

class _BottomNavigationAppState extends State<BottomNavigationApp> {
  int _selectedIndex = 0;
  int _selectedView = 0;
  final String _title = "NearBLink";
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    CategoryTab(),
    const NotificationTab(),
    const NotificationTab(),
    const MenuTab(),
  ];


  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  final GlobalKey<_BottomNavigationAppState> _stateKey = GlobalKey<_BottomNavigationAppState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(STRING_CONST.IMAGE_LOGO_REMOVEBG,
            fit: BoxFit.fill,
          ),
          title:  Text(_title, style: FONT_CONST.FONT_APP,),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearch(),
                    );
                  },
                  icon: Icon(Icons.search),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _widgetOptions[_selectedView]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: COLOR_CONST.BLUE_DARK.withOpacity(0.95),
          iconSize: 20,
          selectedFontSize: 10,
          currentIndex: _selectedIndex,
          items: [
            bottomNavItem("Home", Icons.home_outlined, Icons.home),
            bottomNavItem("Category", Icons.category_outlined, Icons.category),
            bottomNavItem("Notifications",
                Icons.notification_important_outlined, Icons.notifications),
            bottomNavItem("Message", Icons.message_outlined, Icons.message),
            bottomNavItem("Menu", Icons.menu, Icons.menu_open),
          ],
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
              _selectedView = value;
            });
          },
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavItem(
      String label, IconData icon, IconData iconActive) {
    return BottomNavigationBarItem(
        icon: Icon(icon),
        label: label,
        backgroundColor: COLOR_CONST.BLUE,
        activeIcon: Icon(iconActive));
  }

  void updateIndexView(int index) {
    setState(() {
      _selectedView = index;
    });
  }
}

