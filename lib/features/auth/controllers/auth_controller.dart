import 'dart:convert';
import 'dart:developer';

import 'package:blog_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthController {
  static Future<String?> signUpUser(UserModel userModel) async {
    try {
      final body = jsonEncode({
        "username": userModel.username,
        "email": userModel.email,
        "password": userModel.password,
      });
      final res = await http.post(
        Uri.parse("${dotenv.env['BASE_URL']}/user/register"),
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );
      final data = jsonDecode(res.body);

      if (data['status'] as bool) {
        return null;
      } else {
        return data['message'];
      }
    } catch (e) {
      log("Error while signing up user $e");
      return e.toString();
    }
  }

  static Future<String?> loginUser(String email, String password) async {
    try {
      final body = jsonEncode({
        "email": email,
        "password": password,
      });
      final res = await http.post(
        Uri.parse("${dotenv.env['BASE_URL']}/user/login"),
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );
      final data = jsonDecode(res.body);
      log(data.toString());

      if (data['status'] as bool) {
        return data['token'].toString();
      } else {
        return data['message'];
      }
    } catch (e) {
      log("Error while user login $e");
      return null;
    }
  }
}
