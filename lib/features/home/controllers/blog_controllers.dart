import 'dart:convert';
import 'dart:developer';
import 'package:blog_app/models/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlogController {
  static Future<BlogsData> getAllBlogs() async {
    try {
      final res = await http.get(Uri.parse("${dotenv.env['BASE_URL']}/blog/"));
      final jsonData = jsonDecode(res.body);
      List listOfBlogs = jsonData['blogs'];
      if (jsonData['status'] as bool) {
        List<BlogModel> blogs =
            listOfBlogs.map((blog) => BlogModel.fromMap(blog)).toList();
        return BlogsData(blogs: blogs, areBlogsFetched: true);
      } else {
        return BlogsData(
          errorMessage: jsonData['message'],
          areBlogsFetched: false,
        );
      }
    } catch (error) {
      log("Error while fetching all blogs: ${error.toString()}");
      return BlogsData(errorMessage: error.toString(), areBlogsFetched: false);
    }
  }

  static Future<SingleBlogData> addNewBlog({
    required String userId,
    required BlogModel blogModel,
  }) async {
    try {
      final body = jsonEncode({
        "title": blogModel.title,
        "content": blogModel.content,
        "createdBy": userId,
        "links": blogModel.links,
      });
      final req = http.MultipartRequest(
        "POST",
        Uri.parse("${dotenv.env['BASE_URL']}/blog/"),
      );

      req.files.add(
        await http.MultipartFile.fromPath("thumbnail", blogModel.thumbnail),
      );

      req.fields['json'] = body;
      final streamedResponse = await req.send();
      final res = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(res.body);

      if (data['status'] as bool) {
        final blog = BlogModel.fromMap(data['blog']);

        return SingleBlogData(
          blog: blog,
          isBlogAdded: true,
        );
      } else {
        return SingleBlogData(
          errorMessage: data['message'],
          isBlogAdded: false,
        );
      }
    } catch (e) {
      log("Error while adding a blog: ${e.toString()}");
      return SingleBlogData(
        errorMessage: e.toString(),
        isBlogAdded: false,
      );
    }
  }

  static Future<BlogsData> getAllBlogsBySpecificUser(String userId) async {
    try {
      final res = await http.get(
        Uri.parse("${dotenv.env['BASE_URL']}/user/profile/$userId"),
      );
      final jsonData = jsonDecode(res.body);
      if (jsonData['status'] as bool) {
        List listOfBlogs = jsonData['blogs'];
        List<BlogModel> blogs =
            listOfBlogs.map((blog) => BlogModel.fromMap(blog)).toList();

        return BlogsData(
          blogs: blogs,
          areBlogsFetched: true,
        );
      } else {
        return BlogsData(
          areBlogsFetched: false,
          errorMessage: jsonData['message'],
        );
      }
    } catch (e) {
      log("Error while fetching users all blogs: ${e.toString()}");
      return BlogsData(
        areBlogsFetched: false,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<SingleBlogData> deleteBlogById(String blogId) async {
    try {
      final res = await http
          .delete(Uri.parse("${dotenv.env['BASE_URL']}/blog/$blogId"));
      final jsonData = jsonDecode(res.body);

      if (jsonData['status'] as bool) {
        final blog = BlogModel.fromMap(jsonData['blog']);
        return SingleBlogData(
          blog: blog,
          isBlogAdded: true,
        );
      } else {
        return SingleBlogData(
          errorMessage: jsonData['message'],
          isBlogAdded: false,
        );
      }
    } catch (e) {
      log("Error while deleting a blog: ${e.toString()}");

      return SingleBlogData(
        errorMessage: e.toString(),
        isBlogAdded: false,
      );
    }
  }
}

class SingleBlogData {
  final BlogModel? blog;
  final String? errorMessage;
  final bool isBlogAdded;

  SingleBlogData({this.blog, this.errorMessage, required this.isBlogAdded});
}

class BlogsData {
  final List<BlogModel>? blogs;
  final String? errorMessage;
  final bool areBlogsFetched;

  BlogsData({
    this.blogs,
    this.errorMessage,
    required this.areBlogsFetched,
  });
}
