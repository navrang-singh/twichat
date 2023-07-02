import 'package:flutter/material.dart';
import 'package:twichat/consts/theme/app_color.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspan = [];

    text.split(' ').forEach((e) {
      if (e.startsWith('#')) {
        textspan.add(TextSpan(
            text: '$e ',
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.blueColor,
              fontWeight: FontWeight.bold,
            )));
      } else if (e.startsWith('www.') ||
          e.startsWith('https://') ||
          e.startsWith('http://')) {
        textspan.add(TextSpan(
            text: '$e ',
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.blueColor,
            )));
      } else {
        textspan
            .add(TextSpan(text: '$e ', style: const TextStyle(fontSize: 17)));
      }
    });
    return RichText(text: TextSpan(children: textspan));
  }
}
