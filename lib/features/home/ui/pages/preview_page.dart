// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/home/provider/home_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/models/blog_model.dart';

class BlogPreviewPage extends StatefulWidget {
  final BlogModel blogModel;
  final String userId;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController linkController;

  const BlogPreviewPage({
    super.key,
    required this.blogModel,
    required this.userId,
    required this.titleController,
    required this.contentController,
    required this.linkController,
  });

  @override
  State<BlogPreviewPage> createState() => _BlogPreviewPageState();
}

class _BlogPreviewPageState extends State<BlogPreviewPage> {
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
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                context.read<HomeProvider>().addNewBlog(
                      blogModel: BlogModel(
                        thumbnail: widget.blogModel.thumbnail,
                        title: widget.blogModel.title,
                        content: widget.blogModel.content,
                      ),
                      userId: widget.userId,
                    );
                Navigator.pop(context);
                Navigator.pop(context);
                widget.titleController.clear();
                widget.contentController.clear();
                widget.linkController.clear();

                context.read<PickImageProvider>().setDoesImageExist(false);
                context.read<PickImageProvider>().setImageFile(null);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade500.withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Text(
                  "Publish",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(widget.blogModel.thumbnail)),
                      ),
                      border: Border.all(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.blogModel.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
                                          word.substring(1, word.length - 1);
                                      try {
                                        if (link.startsWith("https://")) {
                                          await launchUrl(Uri.parse(link));
                                        } else {
                                          await launchUrl(
                                              Uri.parse("https://$link"));
                                        }
                                      } catch (e) {
                                        log("Error: $e");
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
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
