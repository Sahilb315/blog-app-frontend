import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/home/ui/blog_page.dart';
import 'package:blog_app/features/profile/profile_provider.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final UserTokenModel userTokenModel;
  const ProfilePage({super.key, required this.userTokenModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchUsersBlogs(widget.userTokenModel.id);
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(
                CupertinoIcons.pencil_ellipsis_rectangle,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    foregroundImage: NetworkImage(
                      widget.userTokenModel.profilePic,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userTokenModel.username,
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
                              "${widget.userTokenModel.followers.length} followers"),
                          const Text(" • "),
                          Text(
                              "${widget.userTokenModel.following.length} following"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                "Your Stories",
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
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.usersBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = provider.usersBlogs[index];
                      DateTime formattedDate = formatISODate(blog.createdAt!);
                      final gap = DateTime.now().difference(formattedDate);
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      BlogPage(blogModel: blog),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeIn;

                                var tween = Tween(begin: begin, end: end)
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: const BorderRadius.all(
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
                                    Row(
                                      children: [
                                        const Icon(CupertinoIcons.bookmark),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        PopupMenuButton(
                                          color: appBgColor,
                                          child: const Icon(
                                              Icons.more_vert_rounded),
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                height: 30,
                                                child: const Text("Delete"),
                                                onTap: () => provider
                                                    .deleteBlogById(blog.id!),
                                              ),
                                            ];
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
