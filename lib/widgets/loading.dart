import 'package:flutter/material.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/consts/ui_const.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConsts.appbar(),
      body: const Loader(),
    );
  }
}
