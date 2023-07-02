import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/appwrite_const.dart';

import 'package:twichat/models/user_model.dart';
import 'package:twichat/services/userprofile/controller/user_profile_controller.dart';
import 'package:twichat/services/userprofile/widgets/user_profile.dart';
import 'package:twichat/widgets/error_page.dart';

class UserProfileScreen extends ConsumerWidget {
  final UserModel user;
  static route(UserModel user) => MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          user: user,
        ),
      );
  const UserProfileScreen({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyuser = user;
    return Scaffold(
      body: ref.watch(userupdatesProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteConsts.userCollectionID}.documents',
              )) {
                final res = UserModel.fromMap(data.payload);
                if (res.uid == copyuser.uid) {
                  copyuser = UserModel.fromMap(data.payload);
                }
              }

              return UserProfileWidget(usermodel: copyuser);
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () {
              return UserProfileWidget(usermodel: copyuser);
            },
          ),
    );
  }
}
