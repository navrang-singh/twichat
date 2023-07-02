// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twichat/consts/asset_const.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/services/feeds/widgets/feed_list.dart';
import 'package:twichat/services/notification/view/notifications_view.dart';
import 'package:twichat/services/search/view/search_screen.dart';

class UIConsts {
  static const List<Widget> bottomTab = [
    PostList(),
    SearchScreen(),
    NotificationScreen(),
  ];
  static AppBar appbar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConsts.twitterLogo,
        color: AppColors.logocolor,
        height: 25,
      ),
      centerTitle: true,
    );
  }
}
