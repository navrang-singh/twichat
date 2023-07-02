
import 'package:flutter/material.dart';
import 'package:twichat/consts/theme/app_color.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  const AuthTextField({super.key, required this.controller, required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hinttext,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(
            color: AppColors.logocolor,
            width: 3,
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 78, 77, 62),
            width: 3,
          )
        ),
      ),
    );
  }
}