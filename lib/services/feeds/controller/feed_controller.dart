import 'dart:io' as dartio;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/apis/notification_api.dart';
import 'package:twichat/apis/post_api.dart';
import 'package:twichat/apis/storage_api.dart';
import 'package:twichat/consts/enums/notification_type_enum.dart';
import 'package:twichat/consts/enums/post_type_enum.dart';
import 'package:twichat/models/notification_model.dart';
import 'package:twichat/models/post_model.dart';
import 'package:twichat/models/user_model.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/widgets/snackbar.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postapi: ref.watch(postAPIProvider),
    notificationapi: ref.watch(notificationAPIProvider),
  );
});

final postlistProvider = FutureProvider((ref) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final commentlistProvider = FutureProvider.family((ref, String postId) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getComments(postId: postId);
});

final getlatestpostProvider = StreamProvider.autoDispose((ref) {
  final postapi = ref.watch(postAPIProvider);
  return postapi.getlatestPost();
});

final getlatestcommentProvider =
    StreamProvider.autoDispose.family((ref, String postId) {
  final postapi = ref.watch(postAPIProvider);
  return postapi.getlatestComment(postId);
});

class PostController extends StateNotifier<bool> {
  final Ref _ref;
  final PostAPI _postapi;
  final NotificationAPI _notificationapi;
  PostController(
      {required Ref ref,
      required PostAPI postapi,
      required NotificationAPI notificationapi})
      : _ref = ref,
        _postapi = postapi,
        _notificationapi = notificationapi,
        super(false);

  Future<List<PostModel>> getPosts() async {
    final postlist = await _postapi.getDocuments();
    return postlist.map((post) => PostModel.fromMap(post.data)).toList();
  }

  Future<List<PostModel>> getComments({required String postId}) async {
    final doc = await _postapi.getDocumentbyID(postId);
    PostModel post = PostModel.fromMap(doc.data);
    List<String> comments = post.comments;
    final postlist = await _postapi.getComments(comments);
    return postlist.map((post) => PostModel.fromMap(post.data)).toList();
  }

  void sharePost({
    required List<dartio.File> images,
    required String text,
    required BuildContext context,
    String? repliedTo,
    UserModel? user,
  }) {
    if (text.isEmpty) {}

    if (images.isNotEmpty) {
      _sharePostTextWithImage(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        user: user,
      );
    } else {
      _sharePostText(
        text: text,
        context: context,
        repliedTo: repliedTo,
        user: user,
      );
    }
  }

  void likePost({
    required PostModel postModel,
    required BuildContext context,
    required UserModel user,
    required String uid,
  }) async {
    List<String> likes = [];
    likes = postModel.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    PostModel p = postModel.copyWith(likes: likes);
    final res = await _postapi.likepost(p);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) async {
      showSnackBar(context, "posted successfully !");
      final notification = NotificationModel(
        text: '${user.name} likes your post',
        postId: p.id,
        notificationType: NotificationType.like,
        uid: p.uid,
        id: '',
      );
      await _notificationapi.createNotification(notification);
    });
  }

  void commentsPost({
    required PostModel postModel,
    required BuildContext context,
    required String postId,
    required UserModel user,
  }) async {
    List<String> comments = [];
    comments = postModel.comments;
    if (!comments.contains(postId)) {
      comments.add(postId);
    }

    PostModel p = postModel.copyWith(comments: comments);
    final res = await _postapi.commentpost(p);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) async {
      showSnackBar(context, "posted successfully !");
      final notification = NotificationModel(
        text: '${user.name} replied your post',
        postId: p.id,
        notificationType: NotificationType.reply,
        uid: p.uid,
        id: '',
      );
      await _notificationapi.createNotification(notification);
    });
  }

  void _sharePostTextWithImage({
    required List<dartio.File> images,
    required String text,
    required BuildContext context,
    String? repliedTo,
    UserModel? user,
  }) async {
    state = true;
    final userId = _ref.watch(currAccountUserProvider).value!.$id;
    List<String> hashtags = _getHashTags(text);
    List<String> links = _getLinks(text);
    List<String> imageUrls =
        await _ref.watch(storageAPIProvider).uploadImages(images);
    PostModel post = PostModel(
      text: text,
      hashtags: hashtags,
      links: links,
      imageUrls: imageUrls,
      uid: userId,
      posttype: PostType.image,
      postedAt: DateTime.now(),
      comments: [],
      likes: [],
      id: '',
      reShares: [],
      repliedTo: repliedTo ?? '',
    );
    final res = await _postapi.sharePost(post);
    state = false;
    repliedTo = repliedTo ?? '';
    final res2 = (repliedTo != '' && repliedTo != ' ')
        ? await _postapi.getDocumentbyID(repliedTo)
        : null;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (res2 != null) {
        PostModel rp = PostModel.fromMap(r.data);
        PostModel p = PostModel.fromMap(res2.data);
        commentsPost(
            postModel: p, context: context, postId: rp.id, user: user!);
      }

      // Navigator.pop(context);
    });
  }

  void _sharePostText({
    required String text,
    required BuildContext context,
    String? repliedTo,
    UserModel? user,
  }) async {
    state = true;
    final userId = _ref.watch(currAccountUserProvider).value!.$id;
    List<String> hashtags = _getHashTags(text);
    List<String> links = _getLinks(text);
    PostModel post = PostModel(
      text: text,
      hashtags: hashtags,
      links: links,
      imageUrls: const [],
      uid: userId,
      posttype: PostType.text,
      postedAt: DateTime.now(),
      comments: [],
      likes: [],
      id: '',
      reShares: [],
      repliedTo: repliedTo ?? '',
    );
    final res = await _postapi.sharePost(post);
    state = false;
    repliedTo = repliedTo ?? '';
    final res2 = (repliedTo != '' && repliedTo != ' ')
        ? await _postapi.getDocumentbyID(repliedTo)
        : null;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (res2 != null) {
        PostModel rp = PostModel.fromMap(r.data);
        PostModel p = PostModel.fromMap(res2.data);
        commentsPost(
            postModel: p, context: context, postId: rp.id, user: user!);
      }

      // Navigator.pop(context);
    });
  }

  List<String> _getHashTags(String text) {
    List<String> hashtags = [];
    List<String> textSplit = text.split(' ');
    for (String t in textSplit) {
      if (t.startsWith("#")) {
        hashtags.add(t);
      }
    }
    return hashtags;
  }

  List<String> _getLinks(String text) {
    List<String> links = [];
    List<String> textSplit = text.split(' ');
    for (String t in textSplit) {
      if (t.startsWith("http://") ||
          t.startsWith("www.") ||
          t.startsWith("https://")) {
        links.add(t);
      }
    }
    return links;
  }
}
