// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twichat/consts/theme/app_color.dart';

class PostIconsWidget extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback ontap;
  const PostIconsWidget(
      {super.key,
      required this.iconPath,
      required this.text,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            color: AppColors.greyColor,
          ),
          Text(
            ' $text',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
