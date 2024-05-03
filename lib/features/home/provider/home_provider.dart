import 'package:blog_app/features/home/controllers/blog_controllers.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  List<BlogModel> _blogs = [];
  String? _errorMessage;
  bool _isLoading = false;
  String? _bookmarkMessage;
  UserModel? _user;
  bool _isFloatingBtnVisible = true;

  String? get errorMessage => _errorMessage;
  String? get bookmarkMessage => _bookmarkMessage;
  List<BlogModel> get blogs => _blogs;
  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  bool get isFloatingBtnVisible => _isFloatingBtnVisible;

  void updateUserProfilePic(String profilePic) {
    _user!.profilePic = profilePic;
    notifyListeners();
  }

  void setFloatingBtnVisible(bool value) {
    _isFloatingBtnVisible = value;
    notifyListeners();
  }

  void currentUserDeletedBlog(String blogId) {
    _blogs.removeWhere((element) => element.id == blogId);
    notifyListeners();
  }

  Future<void> getUserModel(String userId) async {
    final result = await BlogController.getUserModel(userId);
    if (result.isUserFetched) {
      _user = result.userModel;
    } else {
      _errorMessage = result.errorMessage;
    }
  }

  Future<void> fetchAllBlogs(String userId) async {
    _isLoading = true;
    final blogData = await BlogController.getAllBlogs();
    await getUserModel(userId);
    if (blogData.areBlogsFetched) {
      _blogs = blogData.blogs!;
    } else {
      _errorMessage = blogData.errorMessage;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewBlog({
    required BlogModel blogModel,
    required String userId,
  }) async {
    _isLoading = true;
    notifyListeners();
    final blogData = await BlogController.addNewBlog(
      blogModel: blogModel,
      userId: userId,
    );
    if (blogData.isBlogAdded) {
      _blogs.add(blogData.blog!);
    } else {
      _errorMessage = blogData.errorMessage;
    }

    _isLoading = false;
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
      if (user!.bookmarks.contains(blogModel.id)) {
        user!.bookmarks.remove(blogModel.id);
      } else {
        user!.bookmarks.add(blogModel.id);
      }
    } else {
      _errorMessage = result.errorMessage;
    }
    notifyListeners();
  }
}
