import 'package:blog_app/features/home/controllers/blog_controllers.dart';
import 'package:flutter/cupertino.dart';

import '../../models/blog_model.dart';

class ProfileProvider extends ChangeNotifier {
  List<BlogModel> _usersBlogs = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<BlogModel> get usersBlogs => _usersBlogs;
  bool get isLoading => _isLoading;

  Future<void> fetchUsersBlogs(String userId) async {
    _isLoading = true;

    final result = await BlogController.getAllBlogsBySpecificUser(userId);
    if (result.areBlogsFetched) {
      _usersBlogs = result.blogs!;
    } else {
      _errorMessage = result.errorMessage;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteBlogById(String blogId) async {
    _isLoading = true;
    notifyListeners();
    final result = await BlogController.deleteBlogById(blogId);

    /// If blog is deleted successfully
    if (result.isBlogAdded) {
      _usersBlogs.remove(result.blog!);
    } else {
      _errorMessage = result.errorMessage;
    }
    _isLoading = false;
    notifyListeners();
  }
}
