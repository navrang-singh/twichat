import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/models/user_model.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/feeds/widgets/feed_card.dart';
import 'package:twichat/services/userprofile/controller/user_profile_controller.dart';
import 'package:twichat/services/userprofile/view/edit_profile_screen.dart';
import 'package:twichat/widgets/error_page.dart';
import 'package:twichat/widgets/loading.dart';
import 'package:twichat/widgets/rounded_button.dart';

class UserProfileWidget extends ConsumerWidget {
  final UserModel usermodel;
  const UserProfileWidget({super.key, required this.usermodel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void follow({required UserModel user, required UserModel currUser}) {
      final res = ref.watch(userProfileControllerProvider.notifier);
      res.followUser(
          userModel: user, context: context, userModelfollower: currUser);
      // showSnackBar(context, "To be implemented !");
    }

    final currUser = ref.watch(currentUserDetailsProvider).value;
    return currUser == null
        ? const LoadingPage()
        : NestedScrollView(
            headerSliverBuilder: (context, isScralling) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: usermodel.bannerPhoto.isEmpty
                            ? Container(
                                color: AppColors.searchBarColor,
                              )
                            : Image.network(usermodel.bannerPhoto,
                                fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 80,
                        left: 150,
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: AppColors.searchBarColor,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(usermodel.profilePhoto),
                            radius: 50,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 35,
                        left: 10,
                        child: Container(
                          color: AppColors.searchBarColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              usermodel.name,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 9,
                          left: 10,
                          child: Container(
                            color: AppColors.searchBarColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    'following : ${usermodel.following.length}',
                                    style: const TextStyle(
                                        color: AppColors.greyColor),
                                  ),
                                  Text(
                                    '  follower : ${usermodel.follower.length}',
                                    style: const TextStyle(
                                        color: AppColors.greyColor),
                                  )
                                ],
                              ),
                            ),
                          )),
                      // if (currUser != null && currUser.uid == usermodel.uid)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: currUser.uid == usermodel.uid
                            ? RoundedButton(
                                lable: 'Edit Profile',
                                ontap: () {
                                  Navigator.push(
                                      context, EditProfileScreen.route());
                                },
                              )
                            : currUser.following.contains(usermodel.uid)
                                ? RoundedButton(
                                    lable: 'Unfollow',
                                    ontap: () {
                                      follow(
                                          user: usermodel, currUser: currUser);
                                    },
                                  )
                                : RoundedButton(
                                    lable: 'Follow',
                                    ontap: () {
                                      follow(
                                          user: usermodel, currUser: currUser);
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: ref.watch(getUserPostProvider(usermodel.uid)).when(
              data: (posts) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = posts[index];
                    return FeedCard(postModel: post);
                  },
                );
              },
              error: (e, st) {
                return const ErrorPage(error: "Something error occured :(");
              },
              loading: () {
                return const Loader();
              },
            ),
          );
  }
}
