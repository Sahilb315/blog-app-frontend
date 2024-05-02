// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:blog_app/models/blog_model.dart';

// class UserModel {
//   final String profilePic;
//   final String? id;
//   final String username;
//   final String email;
//   final String password;
//   final String? createdAt;
//   final String? updatedAt;
//   final List<UserModel> followers;
//   final List<UserModel> following;
//   final List<dynamic> bookmarks;

//   UserModel({
//     required this.profilePic,
//     this.id,
//     required this.username,
//     required this.email,
//     required this.password,
//     this.createdAt,
//     this.updatedAt,
//     required this.followers,
//     required this.following,
//     required this.bookmarks,
//   });


//   UserModel copyWith({
//     String? profilePic,
//     String? id,
//     String? username,
//     String? email,
//     String? password,
//     String? createdAt,
//     String? updatedAt,
//     List<UserModel>? followers,
//     List<UserModel>? following,
//     List<BlogModel>? bookmarks,
//   }) {
//     return UserModel(
//       profilePic: profilePic ?? this.profilePic,
//       id: id ?? this.id,
//       username: username ?? this.username,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       followers: followers ?? this.followers,
//       following: following ?? this.following,
//       bookmarks: bookmarks ?? this.bookmarks,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'profilePic': profilePic,
//       '_id': id,
//       'username': username,
//       'email': email,
//       'password': password,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'followers': followers.map((x) => x.toMap()).toList(),
//       'following': following.map((x) => x.toMap()).toList(),
//       'bookmarks': bookmarks.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       profilePic: map['profilePic'] as String,
//       id: map['_id'] != null ? map['_id'] as String : null,
//       username: map['username'] as String,
//       email: map['email'] as String,
//       password: map['password'] as String,
//       createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
//       updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
//       followers: List<UserModel>.from((map['followers'] as List).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>))),
//       following: List<UserModel>.from((map['following'] as List).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>))),
//       bookmarks: List.from(map['bookmarks']).isNotEmpty && List.from(map['bookmarks']).first is! String ? List.from((map['bookmarks'] as List).map((x) => BlogModel.fromMap(x as Map<String,dynamic>))) : List.from(map['bookmarks']) 
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'UserModel(profilePic: $profilePic, _id: $id, username: $username, email: $email, password: $password, createdAt: $createdAt, updatedAt: $updatedAt, followers: $followers, following: $following, bookmarks: $bookmarks)';
//   }

//   @override
//   bool operator ==(covariant UserModel other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.profilePic == profilePic &&
//       other.id == id &&
//       other.username == username &&
//       other.email == email &&
//       other.password == password &&
//       other.createdAt == createdAt &&
//       other.updatedAt == updatedAt &&
//       listEquals(other.followers, followers) &&
//       listEquals(other.following, following) &&
//       listEquals(other.bookmarks, bookmarks);
//   }

//   @override
//   int get hashCode {
//     return profilePic.hashCode ^
//       id.hashCode ^
//       username.hashCode ^
//       email.hashCode ^
//       password.hashCode ^
//       createdAt.hashCode ^
//       updatedAt.hashCode ^
//       followers.hashCode ^
//       following.hashCode ^
//       bookmarks.hashCode;
//   }
// }
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:blog_app/models/blog_model.dart';

class UserModel {
  final String profilePic;
  final String? id;
  final String username;
  final String email;
  final String password;
  final String? createdAt;
  final String? updatedAt;
  final List<String> followers;
  final List<String> following;
  final List<dynamic> bookmarks;
  UserModel({
    required this.profilePic,
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.createdAt,
    this.updatedAt,
    required this.followers,
    required this.following,
    required this.bookmarks,
  });


  UserModel copyWith({
    String? profilePic,
    String? id,
    String? username,
    String? email,
    String? password,
    String? createdAt,
    String? updatedAt,
    List<String>? followers,
    List<String>? following,
    List<dynamic>? bookmarks,
  }) {
    return UserModel(
      profilePic: profilePic ?? this.profilePic,
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profilePic': profilePic,
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'followers': followers,
      'following': following,
      'bookmarks': bookmarks,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      profilePic: map['profilePic'] as String,
      id: map['_id'] != null ? map['_id'] as String : null,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      followers: List<String>.from((map['followers'] as List)),
      following: List<String>.from((map['following'] as List)),
      bookmarks: List.from(map['bookmarks']).isNotEmpty && List.from(map['bookmarks']).first is! String ? List.from((map['bookmarks'] as List).map((x) => BlogModel.fromMap(x as Map<String,dynamic>))) : List.from(map['bookmarks']) 
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(profilePic: $profilePic, id: $id, username: $username, email: $email, password: $password, createdAt: $createdAt, updatedAt: $updatedAt, followers: $followers, following: $following, bookmarks: $bookmarks)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.profilePic == profilePic &&
      other.id == id &&
      other.username == username &&
      other.email == email &&
      other.password == password &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      listEquals(other.bookmarks, bookmarks);
  }

  @override
  int get hashCode {
    return profilePic.hashCode ^
      id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      password.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      bookmarks.hashCode;
  }
}
