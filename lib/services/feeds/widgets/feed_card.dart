// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twichat/consts/asset_const.dart';
import 'package:twichat/consts/enums/post_type_enum.dart';
import 'package:twichat/consts/theme/app_color.dart';
import 'package:twichat/models/post_model.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/feeds/controller/feed_controller.dart';
import 'package:twichat/services/feeds/views/feed_reply.dart';
import 'package:twichat/services/feeds/widgets/hashtag_text.dart';
import 'package:twichat/services/feeds/widgets/post_icons_widget.dart';
import 'package:twichat/services/feeds/widgets/show_image.dart';
import 'package:twichat/widgets/error_page.dart';
import 'package:twichat/widgets/loading.dart';
import 'package:timeago/timeago.dart';

class FeedCard extends ConsumerWidget {
  final PostModel _postModel;
  const FeedCard({
    super.key,
    required PostModel postModel,
  }) : _postModel = postModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(currentUserDetailsProvider).value;
    if (currUser == null) {
      return const Loader();
    }
    return ref.watch(userDetailsProvider(_postModel.uid)).when(
      data: (user) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, FeedReplyScreen.route(_postModel));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePhoto),
                      radius: 28,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                format(
                                  _postModel.postedAt,
                                  locale: 'en_short',
                                ),
                                style: const TextStyle(
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: HashtagText(text: _postModel.text),
                          ),
                          if (_postModel.posttype == PostType.image)
                            ShowCarousel(imageUrls: _postModel.imageUrls),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PostIconsWidget(
                                  iconPath: AssetsConsts.viewsIcon,
                                  text: (_postModel.likes.length +
                                          _postModel.comments.length +
                                          _postModel.reShares.length)
                                      .toString(),
                                  ontap: () {}),
                              LikeButton(
                                size: 22,
                                onTap: (isLiked) async {
                                  ref
                                      .watch(postControllerProvider.notifier)
                                      .likePost(
                                        postModel: _postModel,
                                        context: context,
                                        user: currUser,
                                        uid: user.uid,
                                      );
                                  return !isLiked;
                                },
                                isLiked: _postModel.likes.contains(user.uid),
                                likeBuilder: ((isLiked) {
                                  return isLiked
                                      ? SvgPicture.asset(
                                          AssetsConsts.likeFilledIcon,
                                          color: AppColors.redColor,
                                        )
                                      : SvgPicture.asset(
                                          AssetsConsts.likeOutlinedIcon,
                                          color: AppColors.greyColor,
                                        );
                                }),
                                likeCount: _postModel.likes.length,
                                countBuilder: (likeCount, isLiked, text) {
                                  return Text(
                                    text,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isLiked
                                            ? AppColors.redColor
                                            : AppColors.greyColor),
                                  );
                                },
                              ),
                              PostIconsWidget(
                                  iconPath: AssetsConsts.commentIcon,
                                  text: (_postModel.comments.length).toString(),
                                  ontap: () {}),
                              PostIconsWidget(
                                  iconPath: AssetsConsts.reShareIcon,
                                  text: (_postModel.reShares.length).toString(),
                                  ontap: () {}),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: AppColors.greyColor,
                  height: .90,
                )
              ],
            ),
          ),
        );
      },
      error: (e, st) {
        return const SizedBox(
            height: 100, child: ErrorPage(error: "Something error occured :("));
      },
      loading: () {
        return const SizedBox(height: 100, child: LoadingPage());
      },
    );
  }
}
