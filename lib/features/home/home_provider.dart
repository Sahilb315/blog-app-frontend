import 'package:blog_app/features/home/controllers/blog_controllers.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  List<BlogModel> _blogs = [];
  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  List<BlogModel> get blogs => _blogs;
  bool get isLoading => _isLoading;

  Future<void> fetchAllBlogs() async {
    _isLoading = true;
    final blogData = await BlogController.getAllBlogs();
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
}
