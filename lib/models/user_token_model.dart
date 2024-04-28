// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:blog_app/models/blog_model.dart';
import 'package:blog_app/models/user_model.dart';

class UserTokenModel {
  final String id;
  final String profilePic;
  final String username;
  final String email;
  final List<UserModel> followers;
  final List<UserModel> following;
  final List<BlogModel> bookmarks;

  UserTokenModel({
    required this.id,
    required this.profilePic,
    required this.username,
    required this.email,
    required this.followers,
    required this.following,
    required this.bookmarks,
  });
  

  UserTokenModel copyWith({
    String? id,
    String? profilePic,
    String? username,
    String? email,
    List<UserModel>? followers,
    List<UserModel>? following,
    List<BlogModel>? bookmarks,
  }) {
    return UserTokenModel(
      id: id ?? this.id,
      profilePic: profilePic ?? this.profilePic,
      username: username ?? this.username,
      email: email ?? this.email,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'profilePic': profilePic,
      'username': username,
      'email': email,
      'followers': followers.map((x) => x.toMap()).toList(),
      'following': following.map((x) => x.toMap()).toList(),
      'bookmarks': bookmarks.map((x) => x.toMap()).toList(),
    };
  }

  factory UserTokenModel.fromMap(Map<String, dynamic> map) {
    return UserTokenModel(
      id: map['_id'] as String,
      profilePic: map['profilePic'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      followers: List<UserModel>.from((map['followers'] as List).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>),),),
      following: List<UserModel>.from((map['following'] as List).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>),),),
      bookmarks: List<BlogModel>.from((map['bookmarks'] as List).map<BlogModel>((x) => BlogModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTokenModel.fromJson(String source) => UserTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserTokenModel(id: $id, profilePic: $profilePic, username: $username, email: $email, followers: $followers, following: $following, bookmarks: $bookmarks)';
  }

  @override
  bool operator ==(covariant UserTokenModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.profilePic == profilePic &&
      other.username == username &&
      other.email == email &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      listEquals(other.bookmarks, bookmarks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      profilePic.hashCode ^
      username.hashCode ^
      email.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      bookmarks.hashCode;
  }
}
