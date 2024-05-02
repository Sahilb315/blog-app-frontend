import 'package:blog_app/features/profile/controllers/profile_controller.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:flutter/material.dart';

class InfoProfileProvider extends ChangeNotifier {
  UserModel? _otherUserModel;
  UserModel? _currentUserModel;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  UserModel? get otherUserModel => _otherUserModel;
  UserModel? get currentUserModel => _currentUserModel;

  void setUserModel(UserModel otherUserModel, UserModel currentUserModel) {
    _otherUserModel = otherUserModel;
    _currentUserModel = currentUserModel;
  }

  Future<void> followUnFollowUser({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final result = await ProfileController.followUnFollowUser(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
    if (result.isUserFetched) {
      bool doesUserFollow = _currentUserModel!.following.contains(otherUserId);
      if (doesUserFollow) {
        _currentUserModel!.following.remove(otherUserId);
        _otherUserModel!.followers.remove(otherUserId);
      } else {
        _currentUserModel!.following.add(otherUserId);
        _otherUserModel!.followers.add(otherUserId);
      }
      notifyListeners();
    } else {
      /// If there is an error while following/unfollowing user
      _errorMessage = result.errorMessage;
      notifyListeners();
    }
  }
}
