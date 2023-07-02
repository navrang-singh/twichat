// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twichat/consts/asset_const.dart';

import 'package:twichat/consts/ui_const.dart';

import '../consts/theme/app_color.dart';

class ErrorWidget extends StatelessWidget {
  final String error;
  const ErrorWidget({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SvgPicture.asset(AssetsConsts.errorsvg,
                color: AppColors.logocolor),
          ),
          Text(
            error,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConsts.appbar(),
      body: ErrorWidget(error: error),
    );
  }
}
