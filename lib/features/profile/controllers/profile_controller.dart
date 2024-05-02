import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileController {
  static Future<UserData> followUnFollowUser({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      final body = jsonEncode({
        'currentUserId': currentUserId,
        'otherUserId': otherUserId,
      });
      final res = await http.patch(
        Uri.parse(
          "${dotenv.env['BASE_URL']}/user/follow",
        ),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(res.body);
      if (data['status'] as bool) {
        return UserData(
          isUserFetched: true,
        );
      } else {
        return UserData(
          errorMessage: data['message'],
          isUserFetched: false,
        );
      }
    } catch (e) {
      log("Error while following/unfollowing user: ${e.toString()}");
      return UserData(
        errorMessage: e.toString(),
        isUserFetched: false,
      );
    }
  }
}

class UserData {
  final String? errorMessage;
  final bool isUserFetched;

  UserData({
    this.errorMessage,
    required this.isUserFetched,
  });
}
