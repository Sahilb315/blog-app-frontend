import 'dart:developer';

import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/profile/ui/profile_page.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPage extends StatefulWidget {
  final BlogModel blogModel;
  final String currentUserId;
  final UserModel currentUserModel;
  const BlogPage({
    super.key,
    required this.blogModel,
    required this.currentUserId,
    required this.currentUserModel,
  });

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late List<String> allWords;

  List<String> extractWords(String content) {
    final List<String> words = [];
    final RegExp linkPattern = RegExp(r'\[([^\]]+)\]');
    // The matches list containes the links
    final matches = linkPattern.allMatches(content);
    int start = 0;

    for (final match in matches) {
      /// The linktext is pure text which the use enterted
      final linkText = match.group(1);
      if (linkText != null) {
        /// The text before the link is added
        words.addAll(content.substring(start, match.start).trim().split(' '));

        /// Then the link text is added
        words.add('[$linkText]');
        start = match.end;
      }
    }
    if (start < content.length) {
      words.addAll(content.substring(start).trim().split(' '));
    }
    return words;
  }

  @override
  void initState() {
    allWords = extractWords(widget.blogModel.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime formattedDate = formatISODate(widget.blogModel.createdAt!);
    // final gap = DateTime.now().difference(formattedDate);
    List splitDate = formattedDate.toString().split(' ');
    final date = splitDate[0];

    // final time = splitDate[1].toString().split('.').first;
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.blogModel.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        otherUserModel: widget.blogModel.createdBy,
                        currentUserId: widget.currentUserId,
                        currentUserModel: widget.currentUserModel,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      foregroundImage: NetworkImage(
                        widget.blogModel.createdBy!.profilePic,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${widget.blogModel.createdBy!.username} • ",
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                "Follow",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(calculateDate(date.toString())),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 200,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.blogModel.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                  children: [
                    for (final word in allWords)
                      word.startsWith('[') && word.endsWith(']')
                          ? TextSpan(
                              text: "${word.substring(
                                1,
                                word.length - 1,
                              )} ",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final link =
                                      word.substring(1, word.length - 1).trim();
                                  try {
                                    if (link.startsWith("https://")) {
                                      await launchUrl(Uri.parse(link));
                                    } else {
                                      await launchUrl(
                                          Uri.parse("https://$link"));
                                    }
                                  } catch (e) {
                                    log("Error while opening a link: $e");
                                  }
                                },
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            )
                          : TextSpan(
                              text: '$word ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
