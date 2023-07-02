import 'package:flutter/material.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/models/user_model.dart';
import 'package:twichat/services/userprofile/view/user_profile_screen.dart';

class SearchTile extends StatelessWidget {
  final UserModel user;
  const SearchTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.searchBarColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: ListTile(
          onTap: () {
            Navigator.push(context, UserProfileScreen.route(user));
          },
          tileColor: AppColors.searchBarColor,
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.profilePhoto),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontSize: 20),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' Followers : ${user.follower.length}'),
              Text(' Following : ${user.following.length}'),
            ],
          ),
          minVerticalPadding: 5,
          minLeadingWidth: 5,
        ),
      ),
    );
  }
}
