import 'package:blog_app/services/firebase_authentication.dart';
import 'package:blog_app/services/save_account.dart';
import 'package:blog_app/ui/screen/profile/edit_profile.dart';
import 'package:blog_app/ui/screen/login/signin_screen.dart';
import 'package:blog_app/ui/screen/profile/profile_tab.dart';
import 'package:blog_app/ui/screen/blog/save_tab.dart';
import 'package:blog_app/utils/constant/my_const.dart';
import 'package:flutter/material.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UI_CONST.DIVIDER1,
        UI_CONST.DIVIDER1,
        ListTile(
          style: ListTileStyle.drawer,
          leading: UI_CONST.ICON_PROFILE,
          title: const Text(STRING_CONST.PROFILE),
          onTap: (){
            Route route = MaterialPageRoute(builder: (context) => ProfileTab(email: SaveAccount.currentEmail?? "email"),);
            Navigator.push(context, route);
          },
          trailing: const Icon(Icons.navigate_next),
        ),
        UI_CONST.DIVIDER1,
        ListTile(
          style: ListTileStyle.drawer,
          leading: const Icon(Icons.manage_accounts_outlined),
          title: const Text(STRING_CONST.EDIT_PROFILE),
          onTap: (){
            Route route = MaterialPageRoute(builder: (context) => const EditProfile());
            Navigator.push(context, route);
          },
          trailing: const Icon(Icons.navigate_next),
        ),
        UI_CONST.DIVIDER1,
        ListTile(
          leading: UI_CONST.ICON_SAVE,
          title: const Text(STRING_CONST.SAVED),
          onTap: (){
            Route route = MaterialPageRoute(builder: (context) => const SaveTab(),);
            Navigator.push(context, route);
          },
          trailing: const Icon(Icons.navigate_next),
        ),
        UI_CONST.DIVIDER1,
        ListTile(
          leading: UI_CONST.ICON_ACTIVITIES,
          title: const Text(STRING_CONST.ACTIVITIES),
          onTap: (){
            throw UnimplementedError();
          },
          trailing: const Icon(Icons.navigate_next),
        ),
        UI_CONST.DIVIDER1,
        ListTile(
          leading: UI_CONST.ICON_LOGOUT,
          title: const Text(STRING_CONST.LOGOUT),
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen(),), (route) => true,);
            signOut();
          },
        ),
        UI_CONST.DIVIDER1,
      ],
    );
  }
}
