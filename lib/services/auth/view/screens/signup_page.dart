import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/consts/ui_const.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/auth/view/screens/login_page.dart';
import 'package:twichat/widgets/loading.dart';
import 'package:twichat/widgets/rounded_button.dart';

import '../widgets/auth_feild.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final AppBar _appBar = UIConsts.appbar();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  void signUp() {
    ref.read(authControllerProvider.notifier).signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: _appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      AuthTextField(
                          controller: nameController,
                          hinttext: "Enter your name"),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthTextField(
                          controller: emailController,
                          hinttext: "Enter your email"),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthTextField(
                          controller: passwordController,
                          hinttext: "Enter your password"),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: RoundedButton(
                            lable: "Sign Up",
                            ontap: signUp,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Already have a account? ",
                              style: const TextStyle(fontSize: 15),
                              children: [
                            TextSpan(
                              text: "Login",
                              style: const TextStyle(
                                  color: AppColors.logocolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context, LoginPage.route());
                                },
                            ),
                          ]))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
