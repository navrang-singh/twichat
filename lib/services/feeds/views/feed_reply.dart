// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/models/post_model.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/feeds/widgets/feed_card.dart';
import 'package:twichat/utils.dart';
import 'package:twichat/widgets/error_page.dart';
import 'package:twichat/widgets/loading.dart';
import 'package:twichat/widgets/rounded_button.dart';

import '../controller/feed_controller.dart';

class FeedReplyScreen extends ConsumerStatefulWidget {
  final PostModel _postModel;
  static route(PostModel postModel) => MaterialPageRoute(
        builder: (context) => FeedReplyScreen(postModel: postModel),
      );
  const FeedReplyScreen({required PostModel postModel, super.key})
      : _postModel = postModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeedReplyScreenState();
}

class _FeedReplyScreenState extends ConsumerState<FeedReplyScreen> {
  final TextEditingController textFeildcontroller = TextEditingController();
  List<File> images = [];

  void ontap({required String repliedTo, required String uid}) {
    final res = ref.watch(userDetailsProvider(uid)).value!;
    ref.read(postControllerProvider.notifier).sharePost(
          images: images,
          text: textFeildcontroller.text,
          context: context,
          repliedTo: repliedTo,
          user: res,
        );
  }

  void pickImages() async {
    images = await pickAllImages();
    setState(() {});
  }

  Widget _bottomNavbar(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
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
            ),
            RoundedButton(
                lable: "Post",
                ontap: () {
                  ontap(
                      repliedTo: widget._postModel.id,
                      uid: widget._postModel.uid);
                  // Navigator.pop(context);
                  textFeildcontroller.clear();
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: ref.watch(commentlistProvider(widget._postModel.id)).when(
        data: (data) {
          return ref.watch(getlatestcommentProvider(widget._postModel.id)).when(
            data: (comment) {
              PostModel post = PostModel.fromMap(comment.payload);
              if (post.repliedTo == widget._postModel.id &&
                  !data.contains(post)) {
                print("post kiya hu abhi !");
                data.insert(0, post);
              }
              print(post.toString());
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return FeedCard(postModel: post);
                },
              );
            },
            error: (e, st) {
              return const SizedBox(
                  height: 100,
                  child: ErrorPage(error: "Something error occured :("));
            },
            loading: () {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return FeedCard(postModel: post);
                },
              );
            },
          );
          // return ListView.builder(
          //   padding: const EdgeInsets.all(10),
          //   itemCount: data.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final post = data[index];
          //     return FeedCard(postModel: post);
          //   },
          // );
        },
        error: (e, st) {
          return const SizedBox(
              height: 100,
              child: ErrorPage(error: "Something error occured :("));
        },
        loading: () {
          return const SizedBox(height: 100, child: LoadingPage());
        },
      ),
      bottomNavigationBar: _bottomNavbar(context),
    );
    // return const Center(
    //   child: Text("main reply screen hu"),
    // );
  }
}
