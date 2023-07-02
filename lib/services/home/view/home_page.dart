// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twichat/consts/asset_const.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/consts/ui_const.dart';
import 'package:twichat/services/feeds/views/create_feed.dart';
import 'package:twichat/services/home/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appbar = UIConsts.appbar();
    return Scaffold(
      appBar: _page == 0 ? appbar : null,
      drawer: const CustomDrawer(),
      body: IndexedStack(
        index: _page,
        children: UIConsts.bottomTab,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConsts.homeFilledIcon
                  : AssetsConsts.homeOutlinedIcon,
              color: AppColors.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConsts.searchIcon,
              color: AppColors.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConsts.notifFilledIcon
                  : AssetsConsts.notifOutlinedIcon,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        child: const Icon(
          Icons.message,
          color: AppColors.backgroundColor,
        ),
        onPressed: () {
          Navigator.push(context, CreateFeedPage.route());
        },
      ),
    );
  }
}
