// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/home/home_provider.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/features/home/ui/add_blog_page.dart';
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
  List<String> matched = [];

  void getAllLinks(
    String name,
  ) {
    name.split("[").forEach((element) {
      if (element.contains("]")) {
        final pat = element.split(']')[0];
        matched.add(pat);
      }
    });
  }

  late List<String> words;

  @override
  void initState() {
    getAllLinks(widget.blogModel.content);
    words = widget.blogModel.content.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            FluentSystemIcons.ic_fluent_dismiss_regular,
            color: Colors.grey.shade700,
          ),
        ),
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
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      children: [
                        ...words.map(
                          (word) {
                            if (word.startsWith('[') && word.endsWith(']')) {
                              log(word);
                              word.split("[").forEach((element) {
                                if (element.contains("]")) {
                                  word = element.split(']')[0];
                                }
                              });
                            }
                            if (matched.contains(word)) {
                              return TextSpan(
                                text: "$word ",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    try {
                                      await launchUrl(
                                          Uri.parse("https://$word"));
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      displayToastMessage(
                                          context, e.toString());
                                    }
                                  },
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              );
                            } else {
                              return TextSpan(
                                text: "$word ",
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              );
                            }
                          },
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
