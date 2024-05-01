import 'package:blog_app/features/home/controllers/blog_controllers.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/material.dart';

class BookmarkProvider extends ChangeNotifier {
  List<BlogModel> _usersBookmarks = [];
  String? _errorMessage;
  bool isLoading = false;

  String? get errorMessage => _errorMessage;
  List<BlogModel> get usersBookmarks => _usersBookmarks;

  Future<void> getUsersBookmarks(String userId) async {
    isLoading = true;
    final result = await BlogController.getUserBookmarks(userId);

    if (result.areBlogsFetched) {
      _usersBookmarks = result.blogs!;
    } else {
      _errorMessage = result.errorMessage;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> bookmarkBlog({
    required String userId,
    required BlogModel blogModel,
    required UserTokenModel userTokenModel,
  }) async {
    final result = await BlogController.bookmarkBlog(blogModel.id!, userId);

    /// If the response from the server is successful
    if (result.areBlogsFetched) {
      _usersBookmarks.remove(blogModel);
    } else {
      _errorMessage = result.errorMessage;
    }
    notifyListeners();
  }
}
