import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/apis/auth_api.dart';
import 'package:twichat/apis/user_api.dart';
import 'package:twichat/models/user_model.dart';
import 'package:twichat/services/auth/view/screens/login_page.dart';
import 'package:twichat/services/auth/view/screens/signup_page.dart';
import 'package:twichat/services/home/view/home_page.dart';
import 'package:twichat/widgets/snackbar.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authapi: ref.watch(authAPIProvider),
    userapi: ref.watch(userAPIProvider),
  );
});

final currAccountUserProvider = FutureProvider((ref) async {
  final res = ref.watch(authControllerProvider.notifier);
  return res.currAccountUser();
});

final currentUserDetailsProvider = FutureProvider((ref) async {
  final currUserId = ref.watch(currAccountUserProvider).value!.$id;
  final details = ref.watch(userDetailsProvider(currUserId));
  return details.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authapi;
  final UserAPI _userapi;
  AuthController({required AuthApi authapi, required UserAPI userapi})
      : _authapi = authapi,
        _userapi = userapi,
        super(false);

  Future<User?> currAccountUser() async {
    return await _authapi.currentUserAccount();
  }

  void signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result =
        await _authapi.signUp(email: email, name: name, password: password);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: name,
          follower: [],
          following: [],
          profilePhoto: '',
          bannerPhoto: '',
          bio: '',
          uid: r.$id,
          isVerified: false,
        );
        final res2 = await _userapi.saveUserData(userModel);

        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, " Account has been created ! Try Login!");
          Navigator.of(context).push(LoginPage.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authapi.login(email: email, password: password);

    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Login Successful ");

        Navigator.push(context, HomePage.route());
      },
    );
  }

  void logout(BuildContext context) async {
    final res = await _authapi.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpPage.route(),
        (route) => false,
      );
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final res = await _userapi.getUserData(uid);
    final userdocs = UserModel.fromMap(res.data);
    return userdocs;
  }
}
