import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String name;
  final List<String> follower;
  final List<String> following;
  final String profilePhoto;
  final String bannerPhoto;
  final String bio;
  final String uid;
  final bool isVerified;
  UserModel({
    required this.email,
    required this.name,
    required this.follower,
    required this.following,
    required this.profilePhoto,
    required this.bannerPhoto,
    required this.bio,
    required this.uid,
    required this.isVerified,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? follower,
    List<String>? following,
    String? profilePhoto,
    String? bannerPhoto,
    String? bio,
    String? uid,
    bool? isVerified,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bannerPhoto: bannerPhoto ?? this.bannerPhoto,
      bio: bio ?? this.bio,
      uid: uid ?? this.uid,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'follower': follower});
    result.addAll({'following': following});
    result.addAll({'profilePhoto': profilePhoto});
    result.addAll({'bannerPhoto': bannerPhoto});
    result.addAll({'bio': bio});
    result.addAll({'isVerified': isVerified});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      follower: List<String>.from(map['follower']),
      following: List<String>.from(map['following']),
      profilePhoto: map['profilePhoto'] ??
          'https://cdn.pixabay.com/photo/2016/05/30/14/23/detective-1424831_1280.png',
      bannerPhoto: map['bannerPhoto'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['\$id'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, follower: $follower, following: $following, profilePhoto: $profilePhoto, bannerPhoto: $bannerPhoto, bio: $bio, uid: $uid, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        listEquals(other.follower, follower) &&
        listEquals(other.following, following) &&
        other.profilePhoto == profilePhoto &&
        other.bannerPhoto == bannerPhoto &&
        other.bio == bio &&
        other.uid == uid &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        follower.hashCode ^
        following.hashCode ^
        profilePhoto.hashCode ^
        bannerPhoto.hashCode ^
        bio.hashCode ^
        uid.hashCode ^
        isVerified.hashCode;
  }
}
