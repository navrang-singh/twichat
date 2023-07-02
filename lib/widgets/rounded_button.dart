

import 'package:flutter/material.dart';
import 'package:twichat/consts/theme/app_color.dart';

class RoundedButton extends StatelessWidget {
  final String lable;
  final Function() ontap;
  final Color textColor;
  final Color backgroundColor;
  const RoundedButton({super.key,
   required this.lable, 
   required this.ontap, 
   this.textColor = AppColors.whiteColor, 
   this.backgroundColor = AppColors.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Chip(
        label: Text(
          lable,
          style: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize:18),
        ),
        labelPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      ),
    );
  }
}