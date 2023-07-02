import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/userprofile/view/user_profile_screen.dart';
import 'package:twichat/widgets/loading.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDetailsProvider).value;
    if (user == null) {
      return const Loader();
    }
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.backgroundColor,
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                "My Profile",
                style: TextStyle(fontSize: 30),
              ),
              onTap: () {
                Navigator.push(context, UserProfileScreen.route(user));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 30),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
            Text(' welocome ${user.name}'),
          ],
        ),
      ),
    );
  }
}
