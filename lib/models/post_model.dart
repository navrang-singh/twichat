import 'package:flutter/foundation.dart';

import 'package:twichat/consts/enums/post_type_enum.dart';

class PostModel {
  final String text;
  final List<String> hashtags;
  final List<String> links;
  final List<String> imageUrls;
  final String uid;
  final PostType posttype;
  final String id;
  final DateTime postedAt;
  final List<String> comments;
  final List<String> likes;
  final List<String> reShares;
  final String repliedTo;
  PostModel({
    required this.text,
    required this.hashtags,
    required this.links,
    required this.imageUrls,
    required this.uid,
    required this.posttype,
    required this.id,
    required this.postedAt,
    required this.comments,
    required this.likes,
    required this.reShares,
    required this.repliedTo,
  });

  PostModel copyWith({
    String? text,
    List<String>? hashtags,
    List<String>? links,
    List<String>? imageUrls,
    String? uid,
    PostType? posttype,
    String? id,
    DateTime? postedAt,
    List<String>? comments,
    List<String>? likes,
    List<String>? reShares,
    String? repliedTo,
  }) {
    return PostModel(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      links: links ?? this.links,
      imageUrls: imageUrls ?? this.imageUrls,
      uid: uid ?? this.uid,
      posttype: posttype ?? this.posttype,
      id: id ?? this.id,
      postedAt: postedAt ?? this.postedAt,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      reShares: reShares ?? this.reShares,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'links': links});
    result.addAll({'imageUrls': imageUrls});
    result.addAll({'uid': uid});
    result.addAll({'posttype': posttype.type});
    result.addAll({'repliedTo': repliedTo});
    result.addAll({'postedAt': postedAt.millisecondsSinceEpoch});
    result.addAll({'comments': comments});
    result.addAll({'likes': likes});
    result.addAll({'reShares': reShares});

    return result;
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      links: List<String>.from(map['links']),
      imageUrls: List<String>.from(map['imageUrls']),
      uid: map['uid'] ?? '',
      posttype: (map['posttype'] as String).toEnumPostType(),
      id: map['\$id'] ?? '',
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
      comments: List<String>.from(map['comments']),
      likes: List<String>.from(map['likes']),
      reShares: List<String>.from(map['reShares']),
      repliedTo: map['repliedTo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PostModel(text: $text, hashtags: $hashtags, links: $links, imageUrls: $imageUrls, uid: $uid, posttype: $posttype, id: $id, postedAt: $postedAt, comments: $comments, likes: $likes, reShares: $reShares, repliedTo: $repliedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.links, links) &&
        listEquals(other.imageUrls, imageUrls) &&
        other.uid == uid &&
        other.posttype == posttype &&
        other.id == id &&
        other.postedAt == postedAt &&
        listEquals(other.comments, comments) &&
        listEquals(other.likes, likes) &&
        listEquals(other.reShares, reShares) &&
        other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        links.hashCode ^
        imageUrls.hashCode ^
        uid.hashCode ^
        posttype.hashCode ^
        id.hashCode ^
        postedAt.hashCode ^
        comments.hashCode ^
        likes.hashCode ^
        reShares.hashCode ^
        repliedTo.hashCode;
  }
}
