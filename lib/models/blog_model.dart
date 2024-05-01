// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:blog_app/models/user_model.dart';

class BlogModel {
  final String? id;
  final String thumbnail;
  final String title;
  final String content;
  final List<String>? links;
  final dynamic createdBy;
  final String? createdAt;
  final String? updatedAt;
  
  BlogModel({
    this.id,
    required this.thumbnail,
    required this.title,
    required this.content,
    this.links,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });


  BlogModel copyWith({
    String? id,
    String? thumbnail,
    String? title,
    String? content,
    List<String>? links,
    UserModel? createdBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      content: content ?? this.content,
      links: links ?? this.links,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'thumbnail': thumbnail,
      'title': title,
      'content': content,
      'links': links,
      'createdBy': createdBy?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      thumbnail: map['thumbnail'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      links: map['links'] != null ? List.from((map['links'] as List)) : null,
      createdBy: map['createdBy'].runtimeType != String ? UserModel.fromMap(map['createdBy'] as Map<String,dynamic>) : map['createdBy'].toString(),
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModel.fromJson(String source) => BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlogModel(id: $id, thumbnail: $thumbnail, title: $title, content: $content, links: $links, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BlogModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.thumbnail == thumbnail &&
      other.title == title &&
      other.content == content &&
      listEquals(other.links, links) &&
      other.createdBy == createdBy &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      thumbnail.hashCode ^
      title.hashCode ^
      content.hashCode ^
      links.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
