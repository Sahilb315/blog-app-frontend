import 'dart:io';

import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/constants/error_handler.dart';
import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/home/provider/home_provider.dart';
import 'package:blog_app/features/home/ui/pages/blog_page.dart';
import 'package:blog_app/features/profile/providers/profile_info_provider.dart';
import 'package:blog_app/features/profile/providers/profile_provider.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserId;
  final UserModel otherUserModel;
  final UserModel currentUserModel;
  final UserTokenModel userTokenModel;
  const ProfilePage({
    super.key,
    required this.otherUserModel,
    required this.currentUserId,
    required this.currentUserModel,
    required this.userTokenModel,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchUsersBlogs(widget.otherUserModel.id!);
    Provider.of<InfoProfileProvider>(context, listen: false).setUserModel(
      widget.otherUserModel,
      widget.currentUserModel,
    );
    super.initState();
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> getImage(BuildContext context) async {
    final pickImageProvider = context.read<PickImageProvider>();
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (!context.mounted) return;
    if (pickedFile != null) {
      pickImageProvider.setImageFile(File(pickedFile.path));
      pickImageProvider.setDoesImageExist(true);
    } else {
      pickImageProvider.setDoesImageExist(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        leading: context.read<InfoProfileProvider>().isEditing
            ? IconButton(
                iconSize: 20,
                icon: const Icon(CupertinoIcons.clear),
                onPressed: () {
                  final pickImageProvider = context.read<PickImageProvider>();
                  pickImageProvider.setImageFile(null);
                  pickImageProvider.setDoesImageExist(false);
                  context.read<InfoProfileProvider>().setIsEditing(false);
                },
              )
            : IconButton(
                icon: const Icon(CupertinoIcons.back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          /// If the current user is the same as the other user, then show the edit icon
          widget.currentUserId == widget.otherUserModel.id!

              /// If isEditing is true then show the checkmark icon otherwise show the edit icon
              ? context.watch<InfoProfileProvider>().isEditing
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () async {
                          final infoProfileProvider =
                              context.read<InfoProfileProvider>();
                          final pickImageProvider =
                              context.read<PickImageProvider>();
                          final homeProvider = context.read<HomeProvider>();

                          /// Update the new user details & set isEditing to false
                          final result = await context
                              .read<InfoProfileProvider>()
                              .updateProfilePic(
                                userTokenModel: widget.userTokenModel,
                                userId: widget.currentUserId,
                                profilePicPath:
                                    pickImageProvider.imageFile!.path,
                              );
                          if (!context.mounted) return;

                          /// Updating the profile pic in all the blogs by the user in profile page
                          Provider.of<ProfileProvider>(context, listen: false)
                              .fetchUsersBlogs(widget.otherUserModel.id!);

                          /// Updating the profile pic in all the blogs by the user in home page
                          homeProvider.fetchAllBlogs(widget.currentUserId);
                          infoProfileProvider.setIsProfilePicUpdated(false);
                          pickImageProvider.setImageFile(null);
                          pickImageProvider.setDoesImageExist(false);
                          infoProfileProvider.setIsEditing(false);
                          if (result != null) {
                            /// Updating the profile pic of the user in the home page(Drawer)
                            homeProvider.updateUserProfilePic(result);
                          }
                        },
                        child: const Icon(
                          CupertinoIcons.checkmark_alt,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          /// Set isEditing to true
                          context
                              .read<InfoProfileProvider>()
                              .setIsEditing(true);
                        },
                        child: const Icon(
                          Iconsax.edit_outline,
                        ),
                      ),
                    )
              : const SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<InfoProfileProvider>(
                builder: (context, provider, child) {
                  final isEditing = provider.isEditing;
                  if (provider.errorMessage != null) {
                    return ErrorHandler(
                      errorMessage: provider.errorMessage!,
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<PickImageProvider>(
                        builder: (context, value, child) {
                          if (provider.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(
                                color: Colors.brown,
                                strokeWidth: 3,
                                strokeCap: StrokeCap.round,
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                /// If isEditing is true only then perfoem the action otherwise return
                                if (!isEditing) return;
                                getImage(context);
                              },
                              child: Stack(
                                children: [
                                  isEditing && value.doesImageExist
                                      ? provider.isProfilePicUpdated
                                          ? CircleAvatar(
                                              radius: 32,
                                              backgroundImage: NetworkImage(
                                                widget.currentUserModel
                                                    .profilePic,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 32,
                                              backgroundImage: FileImage(
                                                value.imageFile!,
                                              ),
                                            )
                                      : CircleAvatar(
                                          radius: 32,
                                          backgroundImage: NetworkImage(
                                            widget.otherUserModel.profilePic,
                                          ),
                                        ),
                                  isEditing
                                      ? Positioned(
                                          right: 0,
                                          child: Icon(
                                            Iconsax.card_edit_outline,
                                            color: Colors.grey.shade400,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.otherUserModel.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                "${widget.otherUserModel.followers.length} followers",
                              ),
                              const Text(" • "),
                              Text(
                                "${widget.otherUserModel.following.length} following",
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          widget.currentUserId != widget.otherUserModel.id!
                              ? GestureDetector(
                                  onTap: () => provider.followUnFollowUser(
                                    currentUserId: widget.currentUserId,
                                    otherUserId: widget.otherUserModel.id!,
                                  ),
                                  child: provider.otherUserModel!.followers
                                          .contains(widget.otherUserModel.id!)
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(32),
                                            ),
                                            border: Border.all(
                                              color: Colors.brown.shade300,
                                            ),
                                          ),
                                          child: const Text(
                                            "Followed",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(32),
                                            ),
                                            color: Colors.brown.shade300,
                                          ),
                                          child: const Text(
                                            "Follow",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                widget.currentUserId == widget.otherUserModel.id!
                    ? "Your Stories"
                    : "Stories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 3.5,
                        color: Colors.brown,
                      ),
                    );
                  } else {
                    return provider.usersBlogs.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.news,
                                  size: 48,
                                ),
                                Text(
                                  "No blogs posted",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.usersBlogs.length,
                            itemBuilder: (context, index) {
                              final blog = provider.usersBlogs[index];
                              DateTime formattedDate =
                                  formatISODate(blog.createdAt!);
                              final gap =
                                  DateTime.now().difference(formattedDate);
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          BlogPage(
                                        blogModel: blog,
                                        currentUserId: widget.currentUserId,
                                        currentUserModel:
                                            widget.currentUserModel,
                                        userTokenModel: widget.userTokenModel,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = const Offset(1.0, 0.0);
                                        var end = Offset.zero;
                                        var curve = Curves.easeIn;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(13),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                blog.title,
                                                maxLines: 4,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              height: 100,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    blog.thumbnail,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  foregroundImage: NetworkImage(
                                                    blog.createdBy!.profilePic,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "${blog.createdBy!.username}\n${calculateTimeGap(gap)}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            widget.currentUserId ==
                                                    widget.otherUserModel.id!
                                                ? PopupMenuButton(
                                                    color: appBgColor,
                                                    child: const Icon(Icons
                                                        .more_vert_rounded),
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem(
                                                          height: 30,
                                                          child: const Text(
                                                            "Delete",
                                                          ),
                                                          onTap: () {
                                                            provider
                                                                .deleteBlogById(
                                                              blog.id!,
                                                            );
                                                            context
                                                                .read<
                                                                    HomeProvider>()
                                                                .currentUserDeletedBlog(
                                                                    blog.id!);
                                                          },
                                                        ),
                                                      ];
                                                    },
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
