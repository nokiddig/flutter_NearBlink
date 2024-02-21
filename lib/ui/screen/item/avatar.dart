
import 'package:blog_app/ui/screen/profile/profile_tab.dart';
import 'package:blog_app/utils/constant/my_const.dart';
import 'package:flutter/material.dart';

import '../../../model/account.dart';

Widget createBloggerAvatar(Account account, BuildContext context){
  return CircleAvatar(
      backgroundImage: NetworkImage(account.avatarPath == ""
          ? STRING_CONST.NETWORKIMAGE_DEFAULT
          : account.avatarPath,
      ),
    child: GestureDetector(
      onTap: (){
        Route route = MaterialPageRoute(builder: (context) => ProfileTab(email: account.email),);
        Navigator.push(context, route);
      },
    ),
  );
}