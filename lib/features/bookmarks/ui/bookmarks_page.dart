import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/bookmarks/bookmark_provider.dart';
import 'package:blog_app/features/home/ui/pages/blog_page.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/error_handler.dart';

class BookmarksPage extends StatefulWidget {
  final UserTokenModel userTokenModel;
  const BookmarksPage({super.key, required this.userTokenModel});

  @override
  State<BookmarksPage> createState() => _BoomMarksPageState();
}

class _BoomMarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    Provider.of<BookmarkProvider>(context, listen: false)
        .getUsersBookmarks(widget.userTokenModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        title: const Text('Your Bookmarks'),
        centerTitle: false,
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.brown,
                strokeCap: StrokeCap.round,
                strokeWidth: 3.5,
              ),
            );
          } else if (provider.errorMessage != null) {
            return ErrorHandler(
              errorMessage: provider.errorMessage!,
            );
          } else {
            return provider.usersBookmarks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.news,
                          size: 48,
                        ),
                        Text(
                          "No blogs bookmarked",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.usersBookmarks.length,
                            itemBuilder: (context, index) {
                              final blog = provider.usersBookmarks[index];
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
                                          BlogPage(blogModel: blog),
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
                                            InkWell(
                                              onTap: () {
                                                provider.bookmarkBlog(
                                                  userId:
                                                      widget.userTokenModel.id,
                                                  blogModel: blog,
                                                  userTokenModel:
                                                      widget.userTokenModel,
                                                );
                                              },
                                              child: const Icon(
                                                CupertinoIcons.clear,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}
