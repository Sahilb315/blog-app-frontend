import 'package:blog_app/features/profile/controllers/profile_controller.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/material.dart';

class InfoProfileProvider extends ChangeNotifier {
  UserModel? _otherUserModel;
  UserModel? _currentUserModel;
  String? _errorMessage;
  bool _isEditing = false;
  bool _isProfilePicUpdated = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get otherUserModel => _otherUserModel;
  UserModel? get currentUserModel => _currentUserModel;
  bool get isEditing => _isEditing;
  bool get isProfilePicUpdated => _isProfilePicUpdated;

  void setIsEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void setIsProfilePicUpdated(bool value) {
    _isProfilePicUpdated = value;
    notifyListeners();
  }

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

  Future<String?> updateProfilePic({
    required String userId,
    required String profilePicPath,
    required UserTokenModel userTokenModel,
  }) async {
    _isLoading = true;
    notifyListeners();
    final result = await ProfileController.updateUserProfilePic(
      userId: userId,
      profilePicPath: profilePicPath,
    );
    if (result.isUserProfileUpdated) {
      _currentUserModel!.profilePic = result.profilePicUrl!;
      _isProfilePicUpdated = true;
      _isLoading = false;
      notifyListeners();
      return result.profilePicUrl!;
    } else {
      _errorMessage = result.errorMessage;
      _isProfilePicUpdated = false;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
