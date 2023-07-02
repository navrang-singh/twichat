import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/userprofile/controller/user_profile_controller.dart';
import 'package:twichat/utils.dart';
import 'package:twichat/widgets/loading.dart';
import 'package:twichat/widgets/rounded_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      );
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  File? profilePic;
  File? bannerPhoto;

  void pickprofilePic() async {
    final image = await pickimage();
    setState(() {
      profilePic = image;
    });
  }

  void pickbannerPhoto() async {
    final image = await pickimage();
    setState(() {
      bannerPhoto = image;
    });
  }

  void update(
    String uid,
  ) {
    final res = ref.watch(userProfileControllerProvider.notifier);
    res.updateUserData(
        uid: uid,
        name: nameController.text,
        bio: bioController.text,
        profilePic: profilePic,
        bannerphoto: bannerPhoto);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: user == null
            ? const Loader()
            : SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 250,
                      width: double.maxFinite,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: pickbannerPhoto,
                            child: SizedBox(
                              width: double.maxFinite,
                              child: bannerPhoto == null
                                  ? Container(
                                      color: AppColors.searchBarColor,
                                    )
                                  : Image.file(bannerPhoto!, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 20,
                            child: InkWell(
                              child: CircleAvatar(
                                radius: 53,
                                backgroundColor: AppColors.searchBarColor,
                                child: profilePic == null
                                    ? CircleAvatar(
                                        radius: 48,
                                        backgroundImage:
                                            NetworkImage(user.profilePhoto),
                                      )
                                    : CircleAvatar(
                                        radius: 48,
                                        backgroundImage: Image.file(
                                          profilePic!,
                                          width: double.maxFinite,
                                          height: double.maxFinite,
                                          fit: BoxFit.cover,
                                        ).image,
                                      ),
                              ),
                              onTap: () {
                                pickprofilePic();
                              },
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 10,
                              child: RoundedButton(
                                lable: 'update',
                                ontap: () {
                                  update(user.uid);
                                  Navigator.pop(context);
                                },
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.searchBarColor,
                              alignLabelWithHint: true,
                              hintText: "Name ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: AppColors.searchBarColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLines: null,
                            controller: bioController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.searchBarColor,
                              alignLabelWithHint: true,
                              hintText: "Bio",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: AppColors.searchBarColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }
}
