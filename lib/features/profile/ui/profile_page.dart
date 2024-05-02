import 'dart:developer';

import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/constants/error_handler.dart';
import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/home/ui/pages/blog_page.dart';
import 'package:blog_app/features/profile/providers/profile_info_provider.dart';
import 'package:blog_app/features/profile/providers/profile_provider.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserId;
  final UserModel otherUserModel;
  final UserModel currentUserModel;
  const ProfilePage({
    super.key,
    required this.otherUserModel,
    required this.currentUserId,
    required this.currentUserModel,
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
    log("UserModel: ${widget.otherUserModel}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        actions: [
          widget.currentUserId == widget.otherUserModel.id!
              ? Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      CupertinoIcons.pencil_ellipsis_rectangle,
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
                  if (provider.errorMessage != null) {
                    return ErrorHandler(
                      errorMessage: provider.errorMessage!,
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        foregroundImage: NetworkImage(
                          widget.otherUserModel.profilePic,
                        ),
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
                                                              "Delete"),
                                                          onTap: () => provider
                                                              .deleteBlogById(
                                                            blog.id!,
                                                          ),
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
