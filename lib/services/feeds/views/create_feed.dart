// ignore_for_file: deprecated_member_use, unused_import

import 'dart:io' as dartio;
import 'package:appwrite/models.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twichat/consts/asset_const.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/feeds/controller/feed_controller.dart';
import 'package:twichat/utils.dart';
import 'package:twichat/widgets/loading.dart';
import 'package:twichat/widgets/rounded_button.dart';

class CreateFeedPage extends ConsumerStatefulWidget {
  const CreateFeedPage({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const CreateFeedPage(),
      );
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateFeedState();
}

class _CreateFeedState extends ConsumerState<CreateFeedPage> {
  final textFeildcontroller = TextEditingController();

  List<dartio.File> images = [];

  void sharepost() async {
    ref.read(postControllerProvider.notifier).sharePost(
          images: images,
          text: textFeildcontroller.text,
          context: context,
        );
  }

  @override
  void dispose() {
    super.dispose();
    textFeildcontroller.dispose();
  }

  void pickImages() async {
    images = await pickAllImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currAccountUserProvider).value;
    final url = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 32,
          ),
        ),
        actions: [
          RoundedButton(
            ontap: () {
              sharepost();
              Navigator.pop(context);
            },
            lable: "Post",
            textColor: AppColors.whiteColor,
            backgroundColor: AppColors.logocolor,
          )
        ],
      ),
      body: isLoading || currentUser == null || url == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(url.profilePhoto),
                          radius: 33,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: textFeildcontroller,
                            decoration: const InputDecoration(
                              hintText: "What's in your mind ?",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        )
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((file) => Image.file(file)).toList(),
                        options: CarouselOptions(
                          height: 300,
                          enableInfiniteScroll: false,
                        ),
                      )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
          color: AppColors.greyColor,
          width: 0.4,
        ))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () {
                    print(url);
                  },
                  icon: SvgPicture.asset(AssetsConsts.emojiIcon,
                      color: AppColors.logocolor)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AssetsConsts.gifIcon,
                      color: AppColors.logocolor)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: pickImages,
                  icon: SvgPicture.asset(AssetsConsts.galleryIcon,
                      color: AppColors.logocolor)),
            ),
          ],
        ),
      ),
    );
  }
}
