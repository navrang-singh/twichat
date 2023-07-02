// ignore_for_file: unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/apis/notification_api.dart';
import 'package:twichat/apis/post_api.dart';
import 'package:twichat/apis/storage_api.dart';
import 'package:twichat/apis/user_api.dart';
import 'package:twichat/models/post_model.dart';
import 'package:twichat/models/user_model.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/widgets/snackbar.dart';

abstract class IUserProfileController {
  Future<List<PostModel>> getUserPost(String uid);
  // void updateUserData(UserModel user,String uid);
}

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    ref: ref,
    postapi: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPi: ref.watch(userAPIProvider),
    notificationapi: ref.watch(notificationAPIProvider),
  );
});

final getUserPostProvider = FutureProvider.family((ref, String uid) async {
  final res = ref.watch(userProfileControllerProvider.notifier);
  return res.getUserPost(uid);
});

final userupdatesProvider = StreamProvider((ref) {
  final userapi = ref.watch(userAPIProvider);
  return userapi.getUserUpdates();
});

class UserProfileController extends StateNotifier<bool>
    implements IUserProfileController {
  final Ref _ref;
  final PostAPI _postapi;
  final UserAPI _userapi;
  final StorageAPI _storageapi;
  final NotificationAPI _notificationapi;
  UserProfileController(
      {required Ref ref,
      required PostAPI postapi,
      required StorageAPI storageAPI,
      required NotificationAPI notificationapi,
      required UserAPI userAPi})
      : _ref = ref,
        _postapi = postapi,
        _storageapi = storageAPI,
        _userapi = userAPi,
        _notificationapi = notificationapi,
        super(false);

  @override
  Future<List<PostModel>> getUserPost(String uid) async {
    final postlist = await _postapi.getUserPosts(uid);
    return postlist.map((post) => PostModel.fromMap(post.data)).toList();
  }

  // @override
  void updateUserData(
      {required String uid,
      String? name,
      String? bio,
      File? profilePic,
      File? bannerphoto}) async {
    String profile = '';
    String banner = '';
    final curr = _ref.watch(currentUserDetailsProvider).value;
    if (profilePic != null) {
      profile = await _storageapi.uploadImage(profilePic);
    }
    if (bannerphoto != null) {
      banner = await _storageapi.uploadImage(bannerphoto);
    }

    UserModel user = curr!.copyWith(
      name: name ?? curr.name,
      bio: bio ?? curr.bio,
      profilePhoto: profile == '' ? curr.profilePhoto : profile,
      bannerPhoto: profile == '' ? curr.bannerPhoto : banner,
    );

    await _userapi.updateUserData(user, user.uid);
  }

  void followUser({
    required UserModel userModel,
    required BuildContext context,
    required UserModel userModelfollower,
  }) async {
    List<String> following = [];
    List<String> followers = [];
    following = userModelfollower.following;
    followers = userModel.follower;
    if (following.contains(userModel.uid)) {
      following.remove(userModel.uid);
    } else {
      following.add(userModel.uid);
    }

    if (followers.contains(userModelfollower.uid)) {
      followers.remove(userModelfollower.uid);
    } else {
      followers.add(userModelfollower.uid);
    }

    UserModel p = userModel.copyWith(follower: followers);
    UserModel q = userModelfollower.copyWith(following: following);
    final res = await _userapi.updateUserData(p, p.uid);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "you followed ${p.name} !");
    });
    final res3 = await _userapi.updateUserData(q, q.uid);
    res3.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "${q.name} followers increased !");
    });
  }
}
