import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/appwrite_const.dart';
import 'package:twichat/models/post_model.dart';
import 'package:twichat/services/feeds/controller/feed_controller.dart';
import 'package:twichat/services/feeds/widgets/feed_card.dart';
import 'package:twichat/widgets/error_page.dart';
import 'package:twichat/widgets/loading.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(postlistProvider).when(
      data: (posts) {
        return ref.watch(getlatestpostProvider).when(data: (data) {
          if (data.events.contains(
              'databases.*.collections.${AppwriteConsts.userPostCollectionID}.documents.*.create')) {
            PostModel post = PostModel.fromMap(data.payload);
            if ((post.repliedTo == ' ' || post.repliedTo == '') &&
                (!posts.contains(post))) {
              posts.insert(0, post);
            }
            // print("ander hu main");
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts[index];
              return FeedCard(postModel: post);
            },
          );
        }, error: (e, st) {
          return const ErrorPage(error: "Something error occured :(");
        }, loading: () {
          // print("loader ka hai ye sb");
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts[index];
              return FeedCard(postModel: post);
            },
          );
        });
      },
      error: (e, st) {
        return const ErrorPage(error: "Something error occured :(");
      },
      loading: () {
        return const Loader();
      },
    );
  }
}
